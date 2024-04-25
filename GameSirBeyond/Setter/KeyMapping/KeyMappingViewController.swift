//
//  KeyMappingViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/15.
//

import UIKit
import Then
import RxSwift
class KeyMappingViewController: UIViewController {

    var dismiss = {() in}
    fileprivate var size = CGSize(width: 0, height: 0)
    fileprivate let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: size,direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        view.layer.cornerRadius = 16.widthScale
        view.layer.masksToBounds = true
        
        let backBtn = UIButton().then { [weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(16.widthScale)
                make.width.height.equalTo(24.widthScale)
            }
            $0.backgroundColor = .clear
            $0.setBackgroundImage(UIImage(named: "white_close"), for: .normal)
            $0.rx.tap.subscribe {[weak self] e in
                print("back")
                self?.dismiss()
            }.disposed(by: self.disposeBag)
        }
        
        let titleL = UILabel().then { [weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.text = "更改按键映射"
            $0.textColor = .hex("#ffffff")
            $0.textAlignment = .left
            $0.font = font_24(weight: .semibold)
            $0.snp.makeConstraints { make in
                make.left.equalTo(backBtn.snp.right)
                make.top.equalTo(backBtn.snp.bottom).offset(38.widthScale)
            }
        }
        
        let subtitleL = UILabel().then { [weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.text = "插入手机后，前往“设置”>“通\n用”>“游戏手柄”来重新映射按钮。"
            $0.textColor = .hex("#ffffff")
            $0.numberOfLines = 2
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleL)
                make.top.equalTo(titleL.snp.bottom).offset(14.widthScale)
            }
        }
        
        let okBtn = UIButton().then { [weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleL)
                make.top.equalTo(subtitleL.snp.bottom).offset(40.widthScale)
                make.height.equalTo(44.widthScale)
                make.width.equalTo(240.widthScale)
            }
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.setTitle("OK，明白了", for: .normal)
            $0.setTitleColor(.hex("#000000"), for: .normal)
            $0.titleLabel?.font = font_14(weight: .bold)
            $0.rx.tap.subscribe {[weak self] e in
                print("ok 明白了")
                self?.dismiss()
            }.disposed(by: self.disposeBag)
        }
        
        let image = UIImageView().then { [weak self] in
            guard let `self` = self else {return}
            $0.backgroundColor = .clear
            $0.image = UIImage(named: "key_mapping_tip")
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(backBtn.snp.bottom)
                make.width.equalTo(154.widthScale)
                make.height.equalTo(250.widthScale)
                make.right.equalToSuperview().offset(-90.widthScale)
            }
        }
    }
    

    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(self.classForCoder)   ---unit")
    }
}
