//
//  TestKeyView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/10/25.
//

import UIKit

// TODO: 把所有页面的中粗体Semibold改为中黑体Medium
class TestKeyView: UIView {

    @IBOutlet weak var backButton1: AnimatedButton!
    
    @IBOutlet weak var l1PressedView: UIImageView!
    @IBOutlet weak var l2PressedView: UIImageView!
    @IBOutlet weak var l2AnimatedView: TriggerAnimatedView!
    
    @IBOutlet weak var r1PressedView: UIImageView!
    @IBOutlet weak var r2PressedView: UIImageView!
    @IBOutlet weak var r2AnimatedView: TriggerAnimatedView!
    
    @IBOutlet weak var leftJoystickBgView: UIImageView!
    @IBOutlet weak var l3View: UIImageView!
    @IBOutlet weak var rightJoystickBgView: UIImageView!
    @IBOutlet weak var r3View: UIImageView!
    
    @IBOutlet weak var upPressedView: UIImageView!
    @IBOutlet weak var downPressedView: UIImageView!
    @IBOutlet weak var leftPressedView: UIImageView!
    @IBOutlet weak var rightPressedView: UIImageView!
    
    @IBOutlet weak var aPressedView: UIImageView!
    @IBOutlet weak var bPressedView: UIImageView!
    @IBOutlet weak var xPressedView: UIImageView!
    @IBOutlet weak var yPressedView: UIImageView!
    
    @IBOutlet weak var homePressedView: UIImageView!
    @IBOutlet weak var optionsPressedView: UIImageView!
    @IBOutlet weak var menuPressedView: UIImageView!
    @IBOutlet weak var capturePressedView: UIImageView!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    var readQuickTriggerTimer: Timer? = nil
    
    override var isHidden: Bool {
        didSet {
            if isHidden == false {
                isDisplayingControllerTestingView = true
            }
            else {
                isDisplayingControllerTestingView = false
            }
        }
    }
    
    override func removeFromSuperview() {
        // 重新让AppDelegate监听手柄按键
        eggshellAppDelegate().unobserveGamepadKey()
        eggshellAppDelegate().observeGamepadKey()
        
        NotificationCenter.default.removeObserver(self)
        isDisplayingControllerTestingView = false
        readQuickTriggerTimer?.invalidate()
        readQuickTriggerTimer = nil
        
        super.removeFromSuperview()
    }
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("TestKeyView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        // 截图键、Home的点击事件通过接收命令来获取。注释原因：不支持测试这2个按键 2023年11月21日10:33:23
//        NotificationCenter.default.addObserver(self, selector: #selector(receivePressCaptureKey(notification:)), name: NSNotification.Name("DidClickGamepadCaptureKeyNotification"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(receivePressHomeKey(notification:)), name: NSNotification.Name("DidClickGamepadHomeKeyNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quitCurrentView), name: Notification.Name("NeedToQuitMFiControllerPage"), object: nil)
        
        let matbString = NSMutableAttributedString(contents: [i18n(string: "Test key alert part 1"), UIImage(named: "m1c_capture") as Any, i18n(string: "Test key alert part 2"), UIImage(named: "m1c_home") as Any, i18n(string: "Test key alert part 3")], imageSize: CGSize(width: 20, height: 20), imageY: -5)
        alertLabel.attributedText = matbString
        
        backButton1.tapAction = {
            self.btnActionBack()
        }
        
        isDisplayingControllerTestingView = true
        
        /* 读取快速扳机开关，根据开关情况，决定扳机键的显示效果
         * 如果开：隐藏动画TriggerAnimatedView，显示selected图
         * 如果开：显示动画TriggerAnimatedView，隐藏selected图
         */
        
        l2AnimatedView.imageName = "m1c_l2_selected"
        l2AnimatedView.destination = .upToDown
        r2AnimatedView.imageName = "m1c_r2_selected"
        r2AnimatedView.destination = .upToDown
        
        observeQuickTriggerNotification()
        readQuickTrigger()
        readQuickTriggerTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.readQuickTrigger()
        }
        
