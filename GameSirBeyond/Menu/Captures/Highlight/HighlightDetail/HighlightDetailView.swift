//
//  HighlightDetailView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/27.
//

import UIKit
import SwiftVideoBackground
import Moya
import SwiftyJSON

class HighlightDetailView: UIView {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var videoBgView: UIView!
    @IBOutlet weak var closeButton: AnimatedButton!
    @IBOutlet weak var likeButton: AnimatedButton!
    var closeCallback = {}
    
    var videoId = 0 {
        didSet {
            print("设置视频ID：\(self.videoId)")
            requestHighlightDetail()
        }
    }
    
    var likeNum = 0 {
        didSet {
            if likeNum <= 99 {
                self.likeButton.setTitle("  ❤️ ".appending(String(likeNum)), for: .normal)
            }
            else {
                self.likeButton.setTitle("  ❤️ ".appending("99+"), for: .normal)
            }
        }
    }
    
    var videoUrl: String = "" {
        didSet {
            if videoUrl == "" {
                return
            }
            waitingToPlayVideoUrl = URL(string: videoUrl)!
            waitingToPlayVideoBgView = videoBgView
            appPlayVideo()
        }
    }
    
    var coverUrl: String = "" {
        didSet {
            if coverUrl == "" {
                return
            }
            bgImageView.sd_setImage(with: URL(string: coverUrl)!)
        }
    }
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("HighlightDetailView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.contentMode = .scaleAspectFit
        
        likeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        closeButton.tapAction = {
            appPauseVideo()
            self.closeCallback()
            self.removeFromSuperview()
        }
        likeButton.tapAction = {
            self.likeOrUnlikeVideo()
        }
        likeButton.setControllerImage(type: .x)
        closeButton.setControllerImage(type: .b)
    }
    
    // MARK: 获取视频详细数据
    func requestHighlightDetail() {
        let networker = MoyaProvider<GameService>()
        networker.request(.getVideoDetail(videoId: videoId)) { result in
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                if data == nil {return}
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 {
                    print("获取视频详情成功")
                    let data = (responseData["data"] as! [String: Any])["result"] as! [String: Any]
                    if data.keys.contains("likeNum") {
                        let likeNum = data["likeNum"] as? Int ?? 0
                        // 更新点赞数量
                        self.likeNum = likeNum
                    }
                }
                else {
                    print("获取视频详情失败：", responseData["msg"]!)
                }
            }
            case .failure(_): do {
                print("获取视频详情失败：网络错误")
            }
                break
            }
        }
    }
    
    func likeOrUnlikeVideo() {
        let networker = MoyaProvider<UserService>()
        networker.request(.likeOrUnlikeVideo(id: videoId)) { result in
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                if data == nil {return}
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 {
                    print("点赞/取消点赞成功")
                    let likeNum = (responseData["data"] as! [String: Any])["likeNum"] as? Int
                    self.likeNum = likeNum ?? 0
                }
                else {
                    print("点赞/取消点赞失败：", responseData["msg"]!)
                }
            }
            case .failure(_): do {
                print("点赞/取消点赞失败：网络错误")
            }
                break
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
        closeButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyXAction() {
        likeButton.sendActions(for: .touchUpInside)
    }

}
