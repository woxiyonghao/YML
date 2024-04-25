//
//  ImageCollectionViewCell.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/9.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImgView: UIImageView!
    
    var coverURL: String = "" {
        didSet {
            initSubview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initSubview() {
        // 游戏封面
        coverImgView.sd_setImage(with: URL(string: coverURL), placeholderImage: UIImage(named: "full_bg"))
    }

}
