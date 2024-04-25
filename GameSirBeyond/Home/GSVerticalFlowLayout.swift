//
//  GSVerticalFlowLayout.swift
//  AnimationDemo
//
//  Created by leslie lee on 2024/3/15.
//

import Foundation
import UIKit
@objc public enum GSVerticalFlowLayoutBaselineType: Int {
  
    case left
}
//垂直方向
public class GSVerticalFlowLayout: UICollectionViewFlowLayout {
  
    @objc @IBInspectable open var sideItemScale: CGFloat = 1.0
    /**
     * beside item alpha to show
     * value range 0-1,default value 0.7
     */
    @objc @IBInspectable open var sideItemAlpha: CGFloat = 0.7

    /**
     * to control minimumLineSpacing
     * value range -x to x,default value 0
     * if it is minus, it is overlap style
     */
    @objc open var itemSpacing: CGFloat = 0
    /**
     * scroll direction beside items baseline type
     */
    @objc @IBInspectable open var sideItemBaselineType = GSVerticalFlowLayoutBaselineType.left
    /**
     * base on sideItemBaselineType, you can adjust the baseline offset by this value
     */
    @objc @IBInspectable open var sideItemOffset: CGFloat = 0.0
    @objc @IBInspectable open var retract: CGFloat = 0.0
  
    override open func prepare() {
        super.prepare()

        self.setupCollectionView()
        self.updateLayout()
    }

    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }

    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }

        let collectionSize = collectionView.bounds.size

        let yInset = (collectionSize.height - itemSize.height) / 2 * 0
//        let xInset = (collectionSize.width - itemSize.width) / 2
      
        self.sectionInset = UIEdgeInsets(top: yInset, left: 0, bottom: itemSize.height, right:0)
//        print("self.sectionInset \(self.sectionInset)")
        let scrollDirectionItemWidth = itemSize.height
        let scaledItemOffset = (scrollDirectionItemWidth - scrollDirectionItemWidth * self.sideItemScale) / 2
        self.minimumLineSpacing = itemSpacing - scaledItemOffset
      
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect), let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
            return nil
        }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }

    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        let isHorizontal = (self.scrollDirection == .horizontal)
        let collectionCenter =  (collectionView.bounds.size.height) / 2
        let offset =  collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset

        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing //最大距离
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance) //返回 （放大中心 - item中心的距离）的绝对值 和  最大距离 比较 取小的
        let ratio = (maxDistance - distance) / maxDistance  //计算比例，最小值为0

        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        var scale = 0.0
        if self.sideItemScale > 1{
            scale = 1 + ratio * (self.sideItemScale - 1)
        }else{
            scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        }
         

        attributes.alpha = alpha
//        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)

        let scrollDirectionItemHeight = isHorizontal ? itemSize.height : itemSize.width
        var sideItemFixedOffset: CGFloat = 0
        switch sideItemBaselineType {
    
        case.left:
            sideItemFixedOffset = (scrollDirectionItemHeight - scrollDirectionItemHeight * self.sideItemScale) / 2
        }
        let shift = (sideItemOffset + sideItemFixedOffset) * ratio
       
//        attributes.center.x -= (shift)
//        print("--------.vertical-----------")
//        print("attributes.center.x \(attributes.center.x)  shift:\(shift)  ratio:\(ratio)")
//        attributes.size.height = itemHeight[attributes.indexPath.item]
        
        return attributes
        
       
    }

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        let isHorizontal = (self.scrollDirection == .horizontal)

        let midSide =  (collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide

        var targetContentOffset: CGPoint

        let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
                
        return targetContentOffset
    }
}
