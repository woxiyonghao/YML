//
//  CancelAccountView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/17.
//

import UIKit
import WebKit

class CancelAccountView: UIView, WKScriptMessageHandler {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeButton: AnimatedButton!
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("CancelAccountView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        closeButton.tapAction = {
            self.removeFromSuperview()
        }
        closeButton.setControllerImage(type: .b)
        
        webView.allowsBackForwardNavigationGestures = true
        let webviewScriptDelegate = WeakScriptMessageDelegate.init()
        webviewScriptDelegate.scriptDelegate = self
        webView.configuration.userContentController.add(webviewScriptDelegate, name: "onMyClick")
        
        let cancelURL = URL(string: "https://apieggshell.vgabc.com/accountcancel/index.html")
        let request = URLRequest(url: cancelURL!)
        delay(interval: 0.1) {
            self.webView.load(request)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let messageBody = message.body
        if messageBody is String {
            if (messageBody as! String) == "Succeed to cancel account" {// 注销账号成功
                removeUserData()
                
                let window = UIApplication.shared.windows.first
//                let gettingStartedPage = GettingStartedViewController.init()
                window?.backgroundColor = .white
                window?.rootViewController = UIViewController()
            }
        }
        else if messageBody is [String: Any] {// 点击【发送验证码】按钮，传来手机号和区号数据
            let mobileMsg = messageBody as! [String: Any]
            var zone = mobileMsg["zone"] as! String
            if zone.contains("+") {
                zone = zone.replacingOccurrences(of: "+", with: "")
            }
            let phoneNumber = mobileMsg["phoneNumber"] as! String
            print("手机号：", phoneNumber + " zone：" + zone)
            
//            if phoneNumber == "14777777777" {
//                return
//            }
//            SMSManager.shared.getSMS(phoneNumber: phoneNumber, zone: zone) { error in
//                if error == nil {
//                    MBProgressHUD.showMsgWithtext(i18n(string: "Verification code SMS sent to") + "+\(zone) \(phoneNumber)")
//                }
//                else {
//                    MBProgressHUD.showMsgWithtext(i18n(string: "Failed to send verification code SMS, please try again later"))
//                }
//            }
        }
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
