//
//  ControllerTriggerKeyView.swift
//  VastWorld
//
//  Created by Panda on 2022/6/2.
//

import UIKit

class TriggerAnimatedView: UIView {
    
    enum AnimationDestination: NSInteger {
        case leftToRight = 1
        case rightToLeft = 2
        case upToDown    = 4
        case downToUp    = 8
    }
    
    var imageName: String {// 图片名称
        get {
            return ""
        }
        set {
            highlightImageView = UIImageView.init(frame: self.bounds)
            addSubview(highlightImageView)
            highlightImageView.contentMode = .scaleAspectFit
            highlightImageView.image = UIImage.init(named: newValue)
            highlightImageView.layer.mask = maskLayer
        }
    }
    
    private var currentDestination = AnimationDestination.leftToRight
    var destination: AnimationDestination {// 滑动方向，默认从左往右
        get {
            return currentDestination
        }
        set {
            currentDestination = newValue
            
            switch newValue {
            case .leftToRight:
                maskLayer.frame = CGRect.init(x: -self.bounds.size.width, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
                originalPosition = maskLayer.position
            case .rightToLeft:
                maskLayer.frame = CGRect.init(x: self.bounds.size.width, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
                originalPosition = maskLayer.position
            case .upToDown:
                maskLayer.frame = CGRect.init(x: 0, y: -self.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height)
                originalPosition = maskLayer.position
            case .downToUp:
                maskLayer.frame = CGRect.init(x: 0, y: self.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height)
                originalPosition = maskLayer.position
            }
        }
    }
    
    private var highlightImageView = UIImageView.init()
    private var maskLayer = CAShapeLayer.init()
    private var lastPercent: CGFloat = 0.0
    private var originalPosition = CGPoint.init(x: 0, y: 0)
    
    func initSubviews() {
        backgroundColor = UIColor.clear
        
        maskLayer = CAShapeLayer.init()
        maskLayer.backgroundColor = UIColor.clear.cgColor
        
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: 0, y: self.bounds.size.height))
        path.addLine(to: CGPoint.init(x: self.bounds.size.width, y: self.bounds.size.height))
        path.addLine(to: CGPoint.init(x: self.bounds.size.width, y: 0))
        path.close()
        maskLayer.path = path.cgPath
        
        destination = .leftToRight// 默认滑动方向
    }
    
    func set(percent: CGFloat) {
        
        let realPercent = percent * 100.0
        var position = originalPosition
        switch currentDestination {
        case .leftToRight:
            position.x = originalPosition.x + (realPercent / 100.0) * self.bounds.size.width
        case .rightToLeft:
            position.x = originalPosition.x - (realPercent / 100.0) * self.bounds.size.width
        case .upToDown:
            position.y = originalPosition.y + (realPercent / 100.0) * self.bounds.size.height
        case .downToUp:
            position.y = originalPosition.y - (realPercent / 100.0) * self.bounds.size.height
        }
        
        self.maskLayer.position = position
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initSubviews()
    }
    
}
