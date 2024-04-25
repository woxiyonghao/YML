//
//  GameDetailView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/10/20.
//

import UIKit

class GameDetailView: UIView {

    @IBOutlet weak var scrollView: GameDetailScrollView!
    @IBOutlet weak var backButton: AnimatedButton!
    @IBOutlet weak var shareButton: AnimatedButton!
    @IBOutlet weak var downloadButton: AnimatedButton!
    
    var backCallback = {}
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        addBlurEffect(style: .dark, alpha: 1)
        
        contentView = ((Bundle.main.loadNibNamed("GameDetailView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        shareButton.setTitle("  ".appending(i18n(string: "Share")), for: .normal)
        downloadButton.setTitle("  ".appending(i18n(string: "Download")), for: .normal)
        backButton.tapAction = {
            self.backCallback()
        }
        shareButton.tapAction = {
            self.scrollView.shareGame()
        }
        downloadButton.tapAction = {
            self.scrollView.downloadGame()
        }
        
        shareButton.setControllerImage(type: .y)
        downloadButton.setControllerImage(type: .x)
        backButton.setControllerImage(type: .b)
        
        scrollView.updateDownloadButtonTitleCallback = { title in
            MainThread {
                self.downloadButton.setTitle("  ".appending(title), for: .normal)
            }
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
        if UIViewController.current() is UIActivityViewController {
            (UIViewController.current() as! UIActivityViewController).dismiss(animated: true)
            appPlaySelectSound()
            return
        }
        
        appPlaySelectSound()
        backButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyXAction() {
        appPlaySelectSound()
        downloadButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyYAction() {
        appPlaySelectSound()
        shareButton.sendActions(for: .touchUpInside)
    }
}
