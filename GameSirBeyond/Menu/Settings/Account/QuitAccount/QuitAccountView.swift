//
//  QuitAccountView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/7.
//

import UIKit

class QuitAccountView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var closeButton: AnimatedButton!
    
    var didTapCloseButton = {}
    var didTapConfirmButton = {}
    var didTapCancelButton = {}

    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("QuitAccountView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        closeButton.tapAction = {
            self.btnActionClose()
        }
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        confirmButton.setBackgroundImage(UIImage.from(color: .white, size: confirmButton.frame.size), for: .selected)
        confirmButton.setBackgroundImage(UIImage.from(color: color(hex: 0x606060), size: confirmButton.frame.size), for: .normal)
        confirmButton.setTitleColor(color(hex: 0x252525), for: .selected)
        confirmButton.setTitleColor(.white, for: .normal)
        
        cancelButton.setBackgroundImage(UIImage.from(color: .white, size: cancelButton.frame.size), for: .selected)
        cancelButton.setBackgroundImage(UIImage.from(color: color(hex: 0x606060), size: cancelButton.frame.size), for: .normal)
        cancelButton.setTitleColor(color(hex: 0x252525), for: .selected)
        cancelButton.setTitleColor(.white, for: .normal)
        
        confirmButton.isSelected = true
        confirmButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
    
    func btnActionClose() {
        didTapCloseButton()
    }
    
    @IBAction func btnActionConfirm() {
        if confirmButton.isSelected {
            didTapConfirmButton()
        }
        else {
            confirmButton.isSelected = true
            cancelButton.isSelected = false
            UIView.animate(withDuration: animationDuration(), delay: 0) {
                self.confirmButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                self.cancelButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    @IBAction func btnActionCancel() {
        if cancelButton.isSelected {
            didTapCancelButton()
        }
        else {
            confirmButton.isSelected = false
            cancelButton.isSelected = true
            UIView.animate(withDuration: animationDuration(), delay: 0) {
                self.confirmButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.cancelButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }
        }
    }
    
    // MARK: 手柄操控
    
    func gamepadKeyUpAction() {
        if confirmButton.isSelected {
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        confirmButton.isSelected = true
        cancelButton.isSelected = false
        UIView.animate(withDuration: animationDuration(), delay: 0) {
            self.confirmButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            self.cancelButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func gamepadKeyDownAction() {
        if cancelButton.isSelected {
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        confirmButton.isSelected = false
        cancelButton.isSelected = true
        UIView.animate(withDuration: animationDuration(), delay: 0) {
            self.confirmButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.cancelButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }
    }

    func gamepadKeyAAction() {
        appPlaySelectSound()
        if confirmButton.isSelected {
            didTapConfirmButton()
        }
        else if cancelButton.isSelected {
            didTapCancelButton()
        }
    }
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        closeButton.sendActions(for: .touchUpInside)
    }
}
