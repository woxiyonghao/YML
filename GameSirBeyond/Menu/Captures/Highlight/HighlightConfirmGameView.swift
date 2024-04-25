//
//  HighlightConfirmGameView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/7.
//

import UIKit

class HighlightConfirmGameView: UIView {

    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmButton: AnimatedButton!
    @IBOutlet weak var changeGameButton: AnimatedButton!
    @IBOutlet weak var skipButton: AnimatedButton!
    @IBOutlet weak var backButton: AnimatedButton!
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("HighlightConfirmGameView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        gameCoverImageView.sd_setImage(with: URL(string: CaptureManager.shared.highlightCoverUrlFromGame)!)
        titleLabel.text = i18n(string: "Tag") + " " + CaptureManager.shared.highlightGameName + i18n(string: "?")
        
        confirmButton.setTitle("  ".appending(i18n(string: "Confirm")), for: .normal)
        changeGameButton.setTitle("  ".appending(i18n(string: "Change Game")), for: .normal)
        skipButton.setTitle("  ".appending(i18n(string: "Skip")), for: .normal)
        
        confirmButton.tapAction = {
            self.btnActionConfirm()
        }
        changeGameButton.tapAction = {
            self.btnActionChangeGame()
        }
        skipButton.tapAction = {
            self.btnActionSkip()
        }
        backButton.tapAction = {
            self.btnActionBack()
        }
        changeGameButton.setControllerImage(type: .y)
        skipButton.setControllerImage(type: .x)
        backButton.setControllerImage(type: .b)
        confirmButton.setControllerImage(type: .a)
        
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
    
    
    func btnActionBack() {
        displayNameView()
    }
    
    func btnActionSkip() {
        CaptureManager.shared.highlightGameID = ""
        displayPreviewView()
    }
    
    func btnActionChangeGame() {
        displayTagGameView()
    }
    
    func btnActionConfirm() {
        displayPreviewView()
    }
    
    func displayNameView() {
        let tagView = HighlightNameView(frame: bounds)
        superview?.addSubview(tagView)
        
        removeFromSuperview()
    }
    
    func displayTagGameView() {
        let tagView = HighlightTagGameView(frame: bounds)
        superview?.addSubview(tagView)
        
        removeFromSuperview()
    }
    
    func displayPreviewView() {
        let previewView = HighlightPreviewView(frame: bounds)
        superview?.addSubview(previewView)
        
        removeFromSuperview()
    }
    
    // MARK: 手柄操控
    
    func gamepadKeyAAction() {
        appPlaySelectSound()
        confirmButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        backButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyXAction() {
        appPlaySelectSound()
        skipButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyYAction() {
        appPlaySelectSound()
        changeGameButton.sendActions(for: .touchUpInside)
    }
}
