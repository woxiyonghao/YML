//
//  GameDetailScrollView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/10/20.
//

import UIKit
import ObjectMapper

class GameDetailScrollView: UIScrollView {

    var updateDownloadButtonTitleCallback: (_: String) -> Void = { title in }
    
    private var collectionViewDatas: [SimpleGameModel] = []
    
    /// 可传入TopicGameModel或者SearchGameModel类型的数据
    var collectionModels: [GameModel] = [] {
        didSet {
            collectionViewDatas = []
            for model in collectionModels {
                if model is TopicGameModel {
                    let newModel = ModelManager.shared.getSimpleGameModelFrom(model: (model as! TopicGameModel), excludeVideo: true)
                    collectionViewDatas.append(newModel)
                }
                else if model is SearchGameModel {
                    let newModel = ModelManager.shared.getSimpleGameModelFrom(model: (model as! SearchGameModel))
                    collectionViewDatas.append(newModel)
                }
            }
            
            gameCollectionView.collectionViewDatas = collectionViewDatas
            gameCollectionView.reloadData()
            scrollTo(indexPath: focusIndexPath)// 初始focusIndexPath由外界传入
            
            if focusIndexPath.row < 0 || focusIndexPath.row >= collectionViewDatas.count {
                return
            }
            initGameInfoView(gameID: String(collectionViewDatas[focusIndexPath.row].id))
        }
    }
    
    var focusIndexPath = IndexPath(row: 0, section: 0)
    private var lineCellWidths: [CGFloat] = [superBigCardWidth(), bigCardWidth(), bigCardWidth()]// 每行卡片的宽度
    private var lineCellHeights: [CGFloat] = [superBigCardHeight(), bigCardHeight(), bigCardHeight()]// 每行卡片的高度
    private let lineSpacing: CGFloat = 50// 行间距
    private var linesScales: [CGFloat] = []// 每行的Focus卡片的缩放比例，会变化
    var currentLine: Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit() {
        contentInsetAdjustmentBehavior = .never
        decelerationRate = .fast
        showsVerticalScrollIndicator = false
        
        // 设定初始放大倍数，仅作用于Focus cell
        for _ in 0..<lineCellWidths.count {
            linesScales.append(1.2)
        }
        
        initSubviews()
    }
    func useSmallStyle() {
        self.lineCellWidths = [smallCardWidth(), smallCardWidth(), smallCardWidth()]// 每行卡片的宽度
        self.lineCellHeights = [smallCardHeight(), smallCardHeight(), smallCardHeight()]// 每行卡片的高度
    }
    
    var collectionStartTag = 888
    var gameCollectionView: GameCollectionView!
    func initSubviews() {
        let cellWidth = lineCellWidths[0]
        let cellHeight = lineCellHeights[0]
        // 创建CollectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize.init(width: cellWidth, height: cellHeight)
        // ❗️collectionView的height必须大于卡片的height，否则报错（这里设为1.2倍才不报错）
        gameCollectionView = GameCollectionView.init(frame: CGRect.init(x: 0, y: 32, width: UIScreen.main.bounds.width, height: cellHeight*1.2), collectionViewLayout: flowLayout)
        addSubview(gameCollectionView)
        gameCollectionView.isHidden = true
        gameCollectionView.tag = collectionStartTag
        gameCollectionView.cellScale = linesScales[0]
        gameCollectionView.backgroundColor = .clear
        gameCollectionView.isDisplayPurely = true
        gameCollectionView.isFocusing = true
        gameCollectionView.collectionViewDatas = collectionViewDatas
        gameCollectionView.selectGameCallback = { indexPath in
            if indexPath.row < 0 || indexPath.row >= self.collectionViewDatas.count {
                return
            }
            
            self.initGameInfoView(gameID: String(self.collectionViewDatas[indexPath.row].id))
        }
    }
    
    var infoViewTag = 1111
    var infoView = GameInfoView(frame: CGRect.zero)
    func initGameInfoView(gameID: String) {
        let oldInfoView = viewWithTag(infoViewTag)
        if oldInfoView != nil {
            oldInfoView?.removeFromSuperview()
        }
        
        // 新建一个infoView
        infoView = GameInfoView(frame: CGRect.zero)
        infoView.tag = infoViewTag
        addSubview(infoView)
        infoView.gameID = gameID
        infoView.didUpdateContentHeight = { height in
            // <Eggshell.GameInfoView: 0x10171a0f0; frame = (0 296; 812 553); tag = 1111; layer = <CALayer: 0x2828d3d20>>
            self.infoView.frame = CGRect(x: 0, y: CGRectGetMaxY(self.gameCollectionView.frame), width: CGRectGetWidth(self.frame), height: height)
            
            // 更新contentSize
            self.contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: self.infoView.frame.origin.y + CGRectGetHeight(self.infoView.frame) + 40)
        }
        
