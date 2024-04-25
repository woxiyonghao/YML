//
//  GameEditUserInfoView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/7.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
class GameEditUserInfoView: UIView {
    
    var onFcousIndex:Int = -1{
        didSet{
            setNeedsLayout()
            onFcousIndex == 0 ? showEmojiChooseView():dismissEmojiChooseView()
            if onFcousIndex == 1 {
                secondTF.inputTF.becomeFirstResponder()
            }
            else{
                secondTF.inputTF.endEditing(true)
            }
            if onFcousIndex == 2 {
                thirdTF.inputTV.becomeFirstResponder()
            }
            else{
                thirdTF.inputTV.endEditing(true)
                
            }
            saveBtn.setTitleColor(onFcousIndex == 3 ? .hex("#252525"):.hex("#CCCCCC"), for: .normal)
            saveBtn.backgroundColor = onFcousIndex == 3 ? .hex("#ffffff"):.hex("#3D3D3D")
            
            if onFcousIndex == 3 {
                saveBtn.snp.remakeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.left.equalToSuperview().offset(0)
                    make.width.equalTo(tabW)
                }
            }
            else{
                saveBtn.snp.remakeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.left.equalToSuperview().offset(16.widthScale)
                    make.width.equalTo(tabW - 32.widthScale)
                }
            }
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        }
    }
    
    var firstTxt:String = getUserInfo()["nicname"] as? String ?? ""
    var secondTxt:String  = getUserInfo()["username"] as? String ?? ""
    var thirdTxt:String = getUserInfo()["bio"] as? String ?? ""
    var disposeBag =  DisposeBag() //全局变量
    let tabW:CGFloat =  284.widthScale
    var inputTFDefineH:CGFloat = 0
    init(){
        super.init(frame: .zero)
        
        addSubview(scr)
        scr.addSubview(tabHeader)
        scr.addSubview(firstTF)
        scr.addSubview(secondTF)
        scr.addSubview(thirdTF)
        scr.addSubview(tabFooter)
        
        /// 名字不能改
        firstTF.inputTF.isUserInteractionEnabled = false
        let signName = getNickname()
        firstTF.inputTF.text = signName
        //TODO: 获取登录的用户名【apple ， google】
        firstTF.inputTF.rx.text.orEmpty.subscribe(onNext: {[weak self] in
            guard let `self` = self else { return  }
            print("inputTF 您输入的值是:\($0)")
            self.firstTxt = $0
        }).disposed(by: disposeBag)
        
        secondTF.topL.text = "用户名"
        //let nicname = UserDefaultWrapper<String?>(key: UserDefaultKeys.ifNeedInputNicname)
        secondTF.inputTF.text = getUsername()
        secondTF.inputTF.rx.text.orEmpty.subscribe(onNext: {_ in
           
        }).disposed(by: disposeBag)
        
        // 去除所有的\n
        secondTF.inputTF.rx.controlEvent([.editingDidEnd]).subscribe { [weak self] _ in
            guard let `self` = self  else {return}
            self.secondTF.inputTF.text = self.secondTF.inputTF.text?.replacingOccurrences(of: "\n", with: "")
            self.secondTxt = self.secondTF.inputTF.text ?? ""
        }.disposed(by: disposeBag)
        
        thirdTF.topL.text = "关于您"
        if let bio = getUserInfo()["bio"] as? String {
            thirdTF.inputTV.text = bio 
        }
        thirdTF.inputTV.rx.text.orEmpty.subscribe(onNext: {[weak self] in
            guard let `self` = self else { return  }
            print("编辑中")
            
            // 去除所有的\n
            if $0.last == "\n" {
                self.thirdTF.inputTV.endEditing(true)
                self.thirdTF.inputTV.text = $0.replacingOccurrences(of: "\n", with: "")
                self.thirdTxt = self.thirdTF.inputTV.text
                return
            }
            
            if $0.count > 100 {
                let selectedRange = self.thirdTF.inputTV.markedTextRange
                //没有在拼写状态再判断
                if selectedRange == nil {
                    //通过字符串截取实现限制100字符长度
                    self.thirdTF.inputTV.text = ($0 as NSString).substring(to: 100)
                }
            }
            // 预设textView的大小，宽度设为固定宽度，高度设为CGFloat的最大值
            let presetSize = CGSize(width: self.thirdTF.inputTV.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            // 重新计算textView的大小
            let newSize =  self.thirdTF.inputTV.sizeThatFits(presetSize)
            let tfFrame = CGRectMake(self.thirdTF.inputTV.frame.origin.x, self.thirdTF.inputTV.frame.origin.y, self.thirdTF.inputTV.frame.width, newSize.height)
            if tfFrame.height > self.inputTFDefineH {
                let h = tfFrame.height - self.thirdTF.inputTV.frame.height
                self.thirdTF.frame = CGRectMake(self.thirdTF.frame.origin.x, self.thirdTF.frame.origin.y, self.thirdTF.frame.width, self.thirdTF.frame.height + h)
                self.tabFooter.frame = CGRectMake(0, CGRectGetMaxY(thirdTF.frame) + 20.widthScale, tabW, 42.widthScale)
            }
            else{
                self.thirdTF.frame = CGRectMake((kWidth - tabW) * 0.5, CGRectGetMaxY(secondTF.frame), tabW, 75.widthScale)
                self.tabFooter.frame = CGRectMake((kWidth - tabW) * 0.5, CGRectGetMaxY(thirdTF.frame) + 20.widthScale, tabW, 42.widthScale)
            }
            self.thirdTF.limitL.text = "\($0.count)/100"
            self.scrSetContentSize()
        }).disposed(by: disposeBag)
        
        scrSetContentSize()
    }
    
    func scrSetContentSize(){
        var maxY = CGRectGetMaxY(tabFooter.frame) + 40.widthScale
        if maxY < kHeight {
            maxY = kHeight
        }
        scr.contentSize = CGSize(width: 0, height: maxY)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        scr.frame = CGRectMake(0, 0, self.width == 0 ? 0:kWidth, self.frame.height)
        
        tabHeader.frame = CGRectMake(0, 0, kWidth, 102.widthScale - 16.widthScale)
        iconBg.frame = CGRectMake(tabHeader.width * 0.5 - 56.widthScale * 0.5, 24.widthScale, 56.widthScale, 56.widthScale)
        emojiL.frame = iconBg.bounds
        
        
        firstTF.frame = CGRectMake((kWidth - tabW) * 0.5, CGRectGetMaxY(tabHeader.frame), tabW, 75.widthScale)
        secondTF.frame = CGRectMake((kWidth - tabW) * 0.5, CGRectGetMaxY(firstTF.frame), tabW, 75.widthScale)
        thirdTF.frame = CGRectMake((kWidth - tabW) * 0.5, CGRectGetMaxY(secondTF.frame), tabW, 75.widthScale)
        tabFooter.frame = CGRectMake((kWidth - tabW) * 0.5, CGRectGetMaxY(thirdTF.frame) + 20.widthScale, tabW, 42.widthScale)
        
        inputTFDefineH = thirdTF.inputTV.frame.height
    }
    
    lazy var scr:UIScrollView = {
        let s = UIScrollView()
        s.showsHorizontalScrollIndicator = false
        s.showsVerticalScrollIndicator = false
        return s
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tabHeader:UIView = {
        // 202 - 16
        let view = UIView()
        view.backgroundColor = .clear
        
        view.addSubview(iconBg)
        iconBg.layer.cornerRadius = 28.widthScale
        iconBg.layer.masksToBounds = true
        iconBg.addSubview(emojiL)
        
        emojiChooseView = GSEmojiBGChooseView(frame: CGRectMake(0, 0, kWidth, 102.widthScale - 16.widthScale))
        emojiChooseView.sortColors(color: iconBg.backgroundColor!)
        emojiChooseView.alpha = 0
        emojiChooseView.emojiL.text = emojiL.text
        view.addSubview(emojiChooseView)
        emojiChooseView.tfChangeHandler = {[weak self](str:String) in
            guard let `self` = self else {return}
            self.emojiL.text = str
        }
        return view
    }()
    
    var emojiChooseView:GSEmojiBGChooseView!
    
    lazy var firstTF:GameEditWithInputField = {
        let tf = GameEditWithInputField()
        tf.backgroundColor = .clear
        return tf
    }()
    
    lazy var secondTF:GameEditWithInputField = {
        let tf = GameEditWithInputField()
        tf.backgroundColor = .clear
        return tf
    }()
    
    lazy var thirdTF:GameEditWithInputView = {
        let tf = GameEditWithInputView()
        tf.backgroundColor = .clear
        return tf
    }()
    
    lazy var tabFooter:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16.widthScale)
            make.width.equalTo(tabW - 32.widthScale)
        }
        return view
    }()
    
    lazy var saveBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("保存设置", for: .normal)
        btn.setTitleColor(.hex("#CCCCCC"), for: .normal)
        btn.titleLabel?.font = font_14(weight: .bold)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.backgroundColor = .hex("#3D3D3D")
        btn.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func saveBtnAction(){
        if onFcousIndex == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
        }
        else{
            onFcousIndex = 3
        }
    }
    
    lazy var iconBg:UIView = {
        let view = UIView()
        var emojiColro = UserDefaultWrapper<String?>(key: UserDefaultKeys.saveEmojiColor)
        if emojiColro.wrappedValue == nil {
            emojiColro.wrappedValue = "#ADED5C"
        }
        view.backgroundColor = .hex(emojiColro.wrappedValue!)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconBgAction)))
        return view
    }()
    @objc open func iconBgAction(){
        onFcousIndex = 0
    }
    @objc open func showEmojiChooseView(){
        UIView.animate(withDuration: 0.15) {
            self.iconBg.alpha = 0
            self.emojiL.alpha = 0
            self.emojiChooseView.alpha = 1
        }
        emojiChooseView.emojiL.becomeFirstResponder()
    }
    
    @objc open func dismissEmojiChooseView(){
        UIView.animate(withDuration: 0.15) {
            self.iconBg.alpha = 1
            self.emojiL.alpha = 1
            self.emojiChooseView.alpha = 0
        }
        emojiChooseView.emojiL.endEditing(true)
    }
    
    lazy var emojiL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .center
        l.text = getUserEmojiString()
        l.font = font_44(weight: .regular)
        return l
    }()
}