        observeControllerKey()
    }
    
    var isQuickLeftTrigger = false
    var isQuickRightTrigger = false
    
    func observeQuickTriggerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didGetLeftQuickTrigger(notification:)), name: Notification.Name("DidGetLeftQuickTriggerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetRightQuickTrigger(notification:)), name: Notification.Name("DidGetRightQuickTriggerNotification"), object: nil)
    }
    
    // MARK: 读取快速扳机数据
    func readQuickTrigger() {
        eggshellAppDelegate().writeCommandReadQuickTrigger(isLeft: true)
        delay(interval: 0.1) {
            eggshellAppDelegate().writeCommandReadQuickTrigger(isLeft: false)
        }
    }
    
    @objc func didGetLeftQuickTrigger(notification: Notification) {
        isQuickLeftTrigger = notification.object as! Bool
    }
    
    @objc func didGetRightQuickTrigger(notification: Notification) {
        isQuickRightTrigger = notification.object as! Bool
    }
    
    func btnActionBack() {
        removeFromSuperview()
    }
    
    @objc func quitCurrentView() {
        backButton1.sendActions(for: .touchUpInside)
    }
    
    @objc func receivePressCaptureKey(notification: Notification) {
//        MainThread {
//            self.capturePressedView.isHidden = false
//            delay(interval: 0.1) {// 主动
//                self.capturePressedView.isHidden = true
//            }
//        }
    }
    
    @objc func receivePressHomeKey(notification: Notification) {
//        MainThread {
//            self.homePressedView.isHidden = false
//            delay(interval: 0.1) {
//                self.homePressedView.isHidden = true
//            }
//        }
    }
    
    private var joystickRadius = 11.0// 从xib获取
    // MARK: 监听手柄按键
    func observeControllerKey() {
        
        GSGameControllerManager.shared().keyAPressed = { pressed in
            self.aPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyBPressed = { pressed in
            self.bPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyXPressed = { pressed in
            self.xPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyYPressed = { pressed in
            self.yPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyUpPressed = { pressed in
            self.upPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyDownPressed = { pressed in
            self.downPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyLeftPressed = { pressed in
            self.leftPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyRightPressed = { pressed in
            self.rightPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyL1Pressed = { pressed in
            self.l1PressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyL2Pressed = { pressed, value in
            if self.isQuickLeftTrigger {
                self.l2PressedView.isHidden = value == 0.0
                
                self.l2AnimatedView.isHidden = true
            }
            else {
                self.l2PressedView.isHidden = true
                
                self.l2AnimatedView.isHidden = false
                self.l2AnimatedView.set(percent: CGFloat(value))
            }
        }
        
        var isPressingL3 = false
        GSGameControllerManager.shared().keyL3Pressed = { pressed in
            self.l3View.isHidden = !pressed
            isPressingL3 = pressed
        }
        
        GSGameControllerManager.shared().keyR1Pressed = { pressed in
            self.r1PressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyR2Pressed = { pressed, value in
            if self.isQuickRightTrigger {
                self.r2PressedView.isHidden = value == 0.0
                
                self.r2AnimatedView.isHidden = true
            }
            else {
                self.r2PressedView.isHidden = true
                
                self.r2AnimatedView.isHidden = false
                self.r2AnimatedView.set(percent: CGFloat(value))
            }
        }
        
        var isPressingR3 = false
        GSGameControllerManager.shared().keyR3Pressed = { pressed in
            self.r3View.isHidden = !pressed
            isPressingR3 = pressed
        }
        
        GSGameControllerManager.shared().keyHomePressed = { pressed in
//            self.homePressedView.isHidden = !pressed// 禁用此按键
        }
        
        GSGameControllerManager.shared().keyMenuPressed = { pressed in
            self.menuPressedView.isHidden = !pressed
        }
        
        GSGameControllerManager.shared().keyOptionsPressed = { pressed in
            self.optionsPressedView.isHidden = !pressed
        }
        
        // 左摇杆
        let l3Frame = self.l3View.frame
        GSGameControllerManager.shared().leftJoystickChanged = { dpad, x, y in
            self.l3View.isHidden = x == 0 && y == 0 && isPressingL3 == false// 注意：按下左摇杆时不隐藏
            
            var frame = l3Frame
            frame.origin.x = l3Frame.origin.x + self.joystickRadius * CGFloat(x)
            frame.origin.y = l3Frame.origin.y - self.joystickRadius * CGFloat(y)
            self.l3View.frame = frame
        }
        
        // 右摇杆
        let r3Frame = self.r3View.frame
        GSGameControllerManager.shared().rightJoystickChanged = { dpad, x, y in
            self.r3View.isHidden = x == 0 && y == 0 && isPressingR3 == false// 注意：按下右摇杆时不隐藏
            
            var frame = r3Frame
            frame.origin.x = r3Frame.origin.x + self.joystickRadius * CGFloat(x)
            frame.origin.y = r3Frame.origin.y - self.joystickRadius * CGFloat(y)
            self.r3View.frame = frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
}