        infoView.updateDownloadButtonTitleCallback = { title in
            self.updateDownloadButtonTitleCallback(title)
        }
    }
    
    func scrollTo(indexPath: IndexPath) {
        delay(interval: 0.1) {
            let collectionView = self.viewWithTag(self.collectionStartTag) as? GameCollectionView
            collectionView?.focusIndexPath = indexPath
            collectionView?.updateLayout(animated: true)
        }
    }
    
    func downloadGame() {
        print("当前选中的row：", focusIndexPath.row)
        if gameCollectionView.focusIndexPath.row < 0 || gameCollectionView.focusIndexPath.row >= collectionViewDatas.count {
            return
        }
        
        // URL Schemes从详情接口获取
        let detailModel = infoView.detailModel
        GameManager.shared.openGame(urlSchemes: detailModel?.urlSchemes ?? [], platforms: detailModel?.platforms ?? [])
    }
    
    // MARK: 分享
    func shareGame() {
        if gameCollectionView.focusIndexPath.row < 0 || gameCollectionView.focusIndexPath.row >= collectionViewDatas.count {
            return
        }
        
        let gameModel = collectionViewDatas[gameCollectionView.focusIndexPath.row]
        let gameName = gameModel.name
        let downloadUrl = GameManager.shared.getDownloadUrlString(fromModel: gameModel)
        var systemSharePage: UIActivityViewController
        if downloadUrl == "" {
            systemSharePage = UIActivityViewController.init(activityItems: [gameName], applicationActivities: nil)
        }
        else {
            systemSharePage = UIActivityViewController.init(activityItems: [gameName, URL.init(string: downloadUrl)!], applicationActivities: nil)
        }
        
        if systemSharePage.responds(to: NSSelectorFromString("popoverPresentationController")) {
            systemSharePage.popoverPresentationController?.sourceView = self
        }
        UIViewController.current()?.present(systemSharePage, animated: true, completion: nil)
        systemSharePage.completionWithItemsHandler = { activityType, finish, returnedItems, activityError in
            if finish {
                print("分享成功")
            }
            else {
                print("分享出错：", activityError as Any)
            }
        }
    }
    
    // MARK: 手柄操控
    func gamepadKeyUpAction() {
        currentLine = currentLine-1
        scrollToCurrentLine()
    }
    
    func gamepadKeyDownAction() {
        currentLine = currentLine+1
        scrollToCurrentLine()
    }
    
    func scrollToCurrentLine() {
        if currentLine < 0 {
            currentLine = 0
            appPlayIneffectiveSound()
            return
        }
        
        let perOffsetY = bigCardHeight()+80// 可修改
        var offsetY = CGFloat(currentLine)*(perOffsetY)
        // 前3行的偏移量固定
        if infoView.highlightsLineTitleTop > 0.0 {
            if currentLine == 1 {
                offsetY = infoView.highlightsLineTitleTop + CGRectGetMaxY(gameCollectionView.frame)
            }
        }
        if infoView.screenshotsLineTitleTop > 0.0 {
            if infoView.highlightsLineTitleTop == 0.0 {
                if currentLine == 1 {
                    offsetY = infoView.screenshotsLineTitleTop + CGRectGetMaxY(gameCollectionView.frame)
                }
            }
            else {
                if currentLine == 2 {
                    offsetY = infoView.screenshotsLineTitleTop + CGRectGetMaxY(gameCollectionView.frame)
                }
            }
        }
        var maxOffsetY = CGRectGetMaxY(infoView.frame)-UIScreen.main.bounds.size.height
        if maxOffsetY < 0 {
            maxOffsetY = 0
        }
        var isDownToBottom = false
        if offsetY > maxOffsetY {
            offsetY = maxOffsetY
            isDownToBottom = true
        }
        let minOffsetY = 0.0
        if offsetY < minOffsetY {
            offsetY = minOffsetY
        }
//        print("偏移量：", offsetY)
        self.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        
        // 放在最后计算，以免影响offsetY值
        let maxLine = Int(maxOffsetY/perOffsetY)
        if currentLine > maxLine {
            currentLine = maxLine
        }
        
        if maxOffsetY == 0.0 || isDownToBottom {
            appPlayIneffectiveSound()
        }
        else {
            appPlayScrollSound()
        }
    }
    
    func gamepadKeyLeftAction() {
        if currentLine == 0 {
            let destIndexPath = IndexPath(row: gameCollectionView.focusIndexPath.row-1, section: gameCollectionView.focusIndexPath.section)
            if destIndexPath.row < 0 || destIndexPath.row >= collectionViewDatas.count {
                appPlayIneffectiveSound()
                return
            }
            
            appPlayScrollSound()
            focusIndexPath = destIndexPath
            gameCollectionView.focusIndexPath = destIndexPath
            gameCollectionView.updateLayout(animated: true)
            self.initGameInfoView(gameID: String(self.collectionViewDatas[destIndexPath.row].id))
        }
        else if currentLine == 1 {
            if infoView.highlightsLineTitleTop != 0.0 {
                infoView.highlightsCollectionView.gamepadKeyLeftAction()
            }
            else if infoView.screenshotsLineTitleTop != 0.0 {
                infoView.screenshotsCollectionView.gamepadKeyLeftAction()
            }
        }
        else if currentLine == 2 {
            if infoView.screenshotsLineTitleTop != 0.0 {
                infoView.screenshotsCollectionView.gamepadKeyLeftAction()
            }
        }
    }
    
    func gamepadKeyRightAction() {
        if currentLine == 0 {
            let destIndexPath = IndexPath(row: gameCollectionView.focusIndexPath.row+1, section: gameCollectionView.focusIndexPath.section)
            if destIndexPath.row < 0 || destIndexPath.row >= collectionViewDatas.count {
                appPlayIneffectiveSound()
                return
            }
            
            appPlayScrollSound()
            focusIndexPath = destIndexPath
            gameCollectionView.focusIndexPath = destIndexPath
            gameCollectionView.updateLayout(animated: true)
            initGameInfoView(gameID: String(collectionViewDatas[destIndexPath.row].id))
        }
        else if currentLine == 1 {
            appPlayScrollSound()
            if infoView.highlightsLineTitleTop != 0.0 {
                infoView.highlightsCollectionView.gamepadKeyRightAction()
            }
            else if infoView.screenshotsLineTitleTop != 0.0 {
                infoView.screenshotsCollectionView.gamepadKeyRightAction()
            }
        }
        else if currentLine == 2 {
            appPlayScrollSound()
            if infoView.screenshotsLineTitleTop != 0.0 {
                infoView.screenshotsCollectionView.gamepadKeyRightAction()
            }
        }
    }
}
