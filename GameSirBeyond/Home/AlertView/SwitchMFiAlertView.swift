//
//  SwitchMFiAlertView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/11/2.
//

import UIKit

class SwitchMFiAlertView: UIView {

    var alertContentView: CommonAlertView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSwitchToMFiMode), name: Notification.Name("DidOpenControllerSessionNotification"), object: nil)
        
        backgroundColor = .black.withAlphaComponent(0.5)
        
        let title = i18n(string: "Switch controller mode alert title")
        let image1 = UIImage(named: "m1c_menu_black")
        let image2 = UIImage(named: "m1c_a_black")
        let atbMessage = NSMutableAttributedString(contents: [i18n(string: "Switch controller mode alert message part1"), image1 as Any, i18n(string: "Switch controller mode alert message part2"), image2 as Any, i18n(string: "Switch controller mode alert message part3")], imageSize: CGSize(width: 25, height: 25), imageY: -9)
        alertContentView = CommonAlertView(frame: CGRect(x: 0, y: 0, width: 348*1.2, height: 186*1.2))
        alertContentView.center = center
        alertContentView.titleLabel.text = title
        alertContentView.messageLabel.attributedText = atbMessage
        addSubview(alertContentView)
        alertContentView.closeCallback = {
            self.removeFromSuperview()
        }
        
//        alertContentView.closeButton.isHidden = true
        alertContentView.closeButton.setTitle(i18n(string: "  OK"), for: .normal)
    }
    
    override func removeFromSuperview() {
        // 如果此时在以下页面，需关闭页面：按键功能设置、固件升级、按键测试
        NotificationCenter.default.post(name: NSNotification.Name("NeedToQuitMFiControllerPage"), object: nil)
        
        NotificationCenter.default.removeObserver(self)
        
        super.removeFromSuperview()
    }
    
    @objc func didSwitchToMFiMode() {
        MainThread {
            MBProgressHUD.showMsgWithtext(i18n(string: "Switched to MFi mode"))
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        alertContentView.closeButton.sendActions(for: .touchUpInside)
    }
    
}
