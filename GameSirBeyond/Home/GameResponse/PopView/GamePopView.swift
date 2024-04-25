//
//  GamePopView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/3/6.
//

import UIKit

class GamePopView: UIView {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: AnimatedButton!
    
    var closeCallback = {}
    
    var contentView: UIView!
    func initSubviews() {
        addBlurEffect(style: .dark, alpha: 1)
        
        contentView = ((Bundle.main.loadNibNamed("GamePopView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        closeButton.tapAction = {
            self.removeFromSuperview()
        }
        closeButton.setControllerImage(type: .b)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        closeButton.sendActions(for: .touchUpInside)
    }
}
