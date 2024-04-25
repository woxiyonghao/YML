//
//  GameCollectionView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/10/13.
//

import UIKit
import ObjectMapper

class GameCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: 参数定义
    // 【Cell的个数】，三者关系：realCellCount == cellCount + emptyCellCount
    private var cellCount = 0// 可用cell的数量（区别于空白cell），初始化时由外界传入
    private var realCellCount = 0// 实际展示的cell数量
    private var emptyCellCount = 0// 空白cell的数量，作用：在CollectionView尾部增加几个Cell，以实现最后一个可用cell在屏幕左侧显示而不出现CollectionView左右移动的问题
    private let firstCellLeftPadding = 57.0// 【Focus cell与屏幕左侧的距离】
    private let cellSpacing = 16.0// 【Cell与Cell的距离】
    var focusIndexPath = IndexPath.init(row: 0, section: 0)// 当前选中的cell
    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()// 布局方法，由外界传入
    private var bigSize = CGSize(width: 0, height: 0)// 放大时的大小
    var cellSize = CGSize.init(width: 0.0, height: 0.0)// cell的大小，由FlowLayout传入
    var tapFocusingCell: (_: GameCollectionView, _ row: Int) -> Void = { view, row in }
    var isDisplayPurely = false
    var isFocusing = false {// 控制视频播放/停止
        didSet {
            controlCellDisplayThing()
        }
    }
    var index = 0
    var isCategoryTopic = false// 是分类主题
    var isProductIntroTopic = false// 是产品介绍主题
    var cellScale = 1.0 {// Focus cell的【放大倍数】，由外界传入，默认为1.0，不放大
        didSet {
            if cellScale <= 1.0 {// 表示此行未居中显示
//                isUserInteractionEnabled = false// 不允许交互
            }
            else {
//                isUserInteractionEnabled = true
            }
        }
    }
    
    var collectionViewDatas: [SimpleGameModel] = [] {
        didSet {
            cellCount = collectionViewDatas.count
            realCellCount = cellCount+emptyCellCount// 在布局前确定cell的数量
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let flowLayout = (layout as! UICollectionViewFlowLayout)
        cellSize = flowLayout.itemSize
        emptyCellCount = Int((UIScreen.main.bounds.size.width - firstCellLeftPadding - cellSize.width*cellScale) / (cellSize.width+cellSpacing)) + 1// 在初始化前，确定空白cell的数量。规则：最后一个空白cell的frame包含右侧屏幕边界
        bigSize = CGSize(width: cellSize.width*1.2, height: cellSize.height*1.2)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(UINib.init(nibName: "GameCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "GameCollectionViewCell")
        register(UINib.init(nibName: "EmptyCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EmptyCollectionViewCell")
        register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")

        delegate = self
        dataSource = self
        
        showsHorizontalScrollIndicator = false
        decelerationRate = .fast
        contentInsetAdjustmentBehavior = .never// 去掉系统根据机型设定的边距，以统一边距
        contentInset = UIEdgeInsets(top: 0, left: firstCellLeftPadding, bottom: 0, right: 0)
        clipsToBounds = false// 用于放大cell之后仍然完整显示
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
//        if tag == 889 {
//            print("GameCollectionView更新布局", frame)
//            backgroundColor = .purple
//        }
        
        super.layoutSubviews()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realCellCount
    }

    // 注意！必须同时设置2个miniSpacing为cellSpacing，否则会被设为默认值10
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < cellCount {
            if isCategoryTopic {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
                let gameModel = collectionViewDatas[indexPath.row]
                cell.gameModel = gameModel
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
                cell.isDisplayPurely = isDisplayPurely
                cell.bigSize = bigSize
                cell.isProductIntroTopic = isProductIntroTopic
                let gameModel = collectionViewDatas[indexPath.row]
                cell.gameModel = gameModel
                if indexPath == focusIndexPath {
                    if isFocusing {
                        cell.isFocusing = isFocusing
                        cell.displayFocusView()
                    }
                    else {
                        cell.isFocusing = isFocusing
                        cell.displayUnfocusView()
                    }
                }
                else {
                    cell.isFocusing = false
                    cell.displayUnfocusView()
                }
                return cell
            }
        }
        else {// 空白占位cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == focusIndexPath.row {
            return CGSize.init(width: cellSize.width*cellScale, height: cellSize.height*cellScale)
        }
        else {
            return cellSize
        }
    }
    
    var selectGameCallback: (_: IndexPath) -> Void = { indexPath in }
    // MARK: 需求一：点击cell，cell放大【放大倍数】，并滑动到【Focus cell与屏幕左侧的距离】
    // 为了让后几个可用cell在屏幕左侧显示而不出现CollectionView左右移动的问题，因此在末尾处增加了几个空白Cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= cellCount { return }
        if indexPath.row == focusIndexPath.row {
            appPlaySelectSound()
            // MARK: 需求三：再次点击Focus cell：放大游戏列表，列表下方展示该cell相关信息，包括截图、高光时刻、游戏描述
            tapFocusingCell(self, indexPath.row)
            return
        }
        
        focusIndexPath = indexPath
        selectGameCallback(focusIndexPath)// 用于游戏详情页面
        updateLayout(animated: true)
    }
    
    func updateBackgroundImage() {
        if index == 0 {// 只显示第一行的游戏背景图
            if focusIndexPath.row < 0 || focusIndexPath.row >= collectionViewDatas.count {
                return
            }
            
            let gameModel = collectionViewDatas[focusIndexPath.row]
            (UIViewController.current() as? GameViewController)?.setBackground(imageUrl: gameModel.coverURL)
        }
    }
    
    // 更新整体布局
    func updateLayout(animated: Bool) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.setCollectionViewLayout(flowLayout, animated: animated)// 此方法会调用collectionView:targetContentOffsetForProposedContentOffset:，重写该方法，以设置重新布局后scrollView的偏移量
    }
    
    // 预期偏移量（调用setCollectionViewLayout会触发此方法）
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        controlCellDisplayThing()
        updateBackgroundImage()
        
        // 滑动到目标cell
        let offsetX = CGFloat(focusIndexPath.row)*(cellSize.width+cellSpacing) - firstCellLeftPadding
        return CGPoint.init(x: offsetX, y: 0)
        /** 官方说明
         在布局更新期间，或在布局之间转换时，集合视图会调用此方法，让您有机会更改建议的内容偏移以在动画结束时使用。如果布局或动画可能导致项目以不适合您的设计的方式定位，您可能会返回一个新值。
         此方法在布局对象的方法之后调用。在您不想对布局对象进行子类化以修改内容偏移量的情况下实现此方法。
         */
    }
    
    var originalCellSize = CGSize.zero
    func beBigLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        originalCellSize = cellSize
        cellSize = CGSize(width: superBigCardWidth(), height: superBigCardHeight())
        self.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func beNormalLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        cellSize = originalCellSize
        self.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    // MARK: 需求二：滑动collectionView，targetContentOffset所在的cell放大【放大倍数】，并滑动到【Focus cell与屏幕左侧的距离】
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        let cellWidth = cellSize.width
        var index = Int(x / cellWidth)
        let divideX = CGFloat(index)*(cellWidth+cellSpacing) + cellWidth/2.0 - firstCellLeftPadding // 以卡片的centerX作为参考坐标
        if x > divideX {
            index += 1
        }
        
        if index > cellCount-1 {
            index = cellCount-1
        }
        
        targetContentOffset.pointee.x = CGFloat(index)*(cellWidth+cellSpacing) - firstCellLeftPadding// 不能删，删了没有平滑移动的效果
        
        focusIndexPath = IndexPath.init(row: index, section: 0)// 更新目标cell
        selectGameCallback(focusIndexPath)
        updateLayout(animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            controlCellDisplayThing()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        controlCellDisplayThing()
    }
    
    func controlCellDisplayThing() {
        for cell in visibleCells {
            if cell is GameCollectionViewCell {
                let destCell = cell as! GameCollectionViewCell
                let indexPath = indexPath(for: destCell)
                if indexPath == focusIndexPath {
                    if isFocusing {
                        destCell.isFocusing = isFocusing
                        destCell.displayFocusView()
                    }
                    else {
                        destCell.isFocusing = isFocusing
                        destCell.displayUnfocusView()
                    }
                }
                else {
                    destCell.isFocusing = false
                    destCell.displayUnfocusView()
                }
            }
        }
    }
    
    func gamepadKeyLeftAction() {
        let destIndexPath = IndexPath(row: focusIndexPath.row-1, section: focusIndexPath.section)
        
        if destIndexPath.row < 0 || destIndexPath.section < 0 || destIndexPath.row >= cellCount {
            appPlayIneffectiveSound()
            // TODO: 振动并发出连续的声音
            return
        }
        
        appPlayScrollSound()
        focusIndexPath = destIndexPath
        selectGameCallback(focusIndexPath)
        updateLayout(animated: true)
    }
    
    func gamepadKeyRightAction() {
        let destIndexPath = IndexPath(row: focusIndexPath.row+1, section: focusIndexPath.section)
        
        if destIndexPath.row < 0 || destIndexPath.section < 0 || destIndexPath.row >= cellCount {
            appPlayIneffectiveSound()
            // TODO: 振动并发出连续的声音
            return
        }
        
        appPlayScrollSound()
        focusIndexPath = destIndexPath
        selectGameCallback(focusIndexPath)
        updateLayout(animated: true)
    }
}
