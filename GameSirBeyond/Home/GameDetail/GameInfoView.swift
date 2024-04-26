//
//  GameInfoView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/30.
//

import UIKit
import Moya
import SwiftyJSON
import SwiftVideoBackground

class GameInfoView: UIView {
    
    var updateDownloadButtonTitleCallback: (_: String) -> Void = { title in }
    
    var highlightsCollectionView: VideoCollectionView!
    var screenshotsCollectionView: ImageCollectionView!
    
    var highlightsLineTitleTop = 0.0
    var screenshotsLineTitleTop = 0.0
    
    var gameID: String = "" {
        didSet {
            requestGameDetail()
        }
    }
    
    var didUpdateContentHeight: (_: CGFloat) -> Void = { height in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: 游戏详情数据
    var detailModel: GameDetailModel? = nil
    func requestGameDetail() {
        if gameID == "" { return }
        
        let networker = MoyaProvider<GameService>()
        networker.request(.getGameDetail(gameID: String(gameID))) { result in
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
                    //print("获取游戏详情成功")
                    let gameDetail = (responseData["data"] as! [String: Any])["result"] as! [String: Any]
                    //print("游戏详情：", gameDetail)
                    
                    let model = GameDetailModel(JSONString: gameDetail.string()!)!
                    self.detailModel = model
                    
                    // 更新下载按钮为：下载 或者 打开
                    if GameManager.shared.checkGameCanOpen(urlSchemes: model.urlSchemes) {
                        self.updateDownloadButtonTitleCallback(i18n(string: "Open"))
                    }
                    else {
                        self.updateDownloadButtonTitleCallback(i18n(string: "Download"))
                    }
                    
                    self.initSubviews()
                }
                else {
                    //print("获取游戏详情失败", responseData["msg"]!)
                }
            }
            case .failure(_): do {
                //print("网络错误")
            }
                break
            }
        }
    }
    
    func initSubviews() {
        var contentMaxY = 0.0// 每增加一项内容，更新一次此数据
        let commonLeftPadding = 57.0
        
        // 游戏名称
        let nameLabel = UILabel(frame: CGRect(x: 57.0, y: 10.0, width: 350, height: 22))
        addSubview(nameLabel)
        nameLabel.text = detailModel!.name
        nameLabel.font = pingFangM(size: 18)
        nameLabel.textColor = .white
        
        contentMaxY = CGRectGetMaxY(nameLabel.frame) + 5.0

        // 游戏平台
        let platforms = detailModel!.platforms
        if platforms.count > 0 {
            var lastPlatformImageViewMaxX = 47.0
            let platformY = contentMaxY
            var platformWidth = 110.0
//            for index in 0..<platforms.count {
//                let platform = platforms[index]
//                let logoImageName =  platform.abbrName.lowercased()
//                switch logoImageName {
//                case "xcloud":
//                    platformWidth = 82.0
//                case "apple arcade":
//                    platformWidth = 130.0
//                case "playstation":
//                    platformWidth = 141.0
//                case "app store":
//                    platformWidth = 110.0
//                default:
//                    platformWidth = 0.0
//                }
//                
//                let platformImageView = UIImageView()
//                platformImageView.layer.masksToBounds = true
//                platformImageView.layer.cornerRadius = 12.0
//                addSubview(platformImageView)
//                platformImageView.contentMode = .scaleAspectFill
//                print("平台logo数据：", platform.logo, platform.abbrName, platform.name, platform.id)
//                if platform.logo != "" {
//                    platformImageView.sd_setImage(with: URL(string: platform.logo))
//                }
//                else {
//                    let image = UIImage(named: "platform_long_".appending(platform.name).lowercased())
//                    if image != nil {
//                        platformImageView.image = image
//                    }
//                    else {
//                        platformWidth = 0.0
//                    }
//                }
                
//                platformImageView.frame = CGRect(x: lastPlatformImageViewMaxX+10, y: platformY, width: platformWidth, height: 24.0)
//                lastPlatformImageViewMaxX = CGRectGetMaxX(platformImageView.frame)
//                contentMaxY = CGRectGetMaxY(platformImageView.frame) + 10.0
//            }
        }

        let highlights = detailModel!.highlights
        if highlights.count > 0 {
            let titleLabel = UILabel.init(frame: CGRect(x: commonLeftPadding, y: contentMaxY, width: UIScreen.main.bounds.size.width, height: 30))
            titleLabel.text = i18n(string: "Highlights")
            titleLabel.font = pingFangM(size: 20)
            titleLabel.textColor = .white
            addSubview(titleLabel)
            highlightsLineTitleTop = CGRectGetMinY(titleLabel.frame)
            
            // 高光时刻：视频
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize.init(width: bigCardWidth(), height: bigCardHeight())
            // ❗️collectionView的height必须大于卡片的height，否则报错（这里设为1.2倍才不报错）
            highlightsCollectionView = VideoCollectionView(frame: CGRect(x: 0, y: CGRectGetMaxY(titleLabel.frame) + 10, width: UIScreen.main.bounds.size.width, height: bigCardHeight()*1.2), collectionViewLayout: flowLayout)
            highlightsCollectionView.backgroundColor = .clear
            highlightsCollectionView.cellScale = 1.2
            addSubview(highlightsCollectionView)
            highlightsCollectionView.collectionViewDatas = highlights
            contentMaxY = CGRectGetMaxY(highlightsCollectionView.frame) + 30
        }
        
        let screenshots = detailModel!.screenshotURLs
        if screenshots.count > 0 {
            let titleLabel = UILabel.init(frame: CGRect(x: commonLeftPadding, y: contentMaxY, width: UIScreen.main.bounds.size.width, height: 30))
            titleLabel.text = i18n(string: "Screenshots")
            titleLabel.font = pingFangM(size: 20)
            titleLabel.textColor = .white
            addSubview(titleLabel)
            screenshotsLineTitleTop = CGRectGetMinY(titleLabel.frame)
                                                    
            // 游戏截图：图片
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize.init(width: bigCardWidth(), height: bigCardHeight())
            // ❗️collectionView的height必须大于卡片的height，否则报错（这里设为1.2倍才不报错）
            screenshotsCollectionView = ImageCollectionView(frame: CGRect(x: 0, y: CGRectGetMaxY(titleLabel.frame) + 10, width: UIScreen.main.bounds.size.width, height: bigCardHeight()*1.2), collectionViewLayout: flowLayout)
            screenshotsCollectionView.backgroundColor = .clear
            screenshotsCollectionView.cellScale = 1.2
            addSubview(screenshotsCollectionView)
            screenshotsCollectionView.collectionViewDatas = screenshots
            contentMaxY = CGRectGetMaxY(screenshotsCollectionView.frame) + 30
        }
        
        do {
            // 游戏描述：文字
            let desc = detailModel!.desc
            let rect = desc.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width-commonLeftPadding*2, height: 10000), options: .usesLineFragmentOrigin, attributes: [.font: pingFang(size: 15)], context: nil)
            
            let descLabel = UILabel.init(frame: CGRect(x: commonLeftPadding, y: contentMaxY, width: UIScreen.main.bounds.size.width-commonLeftPadding*2, height: rect.size.height))
            descLabel.numberOfLines = 0
            descLabel.text = desc
            descLabel.font = pingFang(size: 15)
            descLabel.textColor = .white
            addSubview(descLabel)
            
            contentMaxY = CGRectGetMaxY(descLabel.frame) + 69// 69：不遮挡按钮
        }
        
        didUpdateContentHeight(contentMaxY)// 更新高度
    }
    
}
