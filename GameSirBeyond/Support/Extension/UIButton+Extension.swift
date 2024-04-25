//
//  UIButton+Extension.swift
//  Eggshell
//
//  Created by leslie lee on 2022/11/22.
//

import Foundation
import UIKit

extension UIButton {
    
    enum Position {
        case top
        case bottom
        case left
        case right
    }
    func positionStyle(_ position: Position, at space: CGFloat = 0) -> Void {
        self.layoutIfNeeded()
        switch position {
        case .top:
            let titleHeight = titleLabel?.bounds.height ?? 0
            let imageHeight = imageView?.bounds.height ?? 0
            let imageWidth = imageView?.bounds.width ?? 0
            let titleWidth = titleLabel?.bounds.width ?? 0
            titleEdgeInsets = UIEdgeInsets(top: (titleHeight + space) * 0.5,
                                           left: (self.bounds.size.width-titleWidth) * 0.5-imageWidth,
                                           bottom: -space,
                                           right: (self.bounds.size.width-titleWidth) * 0.5)
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: (self.bounds.size.width-imageWidth)  * 0.5,
                                           bottom: (imageHeight + space),
                                           right: (self.bounds.size.width-imageWidth) * 0.5)
        case .bottom:
            let titleHeight = titleLabel?.bounds.height ?? 0
            let imageHeight = imageView?.bounds.height ?? 0
            let imageWidth = imageView?.bounds.width ?? 0
            let titleWidth = titleLabel?.bounds.width ?? 0
            titleEdgeInsets = UIEdgeInsets(top: -(titleHeight + space) * 0.5,
                                           left: -imageWidth * 0.5,
                                           bottom: space,
                                           right: imageWidth * 0.5)
            imageEdgeInsets = UIEdgeInsets(top: (imageHeight + space),
                                           left: titleWidth * 0.5,
                                           bottom: 0,
                                           right: -titleWidth * 0.5)
            
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
        case .right:
            let imageWidth = (imageView?.bounds.width ?? 0) + space
            let titleWidth = (titleLabel?.bounds.width ?? 0) + space
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
        }
    }
    
    
    
    
}
