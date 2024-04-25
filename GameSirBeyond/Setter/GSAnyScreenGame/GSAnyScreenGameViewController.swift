//
//  GSAnyScreenGameViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/15.
//

import UIKit
import Then
import SnapKit
class GSAnyScreenGameViewController: UIViewController {
    
    var onPressing = false
    let btnW:CGFloat = 340.widthScale
    let btnH:CGFloat = 40.widthScale
    let btnSelectW:CGFloat = 340.widthScale + 8.widthScale * 2
    var lastBtn:GSAnyScreenGameBtn?
    var dismiss = {() in}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: CGSize(width: kWidth, height: kHeight),direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        let imageTop = UIImageView().then { [weak self] in
            guard let `self` = self else {return}
            view.addSubview($0)
            $0.backgroundColor = .orange
            $0.snp.makeConstraints { make in
                make.width.equalTo(234.widthScale)
                make.height.equalTo(166.widthScale)
                make.top.equalToSuperview().offset(60.widthScale)
                make.right.equalToSuperview().offset(-124.widthScale)
            }
        }
        
        _ = UIImageView().then { [weak self] in
            guard let `self` = self else {return}
            view.addSubview($0)
            $0.backgroundColor = .orange
            $0.snp.makeConstraints { make in
                make.width.equalTo(234.widthScale)
                make.height.equalTo(107.widthScale)
                make.top.equalTo(imageTop.snp.bottom).offset(18.widthScale)
                make.right.equalToSuperview().offset(-124.widthScale)
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
            $0.text = "在任何屏幕上进行游戏"
            $0.font = font_24(weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .white
            $0.sizeToFit()
            $0.frame = CGRectMake(44.widthScale, 40.widthScale, $0.width, $0.height)
        })
        
        scrsubtitleL = UILabel().then({ [weak self] in
            guard let `self` = self else {return}
            self.scr.addSubview($0)
            $0.numberOfLines = 3
            $0.width = btnW-40.widthScale
            $0.text = "您可以使用Lightning数据线将Bacakone与iPad\n等其他设备连接，以便游玩Xbox Cloud Gaming\n等平台上的游戏。"
            $0.font = font_14(weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .white
            $0.sizeToFit()
            $0.frame = CGRectMake(44.widthScale, CGRectGetMaxY(self.scrTitleL.frame) + 6.widthScale, $0.width,$0.height)
        })
        creatCells()
        
        let topBlur = UIView(frame: CGRectMake(0, 0, kWidth*0.5, GSSetterRightViewContentTop))
        view.addSubview(topBlur)
        topBlur.addBlurEffect(style: .dark, alpha: 0.1)
        
        let bottomBlur = UIView(frame: CGRectMake(0, kHeight - GSSetterRightViewContentBottom, kWidth*0.5, GSSetterRightViewContentBottom))
        view.addSubview(bottomBlur)
        bottomBlur.addBlurEffect(style: .dark, alpha: 0.1)
        
        regisNotisWithoutPressB()
    }
    
    var scr:UIScrollView!
    var scrTitleL:UILabel!
    var scrsubtitleL:UILabel!
    
    func creatCells(){
       
        var maxY:CGFloat = kHeight
        for i in 0..<datas.count {
            let y = (CGRectGetMaxY(scrsubtitleL.frame) + 12.widthScale) + (CGFloat(i) * (8.widthScale + btnH))
            let btn = GSAnyScreenGameBtn(frame: CGRectMake(44.widthScale, y, btnW, btnH))
            btn.tag = i + 10
            btn.model = datas[i]
            scr.addSubview(btn)
            cells.append(btn)
            btn.addTarget(self, action: #selector(btnEnterAction), for: .touchDown)
            btn.addTarget(self, action: #selector(btnLeaveAction), for: .touchUpInside)
            btn.addTarget(self, action: #selector(btnLeaveAction), for: .touchDragExit)
            if i == datas.count - 1 {
                if maxY < y + btnH + 40 {
                    maxY = y + btnH + 40
                }
            }
        }
        scr.contentSize = CGSizeMake(0, maxY)
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
    
    lazy var cells = [GSAnyScreenGameBtn]()
    lazy var datas = [
        GSSetterMenuOPModel(title: "iPad",normalIcon: "white_unselect",selectIcon: "friend_add_select",id: 0),
        GSSetterMenuOPModel(title: "Google Chrome",normalIcon: "white_unselect",selectIcon: "friend_add_select",id: 1),
        GSSetterMenuOPModel(title: "PC",normalIcon: "white_unselect",selectIcon: "friend_add_select",id: 2),
        GSSetterMenuOPModel(title: "Android",normalIcon: "white_unselect",selectIcon: "friend_add_select",id: 3),
        GSSetterMenuOPModel(title: "Mac",normalIcon: "white_unselect",selectIcon: "friend_add_select",id: 4                                                                       ),
    ]
    
    deinit {
        print("\(self.classForCoder)   ---- deinit")
    }
}

class GSAnyScreenGameBtn:UIButton {
    
    var titleL:UILabel!
    var icon:UIImageView!
    
    var model:GSSetterMenuOPModel!{
        didSet{
            titleL.text = model.title
            //print("title == \(model.title)  enter = \(model.enter) select = \(model.select)")
            if model.enter {
                icon.image = model.select ? UIImage(named: model.selectIcon):UIImage(named: model.normalIcon)
                backgroundColor = .hex("#ffffff")
                titleL.textColor = .hex("#252525")
            }
            else {
                icon.image = model.select ? UIImage(named: model.selectIcon):UIImage(named: model.normalIcon)
                backgroundColor = .hex("#565D6B")
                titleL.textColor = .hex("#ffffff")
            }
        }
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        
        layer.cornerRadius = 8.widthScale
        layer.masksToBounds = true
        
        titleL = UILabel()
        titleL.text = ""
        titleL.textColor = .hex("#ffffff")
        titleL.textAlignment = .left
        titleL.font = font_16(weight: .regular)
        addSubview(titleL)
   
        icon = UIImageView()
        icon.image = UIImage(named: "white_unselect")
        addSubview(icon)
        
        titleL.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24.widthScale)
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(22.widthScale)
            make.right.equalToSuperview().offset(-24.widthScale)
            make.centerY.equalToSuperview()
        }
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// 关于手柄
extension GSAnyScreenGameViewController {
    
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
