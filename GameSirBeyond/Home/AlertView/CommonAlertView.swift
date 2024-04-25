//
//  CommonAlertView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/11/2.
//

import UIKit

class CommonAlertView: UIView {

    
    @IBOutlet weak var titleLabel: I18nLabel!
    @IBOutlet weak var messageLabel: I18nLabel!
    @IBOutlet weak var closeButton: AnimatedButton!
    
    var closeCallback = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }

    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("CommonAlertView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        closeButton.tapAction = {
            self.closeCallback()
        }
        closeButton.setControllerImage(type: .b)
    }
    
}
