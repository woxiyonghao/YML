//
//  TabTableViewCell.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/24.
//

import UIKit

class TabTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var type: String? = SettingsTabType.none.rawValue
    var data: [String: String] = [:] {
        didSet {
            iconImageView.image = UIImage(named: data[SettingsTabDataKey.icon.rawValue]!)!
            titleLabel.text = data[SettingsTabDataKey.title.rawValue]!
            type = data[SettingsTabDataKey.type.rawValue]
            var number = data[SettingsTabDataKey.number.rawValue]!
            if Int(number)! > 0 {
                numberLabel.isHidden = false
                
                if Int(number)! > 99 {
                    number = "99+"
                }
                numberLabel.text = number
            }
            else {
                numberLabel.isHidden = true
            }
        }
    }
    
    // 为了显示非选中状态下的背景图片
    var isGrayStatus: Bool = false {
        didSet {
            bgImgView.isHidden = !isGrayStatus
        }
    }
    
    var selectedBgImgView: UIImageView!
    var bgImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        clipsToBounds = false
        
        //selectedBgImgView = UIImageView(image: UIImage.init(named: "tableview_cell_bg_selected")!)
        selectedBgImgView = UIImageView(image: UIImage(named: "tableview_cell_bg_selected"))
        addSubview(selectedBgImgView)
        selectedBgImgView.frame = CGRect(x: 0, y: 0, width: 206, height: 47)// 超出6pt
        selectedBgImgView.isHidden = true
        selectedBgImgView.contentMode = .scaleAspectFill
        sendSubviewToBack(selectedBgImgView)
        
        //bgImgView = UIImageView(image: UIImage.init(named: "tableview_cell_bg")!)
        selectedBgImgView = UIImageView(image: UIImage(named: "tableview_cell_bg"))
        addSubview(bgImgView)
        bgImgView.frame = CGRect(x: 0, y: 0, width: 200, height: 47)
        bgImgView.isHidden = true
        bgImgView.contentMode = .scaleAspectFill
        sendSubviewToBack(bgImgView)
        
        if isIPhoneXOrLaterDevice() {
            iconLeftConstraint.constant = 0
        }
        else {
            iconLeftConstraint.constant = 50
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            // 图片黑色、文字黑色、显示背景图片
            if data.keys.contains(SettingsTabDataKey.selectedIcon.rawValue) {
                iconImageView.image = UIImage(named: data[SettingsTabDataKey.selectedIcon.rawValue]!)
            }
            titleLabel.textColor = color(hex: 0x4E4E4E)
            selectedBgImgView.isHidden = false
            
            isGrayStatus = false
        }
        else {
            // 图片灰色、文字灰色、隐藏背景图片
            if data.keys.contains(SettingsTabDataKey.icon.rawValue) {
                iconImageView.image = UIImage(named: data[SettingsTabDataKey.icon.rawValue]!)
            }
            titleLabel.textColor = color(hex: 0xF2F2F2)
            selectedBgImgView.isHidden = true
            
            isGrayStatus = false
        }
    }
    
}
