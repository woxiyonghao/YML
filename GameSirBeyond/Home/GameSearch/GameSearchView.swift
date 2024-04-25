//
//  GameSearchView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/1.
//

import UIKit
import Moya
import SwiftyJSON
import ObjectMapper

class GameSearchView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var closeButton: AnimatedButton!
    
    var allPlatformButtons: [UIButton] = []
    var didTapCloseButton = {}
    var didSelectGame: (_: SearchGameModel) -> Void = { gameModel in }
    var categoryId = 0 {
        didSet {// 筛选出指定分类的游戏
            
        }
    }
    var categoryName = ""
    
    @objc func injected() {
        //        for subview in platformBgView.subviews {
        //            subview.removeFromSuperview()
        //        }
        //        initPlatforms()
        //        collectionView?.removeFromSuperview()
        //        allModels = []
        //        getAllGames()
    }
    
    var contentView: UIView!
    func initSubviews() {
        IQKeyboardManager.shared.enable = false// 在手柄操作快速往上滑动时，该库导致UI往下移，暂时关闭
        
        addBlurEffect(style: .dark, alpha: 1)
        
        contentView = ((Bundle.main.loadNibNamed("GameSearchView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        closeButton.tapAction = {
            IQKeyboardManager.shared.enable = true
            self.didTapCloseButton()
        }
        closeButton.setControllerImage(type: .b)
        
        initGameList()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
    
    // MARK: 所有游戏数据
    var collectionViewDatas: [SearchGameModel] = []
    
    var collectionView: UICollectionView!
    func initGameList() {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionViewUseWidth = smallCardWidth()*3.0 + 8*2.0// 每行3张卡片
        let horiPadding = (CGRectGetWidth(frame)-collectionViewUseWidth)/2.0
        
        flowLayout.itemSize = CGSize.init(width: smallCardWidth(), height: smallCardHeight())
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 12, left: horiPadding, bottom: 0, right: horiPadding)
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: CGRectGetWidth(frame), height: CGRectGetHeight(frame)), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentView.addSubview(collectionView)
        collectionView.register(UINib(nibName: "SearchGameCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SearchGameCollectionViewCell")
        collectionView.register(UINib(nibName: "GameSearchHeaderView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GameSearchHeaderView")
        
        contentView.bringSubviewToFront(closeButton)
        collectionViewDatas = GameManager.shared.allGames
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchGameCollectionViewCell", for: indexPath) as! SearchGameCollectionViewCell
        if collectionViewDatas.count > indexPath.row && indexPath.row >= 0 {
            let model = collectionViewDatas[indexPath.row]
            cell.gameModel = model
        }
        return cell
    }
    
    var focusIndexPath = IndexPath(row: -1, section: 0)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastCell = collectionView.cellForItem(at: focusIndexPath) as? SearchGameCollectionViewCell
        let cell = collectionView.cellForItem(at: indexPath) as? SearchGameCollectionViewCell
        UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseInOut) {
            lastCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell?.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
        
        if collectionViewDatas.count > indexPath.row && indexPath.row >= 0 {
            let model = collectionViewDatas[indexPath.row]
            cell?.gameModel = model
            lastCell?.displayUnfocusView()
            cell?.displayFocusView()
            
            if indexPath == focusIndexPath {
                let model = collectionViewDatas[indexPath.row]
                didSelectGame(model)
                return
            }
        }
        
        focusIndexPath = indexPath
        scrollToFocusCell()
    }
    
    func scrollToFocusCell() {
        if focusIndexPath.row >= 0 && focusIndexPath.row < collectionViewDatas.count {
            //            print("移动collectionView")
            collectionView.scrollToItem(at: focusIndexPath, at: .centeredVertically, animated: true)
        }
    }
    
    var collectionHeaderView: GameSearchHeaderView!
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GameSearchHeaderView", for: indexPath) as! GameSearchHeaderView
        
        collectionHeaderView = headerView
        if categoryId != 0 {
            headerView.categoryLabel.isHidden = false
            headerView.categoryLabel.text = categoryName
            headerView.searchBar.isHidden = true
        }
        else {
            headerView.categoryLabel.isHidden = true
            headerView.searchBar.isHidden = false
            headerView.searchBar.searchTextField.becomeFirstResponder()// 立即开始搜索
        }
        
        for button in headerView.platformBgView.subviews {
            if button is UIButton {
                allPlatformButtons.append((button as! UIButton))
            }
        }
        
        headerView.didSearch = { keyword, platformID in
            self.searchGame(keyword: keyword, categoryId: self.categoryId, platformId: platformID)
        }
        return headerView
    }
    
    // MARK: 搜索游戏
    func searchGame(keyword: String? = "", categoryId: Int, platformId: Int = 0) {
       
        
        if GameManager.shared.allGames.count == 0 {// 未获取所有数据，暂缓搜索
            return
        }
       
        self.collectionViewDatas = GameManager.shared.allGames
        // 重置数据
//        self.focusIndexPath = IndexPath(row: -1, section: 0)
//        self.collectionViewDatas = []// 清空数据
//        
//        if keyword == "" && platformId == 0 && categoryId == 0 {
//            self.collectionViewDatas = GameManager.shared.allGames
//            collectionView.reloadData()
//            return
//        }
//        
//        // 遍历游戏，找到指定平台，以及游戏名包含关键字的游戏，修改数据，更新列表
//        print("搜索关键字：" + keyword! + "，平台ID：\(platformId)" + "，分类ID：\(categoryId)")
//        for model in GameManager.shared.allGames {
//            let gameName = model.name
//            var isFitCount = 0// 符合要求的次数，只有满足3个搜索条件才是目标游戏
//            if keyword == "" || gameName.contains(keyword!) {// 名字匹配
//                isFitCount += 1
//            }
//            if platformId == 0 {// 所有平台
//                isFitCount += 1
//            }
////            else {
////                let platforms = model.platforms
////                for aPlatform in platforms {
////                    if aPlatform.id == platformId {// 平台匹配
////                        isFitCount += 1
////                    }
////                }
////            }
////            if categoryId == 0 {// 所有分类
////                isFitCount += 1
////            }
////            else if model.categoryId == categoryId {
////                isFitCount += 1
////            }
////            if isFitCount == 3 {
////                self.collectionViewDatas.append(model)
////            }
//        }
//        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame), height: 133)
    }
    
    // MARK: 手柄操控
    func gamepadKeyUpAction() {
        if collectionHeaderView.searchBar.isHidden == false && collectionHeaderView.searchBar.searchTextField.isFirstResponder {
            appPlayIneffectiveSound()
            return
        }
        
        var highlightedButton: UIButton?
        for button in allPlatformButtons {
            if button.isHighlighted {
                highlightedButton = button
            }
        }
        
        if highlightedButton != nil {
            if collectionHeaderView.searchBar.isHidden {
                print("搜索框被隐藏")
                appPlayIneffectiveSound()
            }
            else {
                print("搜索框没有隐藏")
                highlightedButton!.isHighlighted = false
                // 问题：当collectionHeaderView.searchBar没有出现在页面中，becomeFirstResponder()操作无效，会导致
                collectionHeaderView.searchBar.searchTextField.becomeFirstResponder()
                appPlayScrollSound()
                print("搜索框Frame：",collectionHeaderView.searchBar.frame)
            }
            return
        }
        
        if focusIndexPath.row >= 0 && focusIndexPath.row <= 2 {// 游戏第一行
            let lastCell = collectionView.cellForItem(at: focusIndexPath)
            UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseInOut) {
                lastCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            focusIndexPath = IndexPath(row: -1, section: 0)
            
            highlightFirstPlatformButton()
            appPlayScrollSound()
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            return
        }
        
        if focusIndexPath.row-3 >= 0 {
            appPlayScrollSound()
            let destIndexPath = IndexPath(row: focusIndexPath.row-3, section: focusIndexPath.section)
            collectionView(collectionView, didSelectItemAt: destIndexPath)
        }
        else {
            appPlayIneffectiveSound()
        }
    }
    
    func gamepadKeyDownAction() {
        if collectionHeaderView.searchBar.isHidden == false && collectionHeaderView.searchBar.searchTextField.isFirstResponder {
            collectionHeaderView.searchBar.searchTextField.resignFirstResponder()
            highlightFirstPlatformButton()
            appPlayScrollSound()
            return
        }
        
        if focusIndexPath.row == -1 {
            if collectionHeaderView.searchBar.isHidden {
                var hasHighlightedButton = false
                for button in allPlatformButtons {
                    if button.isHighlighted {
                        hasHighlightedButton = true
                    }
                }
                
                if hasHighlightedButton == false {
                    highlightFirstPlatformButton()
                    appPlayScrollSound()
                    return
                }
            }
        }
        
        for button in allPlatformButtons {
            if button.isHighlighted {
                button.isHighlighted = false
                appPlayScrollSound()
                collectionView(collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                return
            }
        }
        
        if focusIndexPath.row+3 < collectionViewDatas.count {
            appPlayScrollSound()
            let destIndexPath = IndexPath(row: focusIndexPath.row+3, section: focusIndexPath.section)
            collectionView(collectionView, didSelectItemAt: destIndexPath)
        }
        else {
            appPlayIneffectiveSound()
        }
    }
    
    func gamepadKeyLeftAction() {
        if collectionHeaderView.searchBar.isHidden == false && collectionHeaderView.searchBar.searchTextField.isFirstResponder {
            appPlayIneffectiveSound()
            return
        }
        if allPlatformButtons.count > 0 {
            let destButton = allPlatformButtons[0]
            if destButton.isHighlighted {
                appPlayIneffectiveSound()
                return
            }
        }
        
        var highlightedIndex = -1
        for index in 0..<allPlatformButtons.count {
            let aButton = allPlatformButtons[index]
            if aButton.isHighlighted {
                highlightedIndex = index
                break
            }
        }
        if highlightedIndex != -1 {
            appPlayScrollSound()
            highlightLeftPlatformButton()
            return
        }
        
        if focusIndexPath.row-1 >= 0 {
            appPlayScrollSound()
            let destIndexPath = IndexPath(row: focusIndexPath.row-1, section: focusIndexPath.section)
            collectionView(collectionView, didSelectItemAt: destIndexPath)
        }
        else {
            appPlayIneffectiveSound()
        }
    }
    
    func gamepadKeyRightAction() {
        if collectionHeaderView.searchBar.isHidden == false && collectionHeaderView.searchBar.searchTextField.isFirstResponder {
            appPlayIneffectiveSound()
            return
        }
        
        if allPlatformButtons.count > 0 {
            let destButton = allPlatformButtons.last!
            if destButton.isHighlighted {
                appPlayIneffectiveSound()
                return
            }
        }
        
        var highlightedIndex = -1
        for index in 0..<allPlatformButtons.count {
            let aButton = allPlatformButtons[index]
            if aButton.isHighlighted {
                highlightedIndex = index
                break
            }
        }
        if highlightedIndex != -1 {
            appPlayScrollSound()
            highlightRightPlatformButton()
            return
        }
        
        if focusIndexPath.row+1 < collectionViewDatas.count {
            appPlayScrollSound()
            let destIndexPath = IndexPath(row: focusIndexPath.row+1, section: focusIndexPath.section)
            collectionView(collectionView, didSelectItemAt: destIndexPath)
        }
        else {
            appPlayIneffectiveSound()
        }
    }
    
    func gamepadKeyBAction() {
        closeButton.sendActions(for: .touchUpInside)
        appPlaySelectSound()
    }
    
    func highlightFirstPlatformButton() {
        for aButton in allPlatformButtons {
            aButton.isHighlighted = false
        }
        
        if allPlatformButtons.count > 0 {
            let button = allPlatformButtons[0]
            button.isHighlighted = true
        }
    }
    
    func highlightLeftPlatformButton() {
        // 当前highlight的index
        var highlightedIndex = -1
        for index in 0..<allPlatformButtons.count {
            let button = allPlatformButtons[index]
            if button.isHighlighted {
                highlightedIndex = index
            }
        }
        
        if highlightedIndex == -1 || highlightedIndex == 0 { return }
        
        // 关闭所有按钮的highlighted状态
        for button in allPlatformButtons {
            button.isHighlighted = false
        }
        
        // highlight左侧按钮
        let destIndex = highlightedIndex-1
        if allPlatformButtons.count > destIndex {
            let destButton = allPlatformButtons[destIndex]
            destButton.isHighlighted = true
        }
    }
    
    func highlightRightPlatformButton() {
        // 当前highlight的index
        var highlightedIndex = -1
        for index in 0..<allPlatformButtons.count {
            let button = allPlatformButtons[index]
            if button.isHighlighted {
                highlightedIndex = index
            }
        }
        
        if highlightedIndex == -1 || highlightedIndex == allPlatformButtons.count-1 { return }
        
        // 关闭所有按钮的highlighted状态
        for button in allPlatformButtons {
            button.isHighlighted = false
        }
        
        // highlight左侧按钮
        let destIndex = highlightedIndex+1
        if allPlatformButtons.count > destIndex {
            let destButton = allPlatformButtons[destIndex]
            destButton.isHighlighted = true
        }
    }
    
    func highlight(button: UIButton) {
        for aButton in allPlatformButtons {
            aButton.isHighlighted = false
        }
        
        for aButton in allPlatformButtons {
            if aButton == button {
                aButton.isHighlighted = true
            }
        }
    }
    
    func gamepadKeyAAction() {
        if collectionHeaderView.searchBar.searchTextField.isEditing {
            appPlaySelectSound()
            searchGame(keyword: collectionHeaderView.searchBar.searchTextField.text, categoryId: categoryId, platformId: collectionHeaderView.selectedPlatformID)
            return
        }
        
        for button in allPlatformButtons {
            if button.isHighlighted {
                appPlaySelectSound()
                button.sendActions(for: .touchUpInside)
                return
            }
        }
        
        appPlaySelectSound()
        collectionView(collectionView, didSelectItemAt: focusIndexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        endEditing(true)
    }
}
