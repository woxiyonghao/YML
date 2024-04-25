//
//  GameShowItem.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/5.
//

import UIKit
import SnapKit
import KDCircularProgress
class GameShowItem: UIView {
    
    var state = false{
        didSet{
            stateIcon.image = state == false ? UIImage(named: "ic-state-normal") : UIImage(named: "ic-state-select")
        }
    }
    
    var progress:Double = 0 {
        didSet{
            guard isProgress == true else {return}
            //guard progressView.isAnimating() == false else {return}
            progressView.progress = progress
        }
    }
    
    var isProgress:Bool = false
    init(needProgress:Bool){
        super.init(frame: .zero)
        self.backgroundColor = .clear
        isProgress = needProgress
        
        addSubview(titleL)
        if needProgress {
            addSubview(progressView)
        }
        
        addSubview(icon)
        addSubview(titleR)
        addSubview(stateIcon)
        
        titleL.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
        }
        
        if needProgress {
            progressView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(titleL.snp.right).offset(4.widthScale)
                $0.width.height.equalTo(40.widthScale)
            }
            icon.snp.makeConstraints {
                $0.center.equalTo(progressView)
                $0.width.height.equalTo(22.widthScale)
            }
            titleR.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(progressView.snp.right).offset(4.widthScale)
            }
        }
       
        else {
            icon.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(titleL.snp.right).offset(9.widthScale)
                $0.width.height.equalTo(30.widthScale)
            }
            titleR.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(icon.snp.right).offset(9.widthScale)
            }
        }
       
        
       
        stateIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(22.widthScale)
        }
    }
    var progressView: KDCircularProgress! = {
        let progress = KDCircularProgress()
        progress.startAngle = -90                          // 开始位置
        progress.progressThickness = 0.35                  // 进度条的粗细
        progress.clockwise = true                         // 顺/逆时针
        progress.gradientRotateSpeed = 1                  // 彩灯闪烁进度
        progress.roundedCorners = true                    // 进度条头尾 圆 / 直
        progress.glowMode = .forward                      // 彩灯的方式
        progress.glowAmount = 0.0                         // 发光的强度
        progress.set(colors: .hex("#71F596"))// 设置进度条颜色
        progress.trackColor = .hex("#ffffff").withAlphaComponent(0.2) // 背景颜色
        progress.trackThickness = 0.4                    // 背景粗细
        return progress
    }()
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .white
        }
        return label
    }()
    
    lazy var icon:UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .clear
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    lazy var titleR:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .white
        }
        return label
    }()
    
    lazy var stateIcon:UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .clear
        i.image = UIImage(named: "ic-state-normal")
        return i
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
