//
//  GameBackKeyBtn.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/7.
//

import UIKit
import SnapKit
import Then
var AntiShakeTime = 0.25
class GameBackKeyBtn: UIView {
    
    public var icon:UIImageView!
    public var label:UILabel!
    public var btn:UIButton!
    
    public var backHandler = {() in
        
    }
    public var backEnterHandler = {() in
        
    }
    
    /// 是否需要动画
    public var anim = false{
        didSet{
            antiShake = anim
        }
    }
    
    private var antiShake = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        btn = UIButton()
        self.addSubview(btn)
        btn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        icon = UIImageView()
        icon.backgroundColor = .clear
        icon.image = UIImage(named: "ic-B")
        btn.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSizeMake(20, 20))
        }
        
        label = UILabel()
        label.text = "返回"
        label.textColor = .hex("#252525")
        label.font = font_12(weight: .regular)
        label.textAlignment = .right
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.right.equalToSuperview().offset(-12)
        }
        btn.addTarget(self, action: #selector(backBtnEnterClicked), for: .touchDown)
        btn.addTarget(self, action: #selector(backBtnDidClicked), for: .touchDragExit)
        btn.addTarget(self, action: #selector(backBtnDidClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc func backBtnDidClicked(){
        
        
        if anim == true {
            runAnim()
        }
        
        backHandler()
    }
    
    
    @objc func backBtnEnterClicked(){
        
        backEnterHandler()
    }
    
    open func runAnim(){
        isUserInteractionEnabled = false
        delay(interval: AntiShakeTime) {[weak self] in
            guard let `self` = self else { return }
            self.isUserInteractionEnabled = true
            self.layer.removeAllAnimations()
        }
        let keyAnimation = CAKeyframeAnimation.init(keyPath: "transform.scale")
        keyAnimation.duration = AntiShakeTime
        keyAnimation.values = [NSNumber(value: 0.8),NSNumber(value: 1.2),NSNumber(value: 1)]
        keyAnimation.calculationMode = .cubicPaced
        self.layer.add(keyAnimation, forKey: "keyAnimation")
    }
}
