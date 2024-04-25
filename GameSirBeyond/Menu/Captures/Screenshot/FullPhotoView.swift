//
//  FullPhotoView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/28.
//

import UIKit

class FullPhotoView: UIView {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var closeButton: AnimatedButton!
    @IBOutlet weak var shareButton: AnimatedButton!
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        addBlurEffect(style: .dark, alpha: 1)
        
        contentView = ((Bundle.main.loadNibNamed("FullPhotoView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        shareButton.setTitle("  ".appending(i18n(string: "Share")), for: .normal)
        shareButton.tapAction = {
            self.btnActionShare()
        }
        closeButton.tapAction = {
            self.removeFromSuperview()
        }
        shareButton.setControllerImage(type: .y)
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
    
    var systemSharePage: UIActivityViewController?
    func btnActionShare() {
        systemSharePage = UIActivityViewController.init(activityItems: [i18n(string: "Egg Shell App - Share game highlight"), photoImageView.image!, URL.init(string: "https://itunes.apple.com/app/id".appending(thisAppAppleId))!], applicationActivities: nil)
        if systemSharePage!.responds(to: NSSelectorFromString("popoverPresentationController")) {
            systemSharePage!.popoverPresentationController?.sourceView = self
        }
        UIViewController.current()!.present(systemSharePage!, animated: true, completion: nil)
        
        systemSharePage!.completionWithItemsHandler = { activityType, finish, returnedItems, activityError in
            if finish {
                print("分享成功")
            }
            else {
                print("分享出错：", activityError as Any)
            }
        }
    }
    
    // MARK: 手柄操控
    
    func gamepadKeyBAction() {
        if UIViewController.current() is UIActivityViewController {
            (UIViewController.current() as! UIActivityViewController).dismiss(animated: true)
            appPlaySelectSound()
            return
        }
        
        appPlaySelectSound()
        closeButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyYAction() {
        if UIViewController.current() is UIActivityViewController {
            appPlayIneffectiveSound()
            return
        }
        
        appPlaySelectSound()
        shareButton.sendActions(for: .touchUpInside)
    }
}
