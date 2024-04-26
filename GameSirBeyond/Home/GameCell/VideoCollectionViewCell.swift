//
//  VideoCollectionViewCell.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/9.
//

import UIKit
//import SwiftVideoBackground

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImgView: UIImageView!
    
    var model: VideoModel? = nil {
        didSet {
            if model != nil {
                initSubview()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initSubview() {
        // 游戏封面
        coverImgView.sd_setImage(with: URL(string: (model?.coverURL)!), placeholderImage: UIImage(named: "full_bg"))
    }
    
    func playVideo() {
        if model!.videoURL != "" {
            let newVideoBgView = UIView.init(frame: bounds)
            addSubview(newVideoBgView)
            newVideoBgView.tag = 888
            
            waitingToPlayVideoBgView = newVideoBgView
            waitingToPlayVideoUrl = URL(string: model!.videoURL)!
            appPlayVideo()
            print(model!.videoURL)
        }
    }
    
    func pauseVideo() {
        let bgView = contentView.viewWithTag(888)
        bgView?.removeFromSuperview()
    }

}
