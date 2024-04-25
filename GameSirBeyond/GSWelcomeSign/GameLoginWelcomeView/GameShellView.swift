//
//  GameShellView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/6.
//

import UIKit
import SnapKit
class GameShellView: UIView {

   
    init(){
        super.init(frame: .zero)
        
        addSubview(leftImg)
        leftImg.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        addSubview(titleL)
        titleL.snp.makeConstraints {
            $0.left.equalTo(self.snp.centerX).offset(60)
            $0.right.equalToSuperview().offset(-84.widthScale)
            $0.top.equalToSuperview().offset(100.widthScale)
        }
        addSubview(subtitleL)
        subtitleL.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.right.equalTo(titleL).offset(20.widthScale)
            $0.top.equalTo(titleL.snp.bottom).offset(12.widthScale)
        }
        
        addSubview(applyBtn)
        applyBtn.snp.makeConstraints {
            $0.left.equalTo(titleL).offset(8.widthScale)
            $0.right.equalTo(titleL).offset(-8.widthScale)
            $0.top.equalTo(subtitleL.snp.bottom).offset(24.widthScale)
            $0.height.equalTo(50.widthScale)
        }
        
        
        
        addSubview(backBtn)
        backBtn.snp.remakeConstraints {
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(76.widthScale)
            $0.height.equalTo(40.widthScale)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var leftImg:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .hex("#ffffff")
        return img
    }()
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_24(weight: .regular)
            $0.textColor = .hex("#ffffff")
            $0.text = "Backbone One 可与兼容\n外壳同时使用"
            $0.numberOfLines = 2
        }
        return label
    }()
    lazy var subtitleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#ffffff")
            $0.text = "包装盒内含可与外壳同事使用的适配器。您可\n以稍后在“入门指南”中查看移除说明和外壳兼\n容性。"
            $0.numberOfLines = 3
        }
        return label
    }()
    
    lazy var applyBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .hex("#ffffff")
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            
            let label = UILabel()
            label.text = "OK,明白了"
            label.font = font_14(weight: .medium)
            label.textColor = .hex("#252525")
            label.textAlignment = .center
            $0.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(20)
            }
            
            let icon = UIImageView()
            icon.backgroundColor = .clear
            icon.image = UIImage(named: "ic-A")
            $0.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20)
                make.right.equalTo(label.snp.left).offset(-8)
            }
        }
        btn.addTarget(self, action: #selector(enter), for: .touchDown)
        btn.addTarget(self, action: #selector(ok), for: .touchDragExit)
        btn.addTarget(self, action: #selector(ok), for: .touchUpInside)
        return btn
    }()
    
    @objc func ok(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
    }
    
    @objc func enter(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
    }
  
    lazy var backBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.label.textColor = .hex("#ffffff")
            $0.icon.image = UIImage(named: "ic-B-clear")
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            //$0.tag = 1
            $0.anim = true
        }
        return btn
    }()
    
}
