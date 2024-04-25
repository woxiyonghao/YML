//
//  WeakScriptMessageDelegate.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/13.
//

import UIKit
import WebKit

class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    
    var scriptDelegate: WKScriptMessageHandler?
    
    override init() {
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}
