//
//  GSCarouselFlowLayout.swift
//  AnimationDemo
//
//  Created by leslie lee on 2024/3/12.
//


import UIKit

@objc public enum GSHorizontalFlowLayoutBaselineType: Int {
    //.horizontal
    case top
    case center
    case bottom
}
//水平方向
public class GSHorizontalFlowLayout: UICollectionViewFlowLayout {

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
    @objc @IBInspectable open var sideItemBaselineType = GSHorizontalFlowLayoutBaselineType.center
    /**
     * base on sideItemBaselineType, you can adjust the baseline offset by this value
     */
    @objc @IBInspectable open var sideItemOffset: CGFloat = 0.0

   
//    @objc @IBInspectable open var retract: CGFloat = 0.0  123147
    
    override open func prepare() {
        super.prepare()

        self.setupCollectionView()
        self.updateLayout()
    }

    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.normal {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        }
    }

    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }

        let collectionSize = collectionView.bounds.size
        let isHorizontal = (scrollDirection == .horizontal)

        let yInset = (collectionSize.height - itemSize.height) / 2 * 0

        let xInset = 0.0
     
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: (collectionSize.width - itemSize.width))
       
//        let scrollDirectionItemWidth = isHorizontal ? itemSize.width : itemSize.height
//        let scaledItemOffset = (scrollDirectionItemWidth - scrollDirectionItemWidth * self.sideItemScale) / 2
        self.minimumLineSpacing = itemSpacing
      
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

//        let collectionCenter = isHorizontal ? collectionView.frame.size.width / 2 : collectionView.frame.size.height / 2
        let collectionCenter =   ((self.itemSize.width/2))
        
        let offset =  collectionView.contentOffset.x + 59
        let normalizedCenter =  attributes.center.x  - offset

        let maxDistance = self.itemSize.width + self.minimumLineSpacing //最大距离
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance) //返回 （放大中心 - item中心的距离）的绝对值 和  最大距离 比较 取小的
        let ratio = (maxDistance - distance) / maxDistance  //计算缩小比例，最小值为0

        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = 1 + ratio * (self.sideItemScale - 1)
         
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)

        let scrollDirectionItemHeight = isHorizontal ? itemSize.height : itemSize.width
        var sideItemFixedOffset: CGFloat = (itemSize.width * self.sideItemScale - itemSize.width) / 2
        var sideItemFixedOffsetY: CGFloat = 0
        switch sideItemBaselineType {
        case .top:
            sideItemFixedOffsetY = (scrollDirectionItemHeight - scrollDirectionItemHeight * self.sideItemScale) / 2
        case .center:
            sideItemFixedOffsetY = 0
        case .bottom:
            sideItemFixedOffsetY = -(scrollDirectionItemHeight - scrollDirectionItemHeight * self.sideItemScale) / 2
   
        }
        let shift = (1) * (sideItemOffset + sideItemFixedOffset)
        let shift2 = (1 - ratio) * sideItemFixedOffset
        let shiftY = (1 - ratio) * (sideItemOffset + sideItemFixedOffsetY)
        attributes.center.x += (shift)
        attributes.center.x += shift2
        attributes.center.y += shiftY
        if isHorizontal {
            if ((collectionCenter - normalizedCenter) > 0){
                let shift3 = (1 - ratio) * shift
                attributes.center.x -= (shift2 + shift3)
            }
//            print(" indexPath:\(attributes.indexPath)     attributes.center.x \(attributes.center.x)  ratio \(ratio)  shift:\(shift)  sideItemFixedOffset\(sideItemFixedOffset)")
        }
        
        return attributes
        
       
    }

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        let isHorizontal = (self.scrollDirection == .horizontal)
        let sideItemFixedOffset = (itemSize.width * self.sideItemScale - itemSize.width) / 2
        let midSide =  (itemSize.width * self.sideItemScale/2) + 59
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
       
        var targetContentOffset: CGPoint
        let closest = layoutAttributes.sorted {abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin)}.first ?? UICollectionViewLayoutAttributes()
        
        let newx = CGFloat(closest.indexPath.item) * (itemSize.width + self.itemSpacing) - 59
        targetContentOffset = CGPoint(x: floor(newx), y: proposedContentOffset.y)

        return targetContentOffset
    }
}

