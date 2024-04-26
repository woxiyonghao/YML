//
//  ImageCollectionView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/9.
//

import UIKit
import ObjectMapper
//import SwiftVideoBackground

class ImageCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: 参数定义
    // 【Cell的个数】，三者关系：realCellCount == cellCount + emptyCellCount
    private var cellCount = 0// 可用cell的数量（区别于空白cell），初始化时由外界传入
    private var realCellCount = 0// 实际展示的cell数量
    private var emptyCellCount = 0// 空白cell的数量，作用：在CollectionView尾部增加几个Cell，以实现最后一个可用cell在屏幕左侧显示而不出现CollectionView左右移动的问题
    private let firstCellLeftPadding = 57.0// 【Focus cell与屏幕左侧的距离】
    private let cellSpacing = 16.0// 【Cell与Cell的距离】
    var focusIndexPath = IndexPath.init(row: 0, section: 0)// 当前选中的cell
    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()// 布局方法，由外界传入
    var cellSize = CGSize.init(width: 0.0, height: 0.0)// cell的大小，由FlowLayout传入
    var isDisplayPurely = false
    
    var cellScale = 1.0 {// Focus cell的【放大倍数】，由外界传入，默认为1.0，不放大
        didSet {
            if cellScale <= 1.0 {// 表示此行未居中显示
                isUserInteractionEnabled = false// 不允许交互
            }
            else {
                isUserInteractionEnabled = true
            }
        }
    }
    
    var collectionViewDatas: [String] = [] {
        didSet {
            cellCount = collectionViewDatas.count
            reloadData()
        }
    }
    
    // MARK: 初始化
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let flowLayout = (layout as! UICollectionViewFlowLayout)
        cellSize = flowLayout.itemSize
        emptyCellCount = Int((UIScreen.main.bounds.size.width - firstCellLeftPadding - cellSize.width*cellScale) / (cellSize.width+cellSpacing)) + 1// 在初始化前，确定空白cell的数量。规则：最后一个空白cell的frame包含右侧屏幕边界
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(UINib.init(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        register(UINib.init(nibName: "EmptyCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EmptyCollectionViewCell")

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
        realCellCount = cellCount+emptyCellCount// 在布局前确定cell的数量
        
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            let urlString = collectionViewDatas[indexPath.row]
            cell.coverURL = urlString
            return cell
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
    
    // MARK: 需求一：点击cell，cell放大【放大倍数】，并滑动到【Focus cell与屏幕左侧的距离】
    // 为了让后几个可用cell在屏幕左侧显示而不出现CollectionView左右移动的问题，因此在末尾处增加了几个空白Cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row >= cellCount { return }
        if indexPath.row == focusIndexPath.row { return }
        
        focusIndexPath = indexPath
        updateLayout()
    }
    
    // 更新整体布局
    func updateLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        // 此方法会调用collectionView:targetContentOffsetForProposedContentOffset:，重写该方法，以设置重新布局后scrollView的偏移量
        setCollectionViewLayout(flowLayout, animated: true)
    }
    
    // 预期偏移量（调用setCollectionViewLayout会触发此方法）
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
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
    
    // MARK: ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 计算
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
        updateLayout()
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
        updateLayout()
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
        updateLayout()
    }
}
