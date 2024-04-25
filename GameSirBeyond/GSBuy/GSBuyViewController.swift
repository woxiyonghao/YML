//
//  GSBuyViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/1.
//

import UIKit
import SnapKit
class GSBuyViewController: UIViewController {

    open var onBuyHandler = {() in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .hex("#20242F")
        
        view.addSubview(icon)
        icon.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(titleL)
        titleL.snp.makeConstraints {
            $0.left.equalTo(self.view.snp.centerX)
            $0.bottom.equalTo(self.view.snp.centerY).offset(-20.widthScale)
            $0.right.equalToSuperview()
        }
        
       
        view.addSubview(subtitleL)
        subtitleL.snp.makeConstraints {
            $0.left.right.equalTo(self.titleL)
            $0.centerY.equalToSuperview()
        }
        
        view.addSubview(buyBtn)
        buyBtn.snp.makeConstraints {
            $0.top.equalTo(self.subtitleL.snp.bottom).offset(32.widthScale)
            $0.centerX.equalTo(self.titleL)
            $0.width.equalTo(286.widthScale)
            $0.height.equalTo(44.widthScale)
        }
        
        view.addSubview(logo)
        logo.snp.makeConstraints {
            $0.bottom.equalTo(self.titleL.snp.top).offset(-28.widthScale)
            $0.centerX.equalTo(self.titleL)
            $0.width.equalTo(154.widthScale)
            $0.height.equalTo(42.widthScale)
        }
    }
    
    lazy var logo:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.image = UIImage(named: "home_logo")
        return img
    }()
    
    
    lazy var icon:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .orange
        return img
    }()
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .center
            $0.font = font_28(weight: .semibold)
            $0.textColor = .hex("#ffffff")
            $0.text = "新一代游戏设备现在触手可及"
            $0.numberOfLines = 1
        }
        return label
    }()
    lazy var subtitleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .center
            $0.font = font_16(weight: .medium)
            $0.textColor = .hex("#ffffff")
            $0.text = "连接Backbone 以继续"
        }
        return label
    }()
    
    lazy var buyBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .hex("#1A9FFC")
            $0.layer.cornerRadius = 22.widthScale
            $0.layer.masksToBounds = true
            $0.setTitle("现在购买", for: .normal)
            $0.setTitleColor(.hex("#ffffff"), for: .normal)
            $0.titleLabel?.font = font_16(weight: .semibold)
            $0.setImage(UIImage(named: "buy"), for: .normal)
        }
        btn.addTarget(self, action: #selector(toBuyJoyCon), for: .touchUpInside)
        return btn
    }()
    
    @objc func toBuyJoyCon(){
        print("跳转H5商城")
        onBuyHandler()
    }
    
}
