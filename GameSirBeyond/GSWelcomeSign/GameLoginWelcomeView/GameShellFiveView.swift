//
//  GameShellFiveView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/8.
//

import UIKit
import SnapKit
import Then
class GameShellFiveView: UIView {

    
     init(){
         super.init(frame: .zero)
         addSubview(icon)
         icon.snp.makeConstraints {
             $0.right.top.bottom.equalToSuperview()
             $0.width.equalToSuperview().multipliedBy(0.5)
         }
         
         addSubview(titleL)
         titleL.snp.makeConstraints {
             $0.left.equalToSuperview().offset(52.widthScale)
             $0.right.equalTo(self.snp.centerX).offset(-52.widthScale)
             $0.top.equalToSuperview().offset(150.widthScale)
         }
         
        
         addSubview(subtitleL)
         subtitleL.snp.makeConstraints {
             $0.left.equalTo(titleL)
             //$0.right.equalTo(self.snp.centerX).offset(0)
             $0.top.equalTo(titleL.snp.bottom).offset(24.widthScale)
         }
         
         addSubview(openL)
         openL.snp.makeConstraints {
             $0.left.equalTo(titleL)
             $0.top.equalTo(subtitleL.snp.bottom).offset(0)
         }
         
         addSubview(openBtn)
         openBtn.snp.makeConstraints {
             $0.left.equalTo(subtitleL.snp.right).offset(4.widthScale)
             $0.centerY.equalTo(subtitleL)
             $0.width.height.equalTo(28.widthScale)
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
     
     
     lazy var icon:UIImageView = {
         let img = UIImageView()
         img.backgroundColor = .orange
         return img
     }()
     lazy var titleL:UILabel = {
         let label = UILabel().then {
             $0.textAlignment = .left
             $0.font = font_24(weight: .semibold)
             $0.textColor = .hex("#ffffff")
             $0.text = "您准备好了！"
             $0.numberOfLines = 2
         }
         return label
     }()
     lazy var subtitleL:UILabel = {
         let label = UILabel().then {
             $0.textAlignment = .left
             $0.font = font_14(weight: .medium)
             $0.textColor = .hex("#ffffff")
             $0.text = "随时按 Backbone 按钮"
             $0.numberOfLines = 0
         }
         return label
     }()
    
    lazy var openL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .medium)
            $0.textColor = .hex("#ffffff")
            $0.text = "打开 Backbone"
            $0.numberOfLines = 0
        }
        return label
    }()
    
    lazy var openBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "ic-ORANGE"), for: .normal)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 14.widthScale
        btn.layer.masksToBounds = true
        return btn
    }()
    
     lazy var backBtn:GameBackKeyBtn = {
         let btn = GameBackKeyBtn().then {
             $0.backgroundColor = .clear
             $0.label.textColor = .hex("#ffffff")
             $0.icon.image = UIImage(named: "ic-B-clear")
             $0.btn.layer.cornerRadius = 20.widthScale
             $0.btn.layer.masksToBounds = true
             //$0.tag = 1
             $0.anim = false
         }
         return btn
     }()

}
