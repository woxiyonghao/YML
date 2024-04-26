//
//  HighlightPreviewView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/7.
//

import UIKit
//import SwiftVideoBackground

class HighlightPreviewView: UIView {

    @IBOutlet weak var videoBgView: UIView!
    @IBOutlet weak var uploadButton: AnimatedButton!
    @IBOutlet weak var cancelButton: AnimatedButton!
    @IBOutlet weak var backButton: AnimatedButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("HighlightPreviewView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        titleLabel.text = i18n(string: "Preview")
        subTitleLabel.text = i18n(string: "Visible to others")
        uploadButton.setTitle("  ".appending(i18n(string: "Upload")), for: .normal)
        cancelButton.setTitle("  ".appending(i18n(string: "Cancel")), for: .normal)
        
        uploadButton.tapAction = {
            self.btnActionUpload()
        }
        cancelButton.tapAction = {
            self.btnActionCancel()
        }
        backButton.tapAction = {
            self.btnActionBack()
        }
        cancelButton.setControllerImage(type: .x)
        backButton.setControllerImage(type: .b)
        uploadButton.setControllerImage(type: .a)
        
        waitingToPlayVideoUrl = URL(fileURLWithPath: CaptureManager.shared.highlightVideoURL)
        waitingToPlayVideoBgView = videoBgView
        appPlayVideo()
        
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
    
    func btnActionUpload() {
        CaptureManager.shared.uploadGameVideo { finish in
            if finish {
                NotificationCenter.default.post(name: Notification.Name("DidFinishSharingHighlightNotification"), object: nil)
                self.removeFromSuperview()
            }
        }
    }
    
    func btnActionBack() {
        displayConfirmGameView()
    }
    
    func btnActionCancel() {
        let quitView = QuitAccountView(frame: self.bounds)
        quitView.titleLabel.text = i18n(string: "Are you sure to delete the Highlight?")
        quitView.confirmButton.setTitle(i18n(string: "Delete"), for: .normal)
        quitView.cancelButton.setTitle(i18n(string: "Cancel"), for: .normal)
        superview?.addSubview(quitView)
        quitView.didTapConfirmButton = {
            NotificationCenter.default.post(name: Notification.Name("DidFinishSharingHighlightNotification"), object: nil)
            self.removeFromSuperview()
            quitView.removeFromSuperview()
        }
        quitView.didTapCancelButton = {
            quitView.removeFromSuperview()
        }
        quitView.didTapCloseButton = {
            quitView.removeFromSuperview()
        }
    }
    
    func displayConfirmGameView() {
        let confirmGameView = HighlightConfirmGameView(frame: bounds)
        superview?.addSubview(confirmGameView)
        
        removeFromSuperview()
    }
    
    // MARK: 手柄操控
    
    func gamepadKeyAAction() {
        appPlaySelectSound()
        uploadButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        backButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyXAction() {
        appPlaySelectSound()
        cancelButton.sendActions(for: .touchUpInside)
    }
}
