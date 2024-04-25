//
//  HighlightNameView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/5.
//

import UIKit

class HighlightNameView: UIView, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cancelButton: AnimatedButton!
    @IBOutlet weak var continueButton: AnimatedButton!
    @IBOutlet weak var nameHighlightLabel: UILabel!
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("HighlightNameView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        nameHighlightLabel.text = i18n(string: "Name highlight")
        nameTextField.placeholder = i18n(string: "Highlight name")
        
        continueButton.setTitle("  ".appending(i18n(string: "Continue")), for: .normal)
        cancelButton.tapAction = {
            self.btnActionCancel()
        }
        continueButton.tapAction = {
            self.btnActionContinue()
        }
        continueButton.setControllerImage(type: .a)
        cancelButton.setControllerImage(type: .b)
        
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        
        addGradientBackgroundColorIn(view: contentView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
    
    func btnActionCancel() {
        NotificationCenter.default.post(name: Notification.Name("DidFinishSharingHighlightNotification"), object: nil)
        removeFromSuperview()
    }
    
    func btnActionContinue() {
        if nameTextField.text?.lengthOfBytes(using: .utf8) == 0 {
            MBProgressHUD.showMsgWithtext(i18n(string: "Please input Highlight Title"))
            endEditing(true)
            return
        }
        
        nameTextField.resignFirstResponder()
        CaptureManager.shared.highlightTitle = nameTextField.text!
        
        if CaptureManager.shared.highlightGameID != "" {// 已经选择游戏（包括上次分享）
            displayConfirmGameView()
        }
        else {
            displayTagGameView()
        }
    }
    
    func displayConfirmGameView() {
        let tagView = HighlightConfirmGameView(frame: bounds)
        superview?.addSubview(tagView)
        
        removeFromSuperview()
    }
    
    func displayTagGameView() {
        let tagView = HighlightTagGameView(frame: bounds)
        superview?.addSubview(tagView)
        
        removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    // MARK: 手柄操控
    
    func gamepadKeyAAction() {
        appPlaySelectSound()
        continueButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        cancelButton.sendActions(for: .touchUpInside)
    }
}


func addGradientBackgroundColorIn(view: UIView) {
    let gradView = UIView(frame: view.bounds)
    view.addSubview(gradView)
    view.sendSubviewToBack(gradView)
    
    let gradientLayer = CAGradientLayer()
    let startColor = color(r: 47, g: 109, b: 182).cgColor
    let endColor = color(r: 84, g: 114, b: 47).cgColor
    gradientLayer.colors = [startColor, endColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.frame = gradView.bounds
    gradView.layer.addSublayer(gradientLayer)
}
