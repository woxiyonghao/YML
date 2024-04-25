//
//  HighlightTagGameView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/5.
//

import UIKit
import Moya
import SwiftyJSON

class HighlightTagGameView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var backButton: AnimatedButton!
    @IBOutlet weak var skipButton: AnimatedButton!
    @IBOutlet weak var searchButton: AnimatedButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var focusIndexPath = IndexPath(row: -1, section: 0)// 默认不选中游戏

    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("HighlightTagGameView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        titleLabel.text = i18n(string: "Tag a game")
        skipButton.setTitle("  ".appending(i18n(string: "Skip")), for: .normal)
        searchButton.setTitle("  ".appending(i18n(string: "Search")), for: .normal)
        backButton.tapAction = {
            self.btnActionBack()
        }
        skipButton.tapAction = {
            self.btnActionSkip()
        }
        searchButton.tapAction = {
            self.btnActionSearch()
        }
        searchButton.setControllerImage(type: .y)
        skipButton.setControllerImage(type: .x)
        backButton.setControllerImage(type: .b)
        
        getAllGames()
        
        addGradientBackgroundColorIn(view: contentView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
    
    var collectionViewDatas: [SearchGameModel] = []
    func getAllGames() {
        if GameManager.shared.allGames.count > 0 {
            collectionViewDatas = GameManager.shared.allGames
            initGameList()
            return
        }
        
        let networker = MoyaProvider<GameService>()
        networker.request(.getGameList(platformID: nil, categoryID: nil, keyword: nil)) { result in
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 {
                    let gameList = (responseData["data"] as! [String: Any])["result"] as! [[String: Any]]
                    for game in gameList {
                        let model = SearchGameModel(JSONString: game.string()!)!
                        self.collectionViewDatas.append(model)
                    }
                    
//                    let model = SearchGameModel(JSONString: gameList[0].string()!)!
//                    self.collectionDatas.append(model)
                    
//                    print("获取游戏列表成功：", gameList)
                    self.initGameList()
                    
                    GameManager.shared.allGames = self.collectionViewDatas// 保存数据
                }
                else {
                    print("获取游戏列表失败", responseData["msg"]!)
                }
            }
            case .failure(_): do {
                print("网络错误")
            }
                break
            }
        }
    }
    
    var collectionView: UICollectionView!
    func initGameList() {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionViewUseWidth = smallCardWidth()*3.0 + 25*2.0 + smallCardWidth()*0.2// 每行显示3个游戏
//        let horiPadding = (CGRectGetWidth(frame)-collectionViewUseWidth)/2.0
        
        flowLayout.itemSize = CGSize.init(width: smallCardWidth(), height: smallCardHeight())
        flowLayout.minimumInteritemSpacing = 25
        flowLayout.minimumLineSpacing = 25
        flowLayout.sectionInset = UIEdgeInsets(top: smallCardWidth()*0.1, left: smallCardWidth()*0.1, bottom: smallCardWidth()*0.1, right: smallCardWidth()*0.1)
        
        let x = (CGRectGetWidth(frame)-collectionViewUseWidth)/2.0
        collectionView = UICollectionView.init(frame: CGRect.init(x: x, y: 60, width: collectionViewUseWidth, height: CGRectGetHeight(frame)-60-60), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        contentView.addSubview(collectionView)
        collectionView.register(UINib(nibName: "GameCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "GameCollectionViewCell")
        contentView.sendSubviewToBack(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        if collectionViewDatas.count > indexPath.row && indexPath.row > 0 {
            let model = collectionViewDatas[indexPath.row]
            cell.gameModel = ModelManager.shared.getSimpleGameModelFrom(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastCell = collectionView.cellForItem(at: focusIndexPath)
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseInOut) {
            lastCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        if indexPath == focusIndexPath {
            if collectionViewDatas.count > indexPath.row && indexPath.row > 0 {
                appPlaySelectSound()
                let model = collectionViewDatas[indexPath.row]
                CaptureManager.shared.highlightGameID = String(model.id)
                CaptureManager.shared.highlightCoverUrlFromGame = model.cover_image
                CaptureManager.shared.highlightGameName = model.name
                
                let destView = HighlightConfirmGameView(frame: self.bounds)
                self.superview?.addSubview(destView)
                self.removeFromSuperview()
            }
            return
        }
        
        focusIndexPath = indexPath
    }
    
    func btnActionBack() {
        displayHighlightNameView()
    }
    
    func btnActionSkip() {
        CaptureManager.shared.highlightGameID = ""
        displayPreviewView()
    }
    
    func btnActionSearch() {
        displaySearchView()
    }
    
    func displaySearchView() {
        let searchView = GameSearchView(frame: bounds)
        superview?.addSubview(searchView)
        searchView.didSelectGame = { model in
            CaptureManager.shared.highlightCoverUrlFromGame = model.cover_image
            CaptureManager.shared.highlightGameID = String(model.id)
            CaptureManager.shared.highlightGameName = model.name
            
            let destView = HighlightConfirmGameView(frame: self.bounds)
            self.superview?.addSubview(destView)
            
            searchView.removeFromSuperview()
            self.removeFromSuperview()
        }
        searchView.didTapCloseButton = {
            searchView.removeFromSuperview()
        }
    }
    
    func displayPreviewView() {
        let destView = HighlightPreviewView(frame: bounds)
        superview?.addSubview(destView)
        
        removeFromSuperview()
    }
    
    func displayHighlightNameView() {
        let destView = HighlightNameView(frame: bounds)
        superview?.addSubview(destView)
        
        removeFromSuperview()
    }
    
    // MARK: 手柄操控
    
    func gamepadKeyUpAction() {
        if focusIndexPath.row < 3 {
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        let destIndexPath = IndexPath(row: focusIndexPath.row-3, section: focusIndexPath.section)
        collectionView(collectionView, didSelectItemAt: destIndexPath)
        collectionView.scrollToItem(at: destIndexPath, at: .centeredVertically, animated: true)
    }
    
    func gamepadKeyDownAction() {
        let destRow = focusIndexPath.row+3
        if destRow > collectionViewDatas.count-1 {// 选中最后一行
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        let destIndexPath = IndexPath(row: destRow, section: focusIndexPath.section)
        collectionView(collectionView, didSelectItemAt: destIndexPath)
        collectionView.scrollToItem(at: destIndexPath, at: .centeredVertically, animated: true)
    }
    
    func gamepadKeyLeftAction() {
        if focusIndexPath.row == 0 {
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        let destIndexPath = IndexPath(row: focusIndexPath.row-1, section: focusIndexPath.section)
        collectionView(collectionView, didSelectItemAt: destIndexPath)
        collectionView.scrollToItem(at: destIndexPath, at: .centeredVertically, animated: true)
    }
    
    func gamepadKeyRightAction() {
        if focusIndexPath.row == collectionViewDatas.count-1 {
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        let destIndexPath = IndexPath(row: focusIndexPath.row+1, section: focusIndexPath.section)
        collectionView(collectionView, didSelectItemAt: destIndexPath)
        collectionView.scrollToItem(at: destIndexPath, at: .centeredVertically, animated: true)
    }
    
    func gamepadKeyAAction() {
        collectionView(collectionView, didSelectItemAt: focusIndexPath)
    }
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        backButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyXAction() {
        appPlaySelectSound()
        skipButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyYAction() {
        appPlaySelectSound()
        searchButton.sendActions(for: .touchUpInside)
    }
}
