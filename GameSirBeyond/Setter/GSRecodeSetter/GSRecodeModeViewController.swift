//
//  GSRecodeModeViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/16.
//

import UIKit
import Then
import SnapKit
class GSRecodeModeViewController: UIViewController {
    var dismiss = {() in}
    var onPressing = false
    let btnW:CGFloat = 340.widthScale
    let btnH:CGFloat = 72.widthScale
    let btnSelectW:CGFloat = 340.widthScale + 8.widthScale * 2
    fileprivate var size = CGSizeMake(0, 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: size,direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        
        let imageTop = UIImageView().then { [weak self] in
            guard let `self` = self else {return}
            view.addSubview($0)
            $0.backgroundColor = .orange
            $0.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.5)
                make.bottom.equalTo(0)
                make.top.equalToSuperview().offset(0)
                make.right.equalToSuperview().offset(0)
            }
        }
        
        scr = UIScrollView().then({[weak self] in
            guard let `self` = self else {return}
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            self.view.addSubview($0)
            $0.frame = CGRectMake(0, 0, kWidth * 0.5, kHeight)
            $0.contentInsetAdjustmentBehavior = .never
        })
        
        scrTitleL = UILabel().then({ [weak self] in
            guard let `self` = self else {return}
            self.scr.addSubview($0)
            $0.text = "选择您的录制模式"
            $0.font = font_24(weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .white
            $0.sizeToFit()
            $0.frame = CGRectMake(44.widthScale, 84.widthScale, $0.width, $0.height)
        })
        
        scrIcon = UIImageView().then { [weak self] in
            guard let `self` = self else {return}
            self.scr.addSubview($0)
            $0.backgroundColor = .clear
            $0.image = UIImage(named: "green_guard")
            $0.frame = CGRectMake(self.scrTitleL.x, CGRectGetMaxY(self.scrTitleL.frame) + 20.widthScale, 22.widthScale, 22.widthScale)
        }
        
        scrSubtitleL = UILabel().then({ [weak self] in
            guard let `self` = self else {return}
            self.scr.addSubview($0)
            $0.numberOfLines = 0
            $0.text = "您可以稍后再设置中更改此选项。您可以决定是否\n与朋友分享此内容经典"
            $0.font = font_14(weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .white
            $0.frame = CGRectMake(CGRectGetMaxX(self.scrIcon.frame) + 6.widthScale, self.scrIcon.y, self.scr.width - (CGRectGetMaxX(self.scrIcon.frame) + 6.widthScale) - 0.widthScale,36.widthScale)
        })
        
        creatCells()
        
        regisNotisWithoutPressB()
    }
    func creatCells(){
        for i in 0..<datas.count {
            let y = (CGRectGetMaxY(scrSubtitleL.frame) + 12.widthScale) + (CGFloat(i) * (8.widthScale + btnH))
            let btn = GSRecodeModeBtn(frame: CGRectMake(44.widthScale, y, btnW, btnH))
            btn.tag = i + 10
            btn.model = datas[i]
            scr.addSubview(btn)
            cells.append(btn)
            btn.addTarget(self, action: #selector(btnEnterAction), for: .touchDown)
            btn.addTarget(self, action: #selector(btnLeaveAction), for: .touchUpInside)
            btn.addTarget(self, action: #selector(btnLeaveAction), for: .touchDragExit)
        }
    }
    @objc func btnEnterAction(btn:GSAnyScreenGameBtn){
        cells.forEach {
            let model = $0.model!
            model.enter = $0.tag == btn.tag
            $0.model = model
            let this = $0
            UIView.animate(withDuration: 0.25) {
                this.x = 44.widthScale
                this.width = self.btnW
            }
        }
    }
    
    @objc func btnLeaveAction(btn:GSAnyScreenGameBtn){
        cells.forEach {
            let model = $0.model!
            model.enter = $0.tag == btn.tag
            model.select = $0.tag == btn.tag ? !model.select:false
            $0.model = model
            let this = $0
            UIView.animate(withDuration: 0.25) {
                this.x = this.model.select ? 44.widthScale - 8.widthScale : 44.widthScale
                this.width = this.model.select ? self.btnSelectW : self.btnW
            }
        }
    }
    var scr:UIScrollView!
    var scrTitleL:UILabel!
    var scrIcon:UIImageView!
    var scrSubtitleL:UILabel!
    
    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var cells = [GSAnyScreenGameBtn]()
    lazy var datas = [
        GSSetterMenuOPModel(title: "打开 PS App",normalIcon: "white_unselect",selectIcon: "friend_add_select",id: 0),
        GSSetterMenuOPModel(title: "智能录制 \n(测试版)",subtitle: "长按录制按钮保存最后15秒\n画面",normalIcon: "white_unselect",selectIcon: "friend_add_select",id: 1),
    ]
    
    deinit {
        print("\(self.classForCoder)  ----unit")
        NotificationCenter.default.removeObserver(self)
    }
}


class GSRecodeModeBtn:GSAnyScreenGameBtn{
    
    var subTitleL:UILabel!
    override var model:GSSetterMenuOPModel!{
        didSet{
            titleL.text = model.title
            subTitleL.text = model.subtitle
            if model.enter {
                icon.image = model.select ? UIImage(named: model.selectIcon):UIImage(named: model.normalIcon)
                backgroundColor = .hex("#ffffff")
                titleL.textColor = .hex("#252525")
                subTitleL.textColor = .hex("#252525")
            }
            else {
                icon.image = model.select ? UIImage(named: model.selectIcon):UIImage(named: model.normalIcon)
                backgroundColor = .hex("#565D6B")
                titleL.textColor = .hex("#ffffff")
                subTitleL.textColor = .hex("#cccccc")
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleL.numberOfLines = 2
        
        subTitleL = UILabel()
        subTitleL.text = ""
        subTitleL.textColor = .hex("#CCCCCC")
        subTitleL.textAlignment = .right
        subTitleL.font = font_14(weight: .regular)
        subTitleL.numberOfLines = 2
        addSubview(subTitleL)
        subTitleL.snp.makeConstraints { make in
            make.right.equalTo(icon.snp.left).offset(-6.widthScale)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 关于手柄
extension GSRecodeModeViewController {
    
    public func unitNotis(){
        NotificationCenter.default.removeObserver(self)
    }
 
    public func regisNotisWithoutPressB(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue),
                                               object: nil)
        
     
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressAOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue),
                                               object: nil)
   
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressUp),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressDown),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue),
                                               object: nil)
        
      
    }

    @objc func onPressingA(){
        onPressing = true
        // + 10
        let index = datas.firstIndex(where: {return $0.enter})
        if index == nil {
            cells.forEach {
                let model = $0.model!
                model.enter = $0.tag ==  10
                $0.model = model
                let this = $0
                UIView.animate(withDuration: 0.25) {
                    this.x = 44.widthScale
                    this.width = self.btnW
                }
            }
            return
        }
        
       
        
        cells.forEach {
            let model = $0.model!
            model.enter = $0.tag == index! + 10
            $0.model = model
            let this = $0
            UIView.animate(withDuration: 0.25) {
                this.x = 44.widthScale
                this.width = self.btnW
            }
        }
       
    }
 
    @objc func pressAOut(){
        onPressing = false
     
        // + 10
        let index = datas.firstIndex(where: {return $0.enter})
        if index == nil { return }
        if index! > datas.count - 1 { return }
        
        /// 是否有选择，没有则选中
        let select = datas.firstIndex(where: {return $0.select})
        if select == nil{
            cells.forEach {
                let model = $0.model!
                model.enter = $0.tag == index! + 10
                model.select = $0.tag == index! + 10
                $0.model = model
                let this = $0
                UIView.animate(withDuration: 0.25) {
                    this.x = this.model.enter ? 44.widthScale-8.widthScale:44.widthScale
                    this.width = this.model.enter ? self.btnSelectW:self.btnW
                }
            }
            return
        }
        
        /// 是否选中的是同一个
        if index! == select! {
            cells.forEach {
                let model = $0.model!
                model.enter = $0.tag == index! + 10
                model.select = $0.tag == index! + 10 ? !model.select:false
                $0.model = model
                let this = $0
                UIView.animate(withDuration: 0.25) {
                    this.x = this.model.enter ? 44.widthScale-8.widthScale:44.widthScale
                    this.width = this.model.enter ? self.btnSelectW:self.btnW
                }
            }
        }
        else { // 不是同一个btn选中
            cells.forEach {
                let model = $0.model!
                model.enter = $0.tag == index! + 10
                model.select = $0.tag == index! + 10
                $0.model = model
                let this = $0
                UIView.animate(withDuration: 0.25) {
                    this.x = this.model.enter ? 44.widthScale-8.widthScale:44.widthScale
                    this.width = this.model.enter ? self.btnSelectW:self.btnW
                }
            }
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        let index = datas.firstIndex(where: {return $0.enter})
        if index == nil { return }
        if index! == 0 { return }
        let prev = index! - 1 + 10
        cells.forEach {
            let model = $0.model!
            model.enter = $0.tag == prev
            $0.model = model
            let this = $0
            UIView.animate(withDuration: 0.25) {
                this.x = this.model.enter ? 44.widthScale-8.widthScale:44.widthScale
                this.width = this.model.enter ? self.btnSelectW:self.btnW
            }
        }
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        let index = datas.firstIndex(where: {return $0.enter})
        if index == nil { // 首次进入，按下 down
            cells.forEach {
                let model = $0.model!
                model.enter = $0.tag == 10
                $0.model = model
                let this = $0
                UIView.animate(withDuration: 0.25) {
                    this.x = this.model.enter ? 44.widthScale-8.widthScale:44.widthScale
                    this.width = this.model.enter ? self.btnSelectW:self.btnW
                }
            }
            return
        }
        if index! == datas.count - 1 { return }
        let next = index! + 1 + 10
        cells.forEach {
            let model = $0.model!
            model.enter = $0.tag == next
            $0.model = model
            let this = $0
            UIView.animate(withDuration: 0.25) {
                this.x = this.model.enter ? 44.widthScale-8.widthScale:44.widthScale
                this.width = this.model.enter ? self.btnSelectW:self.btnW
            }
        }
    }
    
}
