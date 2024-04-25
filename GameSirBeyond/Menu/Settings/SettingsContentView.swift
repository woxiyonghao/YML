//
//  SettingsContentView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/23.
//

import UIKit

enum SettingsContentDataKey: String {
    case title  = "title"
    case prompt = "prompt"
    case type   = "type"
}

enum SettingsContentType: String {
    case none = "none"
    case userEditInfo = "userEditInfo"
    case userLogoutAccount = "userLogoutAccount"
    case userCancelAccount = "userCancelAccount"
    case controllerKeySetting = "controllerKeySetting"
    case controllerUpdateFirmware = "controllerUpdateFirmware"
    case controllerTest = "controllerTest"
}

class SettingsContentView: UIView, UIScrollViewDelegate {
    
    let scrollView = UIScrollView(frame: .zero)
    var didSelectContent: (_:SettingsContentClickView, _: Int) -> Void = { view, index in }
    let clickViewStartTag = 888
    var defaultFocusTag = -1
    var focusTag = -1
    
    var datas: [[String: String]] = [] {
        didSet {
            for index in 0..<datas.count {
                // 正常Size：426, 34，变大Size：469, 37
                let clickView = SettingsContentClickView.init(frame: .zero)
                let y = index*(clickView.normalHeight+15)
                clickView.tag = clickViewStartTag+index
                scrollView.addSubview(clickView)
                clickView.snp.makeConstraints { make in
                    make.centerX.equalTo(scrollView)
                    make.top.equalTo(scrollView).offset(y)
                    make.width.equalTo(clickView.normalWidth)
                    make.height.equalTo(clickView.normalHeight)
                }
                
                let data = datas[index]
                clickView.titleLabel.text = data[SettingsContentDataKey.title.rawValue]!
                clickView.contentLabel.text = data[SettingsContentDataKey.prompt.rawValue]!
                clickView.type = data[SettingsContentDataKey.type.rawValue]
                clickView.clickCallback = { view in
                    for subView in self.scrollView.subviews {
                        if subView.isKind(of: SettingsContentClickView.self) {
                            let clickView = (subView as! SettingsContentClickView)
                            var selected = false
                            if clickView.tag == view.tag {
                                selected = true
                                self.focusTag = view.tag
                            }
                            else {
                                selected = false
                            }
                            
                            UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseInOut) {
                                clickView.set(selected: selected)
                                self.scrollView.setNeedsUpdateConstraints()
                                self.scrollView.layoutIfNeeded()
                            }
                        }
                    }
                    
                    delay(interval: 0.1) {
                        self.didSelectContent(clickView, view.tag - self.clickViewStartTag)
                    }
                }
                
                clickView.selectCallback = { view in
                    for subView in self.scrollView.subviews {
                        if subView.isKind(of: SettingsContentClickView.self) {
                            let clickView = (subView as! SettingsContentClickView)
                            var selected = false
                            if clickView.tag == view.tag {
                                selected = true
                                self.focusTag = view.tag
                            }
                            else {
                                selected = false
                            }
                            
                            UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseInOut) {
                                clickView.set(selected: selected)
                                self.scrollView.setNeedsUpdateConstraints()
                                self.scrollView.layoutIfNeeded()
                            }
                        }
                    }
                }
            }
            
            let clickView = SettingsContentClickView.init(frame: .zero)
            scrollView.contentSize = CGSize.init(width: clickView.maxWidth, height: datas.count*clickView.normalHeight + (datas.count-1)*15 + clickView.maxHeight-clickView.normalHeight)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.clipsToBounds = false
        self.scrollView.backgroundColor = .clear
        self.scrollView.bounces = true
        self.scrollView.showsVerticalScrollIndicator = false
        let clickView = SettingsContentClickView.init(frame: .zero)
        self.scrollView.snp.makeConstraints { make in
            make.left.equalTo((UIScreen.main.bounds.size.width-200-CGFloat(clickView.maxWidth))/2.0)
            make.top.equalTo(100)
            make.width.equalTo(clickView.maxWidth)
            make.height.equalTo(UIScreen.main.bounds.size.height-150)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectUpClickView() {
        let destTag = focusTag-1
        if destTag < clickViewStartTag { return }
        
        let clickView = viewWithTag(destTag) as! SettingsContentClickView
        clickView.selectCallback(clickView)
    }
    
    func selectDownClickView() {
        let destTag = focusTag+1
        if destTag-clickViewStartTag > datas.count-1 {
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        let clickView = viewWithTag(destTag) as! SettingsContentClickView
        clickView.selectCallback(clickView)
    }
    
    func selectFirstClickView() {
        let clickView = viewWithTag(clickViewStartTag) as! SettingsContentClickView
        clickView.selectCallback(clickView)
    }
    
    func unselectAllClickView() {
        for index in 0..<datas.count {
            let clickView = viewWithTag(clickViewStartTag+index) as! SettingsContentClickView
            clickView.set(selected: false)
        }
        
        focusTag = defaultFocusTag
    }
    
    func clickSelectedClickView() {
        let clickView = viewWithTag(focusTag) as! SettingsContentClickView
        clickView.clickCallback(clickView)
    }
}
