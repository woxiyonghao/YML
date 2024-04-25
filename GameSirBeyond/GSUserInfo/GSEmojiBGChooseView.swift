//
//  GSEmojiBGChooseView.swift
//  GameSirBeyond
//
//  Created by lu on 2024/3/26.
//

import UIKit

class GSEmojiBGChooseView: UIView {

    var tfChangeHandler = {(str:String) in}
    let count:Int = 7
    
    let defineScale:CGFloat = 1
    let firstScale:CGFloat = 0.8
    let secondScale:CGFloat = 0.7
    let thirdScale:CGFloat = 0.5
    
    let defineBtnWH:CGFloat = 56
    let roundWH:CGFloat = 68
    
    open func prev(){// 上一个
        setNeedsLayout()
        btns.insert(btns.removeLast(), at: 0)
        colors.insert(colors.removeLast(), at: 0)
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
        let animation = CAKeyframeAnimation(keyPath:"transform.scale")
        animation.values = [NSNumber(value: 0),NSNumber(value: 1)]
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        btns[3].layer.add(animation, forKey: "transform.scale")
    }
    open func next(){// 下一个
        setNeedsLayout()
       
        btns.append(btns.removeFirst())
        colors.append(colors.removeFirst())
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        let animation = CAKeyframeAnimation(keyPath:"transform.scale")
        animation.values = [NSNumber(value: 0),NSNumber(value: 1)]
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        btns[3].layer.add(animation, forKey: "transform.scale")
    }
    
    private lazy var btns = [UIButton]()
    private lazy var frames = [CGRect]()
    
  
    var colors:[UIColor] = [
        .hex("#EE91A9"),
        .hex("#FEB54F"),
        .hex("#FCD655"),
        .hex("#666666"),
        .hex("#83E598"),
        .hex("#8DDCFB"),
        .hex("#A9C7F2"),
        .hex("#B4A6F0"),
        .hex("#EC817A"),
    ]
    
    func sortColors(color:UIColor){
        setNeedsLayout()
        colors.removeAll { tmp in
            return tmp.isEqual(color)
        }
        colors.insert(color, at: 3)
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        for i in 0..<count {
            let btn = UIButton()
            self.addSubview(btn)
            btns.append(btn)
            btn.layer.masksToBounds = true
        }
        
        addSubview(roundView)
        roundView.layer.cornerRadius = roundWH.widthScale * 0.5
        roundView.layer.masksToBounds = true
        roundView.layer.borderWidth = 3
        roundView.layer.borderColor = UIColor.white.cgColor
        roundView.backgroundColor = .clear
        
        roundView.addSubview(emojiL)
        
        
        creatFrames()
        
    }
    
    lazy var roundView = UIView()
    
    func creatFrames(){
        // 中间的frame
        let maxFrame = CGRectMake(self.width * 0.5 - defineBtnWH * 0.5, 
                                  self.height * 0.5 - defineBtnWH * 0.5,
                                  defineBtnWH,
                                  defineBtnWH)
        
        // 第一的frame 左
        let firstFrame_0 = CGRectMake(maxFrame.origin.x - 12.widthScale - defineBtnWH * firstScale,
                                      maxFrame.origin.y + (maxFrame.size.height - defineBtnWH * firstScale) * 0.5,
                                      defineBtnWH * firstScale,
                                      defineBtnWH * firstScale)
        
        // 第一的frame 右
        let firstFrame_1 = CGRectMake(CGRectGetMaxX(maxFrame) + 12.widthScale ,
                                      firstFrame_0.origin.y,
                                      defineBtnWH * firstScale,
                                      defineBtnWH * firstScale)
        
        // 第二的frame 左
        let secondFrame_0 = CGRectMake(firstFrame_0.origin.x - 12.widthScale - defineBtnWH * secondScale,
                                       firstFrame_0.origin.y + (firstScale - secondScale) * defineBtnWH * 0.5,
                                      defineBtnWH * secondScale,
                                      defineBtnWH * secondScale)
        
        // 第二的frame 右
        let secondFrame_1 = CGRectMake(CGRectGetMaxX(firstFrame_1) + 12.widthScale,
                                      secondFrame_0.origin.y,
                                      defineBtnWH * secondScale,
                                      defineBtnWH * secondScale)
        
        
        // 第三的frame 左
        let thirdFrame_0 = CGRectMake(secondFrame_0.origin.x - 12.widthScale - defineBtnWH * thirdScale,
                                      secondFrame_0.origin.y + (secondScale - thirdScale) * defineBtnWH * 0.5,
                                      defineBtnWH * thirdScale,
                                      defineBtnWH * thirdScale)
        
        // 第三的frame 右
        let thirdFrame_1 = CGRectMake(CGRectGetMaxX(secondFrame_1) + 12.widthScale,
                                      thirdFrame_0.origin.y,
                                      defineBtnWH * thirdScale,
                                      defineBtnWH * thirdScale)
        
        frames.append(thirdFrame_0)
        frames.append(secondFrame_0)
        frames.append(firstFrame_0)
        frames.append(maxFrame)
        frames.append(firstFrame_1)
        frames.append(secondFrame_1)
        frames.append(thirdFrame_1)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0..<btns.count{
            btns[i].frame = frames[i]
            btns[i].layer.cornerRadius = frames[i].width * 0.5
            btns[i].backgroundColor = colors[i]
        }
        roundView.frame = CGRectMake(frame.width*0.5-roundWH.widthScale*0.5, frame.height*0.5-roundWH.widthScale*0.5, roundWH.widthScale, roundWH.widthScale)
        emojiL.frame = roundView.bounds
    }
    
    
    lazy var emojiL:UITextField = {
        let l = UITextField()
        l.backgroundColor = .clear
        l.textAlignment = .center
        l.text = ""
        l.font = font_32(weight: .regular)
        l.returnKeyType = .done
        l.delegate = self
        return l
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension GSEmojiBGChooseView:UITextFieldDelegate,UIKeyInput{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.endEditing(true)
            return false
        }
        if string == "" {
            return true
        }
        let text = textField.text ?? ""
        let can = string.containsEmoji() && text.count < 1
        if can {
            tfChangeHandler(string)
        }
        return can
    }
    
    var hasText: Bool {
        return true
    }
    
    func insertText(_ text: String) {}
    
    func deleteBackward() { }
    
    override var textInputMode: UITextInputMode?{
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
