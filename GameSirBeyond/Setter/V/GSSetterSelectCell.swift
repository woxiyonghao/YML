//
//  GSSetterSelectCell.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/8.
//

import UIKit
import SnapKit
class GSSetterSelectCell: UIView {

    var menuModel:GSSetterMenuModel?{
        didSet{
            if let model = menuModel {
                
                setNeedsLayout()
                
                titleL.text = model.iconTxt
                
                if model.inSubMenu {
                    
                    self.width = GSSetterMenuWidth
                    
                    icon.image = UIImage(named: model.normalIcon)
                    titleL.textColor = model.normalIconTxtColor
                    self.backgroundColor = model.inSubMenuColor
                    
                    //246
                    titleL.snp.remakeConstraints { make in
                        make.centerX.equalTo(self.snp.centerX).offset(20.widthScale)
                        make.centerY.equalToSuperview()
                    }
                    icon.snp.remakeConstraints { make in
                        make.width.height.equalTo(24.widthScale)
                        make.centerY.equalToSuperview()
                        make.right.equalTo(titleL.snp.left).offset(-12.widthScale)
                    }
                    
                }
                else if model.select {
                    self.width = GSSetterMenuWidth + 8.widthScale
                    icon.image = UIImage(named: model.selectIcon)
                    titleL.textColor = model.selectIconTxtColor
                    self.backgroundColor = .hex("#ffffff")
                    
                    //246
                    titleL.snp.remakeConstraints { make in
                        make.centerX.equalTo(self.snp.centerX).offset(16.widthScale)
                        make.centerY.equalToSuperview()
                    }
                    icon.snp.remakeConstraints { make in
                        make.width.height.equalTo(24.widthScale)
                        make.centerY.equalToSuperview()
                        make.right.equalTo(titleL.snp.left).offset(-12.widthScale)
                    }
                    
                }
                else {
                    self.width = GSSetterMenuWidth + 8.widthScale
                    icon.image = UIImage(named: model.normalIcon)
                    titleL.textColor = model.normalIconTxtColor
                    self.backgroundColor = .clear
                    
                    //246
                    titleL.snp.remakeConstraints { make in
                        make.centerX.equalTo(self.snp.centerX).offset(16.widthScale)
                        make.centerY.equalToSuperview()
                    }
                    icon.snp.remakeConstraints { make in
                        make.width.height.equalTo(24.widthScale)
                        make.centerY.equalToSuperview()
                        make.right.equalTo(titleL.snp.left).offset(-12.widthScale)
                    }
                    
                    
                }
                
                blueView.backgroundColor = model.inSubMenu ? .hex("#ffffff"):.hex("#1A9FFC")
                
               
                blueView.snp.remakeConstraints { make in
                    make.width.equalTo(8.widthScale)
                    make.height.equalToSuperview()
                    make.right.equalToSuperview()
                    make.top.equalToSuperview()
                }
                
                UIView.animate(withDuration: 0.15) {[weak self] in
                    self?.layoutIfNeeded()
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.isUserInteractionEnabled = false
        
        addSubview(titleL)
       
        addSubview(icon)
       
        addSubview(blueView)
       
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
    
    lazy var blueView:UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
