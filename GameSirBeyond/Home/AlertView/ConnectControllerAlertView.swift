//
//  ConnectControllerAlertView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/10/9.
//

import UIKit

class ConnectControllerAlertView: UIView {
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("ConnectControllerAlertView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }

}
