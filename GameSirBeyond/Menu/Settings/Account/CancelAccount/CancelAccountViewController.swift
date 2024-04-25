//
//  CancelAccountViewController.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/13.
//

import UIKit
import WebKit

class CancelAccountViewController: UIViewController, WKScriptMessageHandler {
    
    var webView: WKWebView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView = WKWebView.init(frame: view.bounds)
        view.addSubview(webView)
        webView.allowsBackForwardNavigationGestures = true
        let webviewScriptDelegate = WeakScriptMessageDelegate.init()
        webviewScriptDelegate.scriptDelegate = self
        webView.configuration.userContentController.add(webviewScriptDelegate, name: "onMyClick")
        
        let cancelURL = URL(string: "https://apieggshell.vgabc.com/accountcancel/index.html")
        let request = URLRequest(url: cancelURL!)
        webView.load(request)
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
//                    MBProgressHUD.showMsgWithtext("已发送验证码到：+\(zone) \(phoneNumber)")
//                }
//                else {
//                    MBProgressHUD.showMsgWithtext("验证码发送失败，请稍后再试")
//                }
//            }
        }
    }
}
