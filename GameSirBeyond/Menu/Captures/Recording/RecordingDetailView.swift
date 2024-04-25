//
//  RecordingDetailView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/3/16.
//

import UIKit

class RecordingDetailView: UIView {

    @IBOutlet weak var closeButton: AnimatedButton!
    @IBOutlet weak var shareButton: AnimatedButton!
    
    var videoUrl: String = "" {
        didSet {
            if videoUrl == "" {
                return
            }
            waitingToPlayVideoUrl = URL(fileURLWithPath: videoUrl)
            waitingToPlayVideoBgView = contentView
            appPlayVideo()
        }
    }
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("RecordingDetailView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.contentMode = .scaleAspectFit
        
        closeButton.setTitle("  ".appending(i18n(string: "Close")), for: .normal)
        closeButton.tapAction = {
            appPauseVideo()
            self.removeFromSuperview()
        }
        shareButton.setControllerImage(type: .y)
        closeButton.setControllerImage(type: .b)
        
        shareButton.tapAction = {
            self.displayHighlightNameView()
            CaptureManager.shared.highlightVideoURL = self.videoUrl
            let imagePath = self.videoUrl.replacingOccurrences(of: "mp4", with: "png")
            print("封面地址：",imagePath)
            CaptureManager.shared.highlightCoverUrlFromVideo = imagePath
            appPauseVideo()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(resumeVideo), name: Notification.Name("DidFinishSharingHighlightNotification"), object: nil)
    }
    
    @objc func resumeVideo() {
        MainThread {
            waitingToPlayVideoUrl = URL(fileURLWithPath: self.videoUrl)
            waitingToPlayVideoBgView = self.contentView
            appPlayVideo()
        }
    }
    
    func displayHighlightNameView() {
        let nameView = HighlightNameView(frame: bounds)
        superview?.addSubview(nameView)
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
        closeButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyYAction() {
        shareButton.sendActions(for: .touchUpInside)
    }

}
