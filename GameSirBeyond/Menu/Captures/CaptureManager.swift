//
//  CaptureManager.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/6.
//

import UIKit
import Moya
import SwiftyJSON

class CaptureManager: NSObject {
    
    static var shared: CaptureManager = {
        let instance = CaptureManager.init()
        return instance
    }()
    
    var shouldReuqestHighlightData = true
    
    var highlightVideoURL = ""// 本地文件
    var highlightGameID = ""
    var highlightTitle = ""
    var highlightCoverUrlFromVideo = "" {// 本地文件
        didSet {
            let a = 0
            print(a)
            print("封面地址：", highlightCoverUrlFromVideo)
        }
    }
    var highlightGameName = ""
    var highlightCoverUrlFromGame = ""
    
    // MARK: 上传视频
    typealias UploadVideoCallback = (_: Bool) -> Void
    func uploadGameVideo(callback: @escaping UploadVideoCallback) {
        let networker = MoyaProvider<GameService>()
        do {
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: highlightVideoURL), options: .alwaysMapped)
            let coverData = try Data.init(contentsOf: URL.init(fileURLWithPath: highlightCoverUrlFromVideo), options: .alwaysMapped)
            MBProgressHUD.showActivityLoading(i18n(string: "Uploading..."))
            networker.request(.shareGameVideo(gameID: highlightGameID, title: highlightTitle, videoData: data, coverImageData: coverData)) { result in
                switch result {
                case let .success(response): do {
                    let data = try? response.mapJSON()
                    let json = JSON(data!)
                    let responseData = json.dictionaryObject!
                    let code = responseData["code"] as! Int
                    if code == NetworkErrorType.NeedLogin.rawValue {
                        NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                        return
                    }
                    if code == 200 {
                        print("分享视频成功")
                        MBProgressHUD.showMsgWithtext(i18n(string: "Share successfully"))
                        self.shouldReuqestHighlightData = true
                        callback(true)
                    }
                    else {
                        MBProgressHUD.showMsgWithtext(i18n(string: "Failed to share") + i18n(string: ":") + (responseData["msg"] as! String))
                        print("分享视频失败", responseData["msg"]!)
                    }
                }
                case .failure(_): do {
                    print("网络错误")
                }
                    break
                }
            }
        }
        catch {
           print("视频文件错误：", error)
        }
    }
}
