//
//  ScreenshotCollectionViewCell.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/21.
//

import UIKit

class ScreenshotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    func set(image: UIImage) {
        coverImageView.image = image
    }
}
