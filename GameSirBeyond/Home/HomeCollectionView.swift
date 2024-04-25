//
//  HomeCollectionView.swift
//  GameSirBeyond
//
//  Created by leslie lee on 2024/3/7.
//

import UIKit

class HomeCollectionView: UIView, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    private var viewSafeAreaInsets: UIEdgeInsets!
    private var collectionView: UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    func configureCollectionView(safeAreaInsets:UIEdgeInsets) {
        self.viewSafeAreaInsets = safeAreaInsets;
        if collectionView == nil {
            collectionView = UICollectionView(frame: CGRect(x: 0, y:0, width: self.bounds.size.width, height: self.bounds.size.height), collectionViewLayout: createLayout())
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.backgroundColor = UIColor.hex("#1A1A1A")
            collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
            collectionView.register(HomeHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "HomeHeaderCollectionViewCell")
            collectionView.register(HomeCollectionSettingCell.self, forCellWithReuseIdentifier: "HomeCollectionSettingCell")
            collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
            collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
            collectionView.dataSource = self
            collectionView.delegate = self
            
            addSubview(collectionView)
        }
        //        collectionView.isPrefetchingEnabled = false
    }
    
    func createLayout() -> UICollectionViewLayout {
        // 创建布局
        let layout = GSVerticalFlowLayout()
        layout.itemSize = CGSizeMake(self.frame.size.width, 170)
        layout.sideItemScale = 1.0
        layout.headerReferenceSize = CGSizeMake(self.frame.size.width, self.frame.size.height / 3)
        layout.footerReferenceSize = CGSizeMake(self.frame.size.width, self.frame.size.height / 3)
        return layout
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // 获取collectionView的中心y坐标
        let collectionViewCenterY = collectionView.bounds.midY
        
        // 获取当前屏幕中可见的cell的indexPath数组
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        
        
        collectionView.performBatchUpdates({
            
            for indexPath in visibleIndexPaths {
                // 获取cell的中心y坐标
                let cellCenterY = collectionView.layoutAttributesForItem(at: indexPath)?.center.y ?? 0
                
                // 计算cell的中心y坐标与collectionView的中心y坐标之间的距离
                let distance = abs(collectionViewCenterY - cellCenterY)
                
                // 将距离映射到范围为0到1的值
                var normalizedDistance = 0.0
                if  indexPath.item == 0 {
                    normalizedDistance = 1 - min(1, max(0, distance / CGFloat(138.0 + 54.0)))
                }else{
                    normalizedDistance = 1 - min(1, max(0, distance / (CGFloat(138 + 54) * 1.2 )))
                }
                
                
//                print("Cell at indexPath \(indexPath)   normalizedDistance: \(normalizedDistance)   distance:\(distance)")
                if let cell = collectionView.cellForItem(at: indexPath) as? HomeHeaderCollectionViewCell {
                    let collectionViewLayout =  cell.collectionView.collectionViewLayout as? GSHorizontalFlowLayout
                    collectionViewLayout?.sideItemBaselineType = .bottom
                    collectionViewLayout?.itemSize = CGSizeMake(156, 88)
                    let floatValue: CGFloat = 1 + 0.625 * normalizedDistance
                    collectionViewLayout?.sideItemScale = floatValue
                    collectionViewLayout?.invalidateLayout()
                }
                // 在这里更新cell的布局
                if let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell {
                    let collectionViewLayout =  cell.collectionView.collectionViewLayout as? GSHorizontalFlowLayout
                    collectionViewLayout?.itemSize = CGSizeMake(246, 138)
                    collectionViewLayout?.sideItemBaselineType = .center
                    let floatValue: CGFloat = 1 + 0.15 * normalizedDistance
                    collectionViewLayout?.sideItemScale = floatValue
                    collectionViewLayout?.invalidateLayout()
                }
                if let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionSettingCell {
                    let collectionViewLayout =  cell.collectionView.collectionViewLayout as? GSHorizontalFlowLayout
                    collectionViewLayout?.itemSize = CGSizeMake(246, 138)
                    collectionViewLayout?.sideItemBaselineType = .center
                    let floatValue: CGFloat = 1 + 0.15 * normalizedDistance
                    collectionViewLayout?.sideItemScale = floatValue
                    collectionViewLayout?.invalidateLayout()
                }
            }
            
        }, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // 获取当前屏幕中可见的cell的indexPath数组
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        collectionView.performBatchUpdates({
            
            for indexPath in visibleIndexPaths {
                // 获取cell的中心y坐标
                let cellCenterY = collectionView.layoutAttributesForItem(at: indexPath)?.center.y ?? 0
                // 在这里更新cell的布局
                if let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell {
                    let collectionViewLayout =  cell.collectionView.collectionViewLayout as? GSHorizontalFlowLayout
                    if collectionViewLayout!.sideItemScale > 1.02 {
                        cell.playVideo()
                    }else{
                        cell.removeVideoView()
                    }
                }
            }
            
        }, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  indexPath.item == 0 {
            return CGSizeMake(self.frame.size.width,  CGFloat(138 + 54))
        }else{
            return CGSizeMake(self.frame.size.width,  CGFloat(138 + 54) * 1.2)
        }
        
    }
    
}

extension HomeCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        cell.backgroundColor = UIColor.random
        //        cell.titleLabel.text = "\(indexPath.section)-\(indexPath.item)" HomeHeaderCollectionViewCell
        var cell = UICollectionViewCell()
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCollectionViewCell", for: indexPath) as! HomeHeaderCollectionViewCell
            cell.maxScale = 1.625
            cell.backgroundColor = .clear
            cell.sectionNum = 0
            for gameListModel in GameManager.shared.gameListModels{
                if (gameListModel.card_type == 1){
                    cell.gameListModel = gameListModel
                }
            }
            return cell
        }else if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionSettingCell", for: indexPath) as! HomeCollectionSettingCell
            cell.sectionNum = indexPath.item
            cell.maxScale = 1.15
            for gameListModel in GameManager.shared.gameListModels{
                if (gameListModel.card_type == 3){
                    cell.gameListModel = gameListModel
                    cell.titleLabel.text = gameListModel.name
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            cell.sectionNum = indexPath.item
            cell.maxScale = 1.15
            for gameListModel in GameManager.shared.gameListModels{
                if (gameListModel.card_type == (indexPath.item + 1)){
                    cell.gameListModel = gameListModel
                    cell.titleLabel.text = gameListModel.name
                }
            }
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:UICollectionReusableView?
        if (kind == UICollectionView.elementKindSectionHeader ){
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath)
            headerView.backgroundColor = UIColor.clear;
            reusableview = headerView;
            
        }
        if (kind == UICollectionView.elementKindSectionFooter ){
            let FooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView", for: indexPath)
            FooterView.backgroundColor = UIColor.clear;
            reusableview = FooterView;
            
        }
        return reusableview ?? UICollectionReusableView()
    }
}


//ui数据
struct HomeCollectionSettings {
    //游戏卡片-首页第一行（固定）
    static let FirstlineW: CGFloat  = 156.0  //254.0
    static let FirstlineH: CGFloat = 88.0   //143.0
    static let FirstlineScale: CGFloat = 1.628
    //游戏卡片-类型2-小号
    static let GameCardsSmallW: CGFloat  = 192.0  //224.0
    static let GameCardsSmallH: CGFloat = 108.0   //126.0
    static let GameCardsSmallScale: CGFloat = 1.166
    //游戏卡片-类型1-中号
    static let GameCardsMediumW: CGFloat  = 246.0  //280.0
    static let GameCardsMediumH: CGFloat = 138.0   //158.0
    static let GameCardsMediumScale: CGFloat = 1.138
    //游戏卡片-类型2-大号 （可用于视频卡片）
    static let GameCardsBigW: CGFloat  = 312.0 //352
    static let GameCardsBigH: CGFloat = 176.0
    static let GameCardsBigScale: CGFloat = 1.128
    
    
}