class GameEditWithInputField :UIView{
    init(){
        super.init(frame:.zero)
        addSubview(topL)
        addSubview(line)
        addSubview(inputTF)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topL.frame = CGRectMake(0, 0, self.frame.width, 16.widthScale)
        line.frame = CGRectMake(0, self.frame.height - 1.widthScale - 16.widthScale, self.frame.width, 1.widthScale)
        inputTF.frame = CGRectMake(0, CGRectGetMaxY(topL.frame), self.frame.width, self.frame.height - CGRectGetMaxY(topL.frame) - 1.widthScale - 8.widthScale - 16.widthScale)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .left
        l.text = "名称"
        l.textColor = .hex("#999999")
        l.font = font_14(weight: .medium)
        return l
    }()
    
    
    lazy var line:UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#ffffff")
        return view
    }()
    
    lazy var inputTF:UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.textAlignment = .left
        tf.textColor = .hex("#ffffff")
        tf.font = font_16(weight: .semibold)
        tf.returnKeyType = .done
        return tf
    }()
}


class GameEditWithInputView :UIView{
    init(){
        super.init(frame:.zero)
        addSubview(topL)
        addSubview(line)
        addSubview(inputTV)
        addSubview(limitL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topL.frame = CGRectMake(0, 0, self.frame.width, 16.widthScale)
        line.frame = CGRectMake(0, self.frame.height - 1.widthScale - 16.widthScale, self.frame.width, 1.widthScale)
        inputTV.frame = CGRectMake(0, CGRectGetMaxY(topL.frame), self.frame.width, self.frame.height - CGRectGetMaxY(topL.frame) - 1.widthScale - 8.widthScale - 16.widthScale)
        limitL.frame = CGRectMake(0, self.frame.height-15.widthScale, self.frame.width, 15.widthScale)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .left
        l.text = "名称"
        l.textColor = .hex("#999999")
        l.font = font_14(weight: .medium)
        return l
    }()
    
    
    lazy var line:UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#ffffff")
        return view
    }()
    
    lazy var inputTV:UITextView = {
        let tf = UITextView()
        tf.backgroundColor = .clear
        tf.textAlignment = .left
        tf.textColor = .hex("#ffffff")
        tf.font = font_16(weight: .semibold)
        tf.returnKeyType = .done
        return tf
    }()
    
    lazy var limitL:UILabel = {
        let l = UILabel()
        l.text = "0/100"
        l.textAlignment = .left
        l.font = font_14(weight: .regular)
        l.textColor = .hex("#999999")
        return l
    }()
}
