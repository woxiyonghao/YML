//
//  GSSetterMenuCell.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/8.
//

import UIKit
import RxSwift
import SnapKit
class GSSetterMenuCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    var menuModel:GSSetterMenuModel?{
        didSet{
            if let model = menuModel {
                titleL.text = model.iconTxt
                icon.image = UIImage(named: model.normalIcon)
                titleL.textColor = model.normalIconTxtColor
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        
        contentView.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(24.widthScale)
            make.centerY.equalToSuperview()
            make.right.equalTo(titleL.snp.left).offset(-12.widthScale)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    lazy var icon:UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .clear
        return i
    }()
    
    lazy var titleL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .left
        l.textColor = .hex("#cccccc")
        l.font = font_16(weight: .semibold)
        return l
    }()
}
