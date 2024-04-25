//
//  GSSetterRightCell.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/8.
//

import UIKit
import SnapKit
import RxSwift
enum GSSetterRightCellStyle {
    case about
    case help
    case recode
    case link
    case accound
    case joycon
    /**************/
    case joyconDetail
    case recodeFPS
    case recodeFormat
    case recodeBitRate
}

class GSSetterRightCell: UITableViewCell {
    
    public var myModel:GSSetterMenuOPModel?
    public var myStyle:GSSetterRightCellStyle?
    
    public var touchEnterHandler = {(this:GSSetterRightCell) in}
    public var touchLeaveHandler = {(this:GSSetterRightCell) in}
    func fullModel(model:GSSetterMenuOPModel,style:GSSetterRightCellStyle){
        defer {
            contentView.layoutIfNeeded()
            
            if model.select {
                bg.snp.remakeConstraints { make in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-8.widthScale)
                    make.left.equalToSuperview().offset(0).priority(.high)
                    make.right.equalToSuperview().offset(0).priority(.high)
                }
            }
            else{
                bg.snp.remakeConstraints { make in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-8.widthScale)
                    make.left.equalToSuperview().offset(14.widthScale).priority(.high)
                    make.right.equalToSuperview().offset(-14.widthScale).priority(.high)
                }
            }
            isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.15) {[weak self] in
                self?.contentView.layoutIfNeeded()
            } completion: { [weak self] finish in
                if finish {
                    self?.isUserInteractionEnabled = true
                }
            }

            
        }
        contentView.setNeedsLayout()
        
        clearAllSnp()
        myModel = model
        myStyle = style
        subtitleL.text = model.subtitle
        titleL.text = model.title
        
        /*
        if model.enter == true || model.select == true {
            bg.backgroundColor = .hex("#ffffff")
            titleL.textColor = .hex("#252525")
            subtitleL.textColor = .hex("#252525")
            arrow.isHidden = false
        }
        else {
            bg.backgroundColor = .hex("#565D6B")
            titleL.textColor = .hex("#ffffff")
            subtitleL.textColor = .hex("#ffffff")
            arrow.isHidden = true
        }
        */
        if model.enter == true {
            bg.backgroundColor = .hex("#ffffff")
            titleL.textColor = .hex("#252525")
            subtitleL.textColor = .hex("#252525")
            arrow.isHidden = false
        }
        else {
            bg.backgroundColor = .hex("#565D6B")
            titleL.textColor = .hex("#ffffff")
            subtitleL.textColor = .hex("#ffffff")
            arrow.isHidden = true
        }
        if myStyle == .link {
            if model.enter == true || model.select == true {
                icon.image = UIImage(named: model.selectIcon)
            }
            else{
                icon.image = UIImage(named: model.normalIcon)
            }
        }
        else{
            icon.image = UIImage()
        }
        
        
        if myStyle == .about {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            
            subtitleL.isHidden = false
            let subtitleLRight = (model.select == true || model.enter) ? -48.widthScale:-24.widthScale
            subtitleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(subtitleLRight)
            }
            
            icon.isHidden = true
            arrow.isHidden = !(model.select || model.enter)
            return
        }
        
        if myStyle == .help {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            subtitleL.isHidden = true
            icon.isHidden = true
            arrow.isHidden = !(model.select || model.enter)
            return
        }
        
        if myStyle == .recode {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            
            subtitleL.isHidden = false
            let subtitleLRight = model.select ? -48.widthScale:-24.widthScale
            subtitleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(subtitleLRight)
            }
            icon.isHidden = true
            arrow.isHidden = !(model.select || model.enter)
            return
        }
        
        if myStyle == .link {
            
            subtitleL.isHidden = true
            
            icon.isHidden = false
            
            icon.snp.remakeConstraints { make in
                make.width.height.equalTo(20.widthScale)
                make.left.equalToSuperview().offset(24.widthScale)
                make.centerY.equalToSuperview()
            }
            
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(icon.snp.right).offset(10.widthScale)
            }
            arrow.isHidden = !(model.select || model.enter)
            return
        }
        
        
        if myStyle == .accound {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            subtitleL.isHidden = true
            icon.isHidden = true
            arrow.isHidden = !(model.select || model.enter)
            return
        }
        
        
        if myStyle == .joycon {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            
            subtitleL.isHidden = false
            let subtitleLRight = (model.select == true || model.enter) ? -48.widthScale:-24.widthScale
            subtitleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(subtitleLRight)
            }
            
            icon.isHidden = true
            arrow.isHidden = !(model.select || model.enter)
            return
             
        }
       
        
        if myStyle == .joyconDetail {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            
            subtitleL.isHidden = false
            let subtitleLRight = (model.select == true || model.enter) ? -48.widthScale:-24.widthScale
            subtitleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(subtitleLRight)
            }
            
            icon.isHidden = true
            arrow.isHidden = !(model.select || model.enter)
            return
        }
        
        if myStyle == .recodeFPS {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            
            subtitleL.isHidden = false
            let subtitleLRight = (model.select == true || model.enter) ? -48.widthScale:-24.widthScale
            subtitleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(subtitleLRight)
            }
            
            icon.isHidden = false
            arrow.isHidden = true
            icon.snp.remakeConstraints { make in
                make.width.height.equalTo(20.widthScale)
                make.right.equalToSuperview().offset(-24.widthScale)
                make.centerY.equalToSuperview()
            }
            icon.image = model.select ? UIImage(named: "friend_add_select"):UIImage(named: "white_unselect")
            return
        }
        
        
        if myStyle == .recodeFormat {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            
            subtitleL.isHidden = false
            let subtitleLRight = (model.select == true || model.enter) ? -48.widthScale:-24.widthScale
            subtitleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(subtitleLRight)
            }
            
            icon.isHidden = false
            arrow.isHidden = true
            icon.snp.remakeConstraints { make in
                make.width.height.equalTo(20.widthScale)
                make.right.equalToSuperview().offset(-24.widthScale)
                make.centerY.equalToSuperview()
            }
            icon.image = model.select ? UIImage(named: "friend_add_select"):UIImage(named: "white_unselect")
            return
        }
        
        if myStyle == .recodeBitRate {
            titleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(24.widthScale)
            }
            
            subtitleL.isHidden = false
            let subtitleLRight = (model.select == true || model.enter) ? -48.widthScale:-24.widthScale
            subtitleL.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(subtitleLRight)
            }
            
            icon.isHidden = false
            arrow.isHidden = true
            icon.snp.remakeConstraints { make in
                make.width.height.equalTo(20.widthScale)
                make.right.equalToSuperview().offset(-24.widthScale)
                make.centerY.equalToSuperview()
            }
            icon.image = model.select ? UIImage(named: "friend_add_select"):UIImage(named: "white_unselect")
            return
        }
    }
    
    
    func clearAllSnp(){
        titleL.snp.removeConstraints()
        subtitleL.snp.removeConstraints()
        icon.snp.removeConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bg)
       
        bg.addSubview(titleL)
        bg.addSubview(subtitleL)
        bg.addSubview(arrow)
        arrow.image = UIImage(named: "black_arrow_left")
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.widthScale)
            make.width.height.equalTo(22.widthScale)
        }
        bg.addSubview(icon)
        
        bg.addTarget(self, action: #selector(touchEnter), for: .touchDown)
        bg.addTarget(self, action: #selector(touchLeave), for: .touchUpInside)
        bg.addTarget(self, action: #selector(touchLeave), for: .touchDragExit)
    }
    
    /*
     手指未松开，移动到下一个cell，马上松开，点击，会出现复选
     */
    
    @objc func touchEnter(){
        touchEnterHandler(self)
    }
    @objc func touchLeave(){
        touchLeaveHandler(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bg:UIButton = {
        let v = UIButton()
        v.backgroundColor = .hex("#565D6B")
        v.layer.cornerRadius = 8.widthScale
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var titleL:UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.textColor = .hex("#ffffff")
        l.font = font_16(weight: .semibold)
        return l
    }()
    
    lazy var subtitleL:UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        l.textColor = .hex("#cccccc")
        l.font = font_16(weight: .semibold)
        return l
    }()
    
    lazy var arrow:UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var icon:UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .clear
        return v
    }()
}
