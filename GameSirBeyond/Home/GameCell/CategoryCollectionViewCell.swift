//
//  CategoryCollectionViewCell.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/24.
//

import UIKit

/// 游戏【分类】（Categories）专题的Cell
class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var gameModel: SimpleGameModel? = nil {
        didSet {
            if gameModel != nil {
                initSubview()
            }
        }
    }

    func initSubview() {
        if gameModel?.coverURL != "" {
            coverImageView.sd_setImage(with: URL(string: gameModel!.coverURL)!, placeholderImage: UIImage(named: "full_bg"))
        }
        else {
            coverImageView.image = UIImage(named: "category_bg")
        }
        nameLabel.text = gameModel?.name
        let number = gameModel?.categoryNumber
        let gameNumberString = String(number!).appending(i18n(string: " Games"))
        numberLabel.text = gameNumberString
    }
}
