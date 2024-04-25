//
//  GameCollectionViewCell.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/1.
//

import UIKit
import SwiftVideoBackground

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImgView: UIImageView!
    var isDisplayPurely = false
    var bigSize = CGSize(width: smallCardWidth()*1.2, height: smallCardHeight()*1.2)
    var isFocusing = false// 处于放大状态
    var isProductIntroTopic = false
    
    var gameModel: SimpleGameModel? = nil {
        didSet {
            if gameModel != nil {
                initSubview()
            }
        }
    }
    
    let nameLabelMaxWidth = 150.0// smallCardWidth() - 15*2
    var gradView = UIView(frame: CGRect.zero)
    
    func initSubview() {
        // 删除cell上的控件
        for subview in contentView.subviews {
            if subview.tag >= 111 {
                subview.removeFromSuperview()
            }
        }
        
        // 游戏封面
        coverImgView.sd_setImage(with: URL(string: (gameModel?.coverURL)!), placeholderImage: UIImage(named: "full_bg"))
        
        if isDisplayPurely { return }
        
        // 渐变背景
        gradView = UIView(frame: CGRect(x: 0, y: 0, width: bigSize.width, height: bigSize.height))
        contentView.addSubview(gradView)
        gradView.tag = 111
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.2)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = gradView.bounds
        gradView.layer.addSublayer(gradientLayer)
        
        if isProductIntroTopic {
            let contentLabel = UILabel(frame: CGRect(x: 15, y: bigSize.height-15-15, width: bigSize.width-30, height: 15))
            contentView.addSubview(contentLabel)
            contentLabel.font = pingFang(size: 13.0)
            contentLabel.text = gameModel?.content
            contentLabel.textColor = .white
            contentLabel.tag = 222
            
            let descLabel = UILabel(frame: CGRect(x: CGRectGetMinX(contentLabel.frame), y: CGRectGetMinY(contentLabel.frame)-15-10, width: bigSize.width-30, height: 15))
            contentView.addSubview(descLabel)
            descLabel.font = pingFangM(size: 14.0)
            descLabel.text = gameModel?.title
            descLabel.textColor = .white
            descLabel.tag = 333
        }
        else {
            let platforms = (gameModel?.platforms)!
            /** 游戏平台logo
             布局要求：
             logo大小：(32, 24)
             行内间距：6
             行间距：6
             最大使用宽度：146，超限时换行显示// 146刚好显示4个
             最左侧的logo距离cell的左边距离：15
             最底部的logo距离cell的底部距离：15
             */
            var logoCount = 0// 测试用
            logoCount = platforms.count
            var lastLogoFrame = CGRect.zero
            for index in 0..<logoCount {
                let platform = platforms[index]
                let logoWidth = 32.0
                let logoHeight = 24.0
                let horiPadding = 6.0
                let vertiPadding = 6.0
                let firstLeft = 15.0
                let bottomPadding = 10.0
                // 先预估需要多少行来显示logo
                var needLine = 1
                let needWidth = logoWidth*CGFloat(logoCount) + horiPadding*CGFloat(logoCount-1)
                if needWidth > nameLabelMaxWidth {
                    needLine = Int(needWidth/nameLabelMaxWidth) + 1
                }
                // 根据行数算出初始y
                let startY = bigSize.height-bottomPadding-logoHeight*CGFloat(needLine)-vertiPadding*CGFloat(needLine-1)
                var x = 0.0
                var y = 0.0
                var width = logoWidth
                let height = logoHeight
                // 根据即将创建的logo的预期位置算出frame
                if lastLogoFrame == .zero {
                    x = firstLeft
                    y = startY
                }
                else {
                    var needChangeLine = false
                    let currentNeedWidth = CGRectGetMaxX(lastLogoFrame) + horiPadding + logoWidth - firstLeft// 需减去左侧边距firstLeft
                    if currentNeedWidth > nameLabelMaxWidth {
                        needChangeLine = true
                    }
                    
                    if !needChangeLine {
                        x = CGRectGetMaxX(lastLogoFrame) + horiPadding
                        y = CGRectGetMinY(lastLogoFrame)
                    }
                    else {
                        x = firstLeft
                        y = CGRectGetMaxY(lastLogoFrame) + vertiPadding
                    }
                }
                let platformImageView = UIImageView.init()
//                print("平台图片Logo：\(platform.logo)")
                
//                if platform.logo != "" {
//                    platformImageView.sd_setImage(with: URL(string: platform.logo))
//                }
//                else {
////                    print("platform.name: ", platform.name)
//                    let image = UIImage(named: "platform_".appending(platform.name).lowercased())
//                    if image != nil {
//                        platformImageView.image = image
//                    }
//                    else {
//                        width = 0.0
//                    }
//                }
                platformImageView.tag = index + 222
                contentView.addSubview(platformImageView)
                platformImageView.frame = CGRect(x: x, y: y, width: width, height: height)
                platformImageView.layer.cornerRadius = height/2.0
                platformImageView.layer.masksToBounds = true
                
                lastLogoFrame = platformImageView.frame
            }
            
            // 游戏名称，布局依据最顶部的平台logo的位置
            let logoNamePadding = 11.0
            let bottomPadding = 15.0
            
            let x = 15.0
            var y = 0.0
            var textWidth = 0.0
            let height = 18.0
            let firstLogoImgView = contentView.viewWithTag(222)
            if firstLogoImgView != nil {
                let logoY = CGRectGetMinY(firstLogoImgView!.frame)
                y = logoY - logoNamePadding - height
            }
            else {
                y = bigSize.height - bottomPadding - height
            }
            
            let nameBgView = UIView(frame: CGRect(x: x, y: y, width: nameLabelMaxWidth, height: height))
            nameBgView.backgroundColor = .clear
            nameBgView.tag = 333
            contentView.addSubview(nameBgView)
            nameBgView.clipsToBounds = true
            let nameLabel = UILabel(frame: .zero)
            nameBgView.addSubview(nameLabel)
            nameLabel.textColor = .white
            nameLabel.font = pingFangM(size: 16.0)
            nameLabel.text = gameModel?.name
            //        nameLabel.text = "Xbox Cloud"
            let textRect = nameLabel.text!.boundingRect(with: CGSize(width: CGFLOAT_MAX, height: height), options: .usesLineFragmentOrigin, attributes: [.font: nameLabel.font!], context: nil)
            textWidth = textRect.size.width + 1.0
            nameLabel.frame = CGRect(x: 0, y: 0, width: textWidth, height: height)
            
            // 文字超过maxWidth，滚动显示
            delay(interval: 1.5) {
                self.autoScrollingLongName(label: nameLabel)
            }
        }
    }
    
    func displayUnfocusView() {
        pauseVideo()

        for subview in contentView.subviews {
            if subview.tag >= 111 {
                subview.isHidden = true
            }
        }
    }
    
    func displayFocusView() {
        playVideo()

        if isDisplayPurely { return }

        for subview in contentView.subviews {
            if subview.tag >= 111 {
                subview.isHidden = false
            }
        }
    }
    
    func playVideo() {
        if gameModel!.videoURL != "" {
            let videoBgView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bigSize.width, height: self.bigSize.height))
            self.contentView.addSubview(videoBgView)
            videoBgView.backgroundColor = .clear
            waitingToPlayVideoBgView = videoBgView
            
            let url = URL(string: self.gameModel!.videoURL)
            if url != nil {
                waitingToPlayVideoUrl = url
            }
            
            delay(interval: 2) {
                if self.isFocusing {
                    appPlayVideo()
                }
            }
        }
    }
    
    func pauseVideo() {
        appPauseVideo()
    }
    
    func autoScrollingLongName(label: UILabel) {
        let size = label.text!.size(withAttributes: [.font: label.font!])
        let textWidth = size.width+1
        if textWidth > nameLabelMaxWidth {
            
            // 创建一个label，用于循环显示游戏名
            //            let nameLabel = UILabel(frame: CGRect(x: 146+15, y: 0, width: CGRectGetWidth(label.frame), height: CGRectGetHeight(label.frame)))
            //            label.superview?.addSubview(nameLabel)
            //            nameLabel.text = label.text
            //            nameLabel.textColor = label.textColor
            //            nameLabel.font = label.font
            
            //            let ani = CABasicAnimation(keyPath: "position.x")// position.x：nameLabel的centerX
            //            ani.fromValue = textWidth/2.0
            //            ani.toValue = -textWidth/2.0
            //            ani.duration = 5
            //            ani.fillMode = .removed
            //            ani.repeatCount = 1
            //            label.layer.add(ani, forKey: "AnimationKey1")
            //
            //            delay(interval: 5) {
            let ani2 = CABasicAnimation(keyPath: "position.x")
            ani2.fromValue = textWidth + textWidth/2.0
            ani2.toValue = -textWidth/2.0
            ani2.duration = 5
            ani2.fillMode = .forwards
            ani2.repeatCount = MAXFLOAT
            label.layer.add(ani2, forKey: "AnimationKey2")
            //            }
            
            //            let ani2 = CABasicAnimation(keyPath: "position.x")
            //            ani2.fromValue = textWidth/2.0 + textWidth + 15.0
            //            ani2.toValue = -textWidth/2.0 + textWidth + 15.0
            //            ani2.duration = 5
            //            ani2.fillMode = .forwards
            //            ani2.repeatCount = MAXFLOAT
            //            nameLabel.layer.add(ani2, forKey: "AnimationKey2")
        }
    }
}
