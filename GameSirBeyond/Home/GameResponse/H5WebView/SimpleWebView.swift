//
//  SimpleWebView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/3/6.
//

import UIKit
import WebKit

class SimpleWebView: UIView {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeButton: AnimatedButton!
    
    var urlString = "" {
        didSet {
            let request = URLRequest(url: URL(string: urlString)!)
            self.webView.load(request)
        }
    }
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("SimpleWebView", owner: self, options: nil)?.first) as! UIView)
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
