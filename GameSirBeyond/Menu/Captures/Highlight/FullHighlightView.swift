//
//  FullHighlightView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/5.
//

import UIKit

class FullHighlightView: UIView {

    var videoModel: VideoModel? = nil
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var closeButton: AnimatedButton!
    @IBOutlet weak var shareButton: AnimatedButton!
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("FullHighlightView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        shareButton.setTitle("  ".appending(i18n(string: "Share")), for: .normal)
        shareButton.tapAction = {
            self.btnActionShare()
        }
        closeButton.tapAction = {
            self.btnActionClose()
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

    func btnActionClose() {
        removeFromSuperview()
    }
    
    func btnActionShare() {
        if videoModel?.videoURL == "" { return }
        
        let systemSharePage = UIActivityViewController.init(activityItems: [i18n(string: "Egg Shell App - Share game highlight"), URL(string: videoModel!.videoURL)!, URL.init(string: "https://itunes.apple.com/app/id".appending(thisAppAppleId))!], applicationActivities: nil)
        if systemSharePage.responds(to: NSSelectorFromString("popoverPresentationController")) {
            systemSharePage.popoverPresentationController?.sourceView = coverImageView
        }
        UIViewController.current()!.present(systemSharePage, animated: true, completion: nil)
        
        systemSharePage.completionWithItemsHandler = { activityType, finish, returnedItems, activityError in
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
        appPlaySelectSound()
        closeButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyYAction() {
        appPlaySelectSound()
        shareButton.sendActions(for: .touchUpInside)
    }
    
}
