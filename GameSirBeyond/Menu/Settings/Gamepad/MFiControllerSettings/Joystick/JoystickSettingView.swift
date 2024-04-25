//
//  JoystickSettingView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/10/26.
//

import UIKit

class JoystickSettingView: UIView, RangeSeekSliderDelegate {
    
    var leftSlider: RangeSeekSlider!
    var rightSlider: RangeSeekSlider!
    
    @IBOutlet weak var leftTitleLabel: I18nLabel!
    @IBOutlet weak var rightTitleLabel: I18nLabel!
    
    @IBOutlet weak var leftAlertView: UIView!
    @IBOutlet weak var rightAlertView: UIView!
    @IBOutlet weak var dpadLockAlertView: UIView!
    @IBOutlet weak var leftAlertLabel: I18nLabel!
    @IBOutlet weak var rightAlertLabel: I18nLabel!
    
    @IBOutlet weak var leftOutDeadZoneView: UIView!
    @IBOutlet weak var leftInDeadZoneView: UIView!
    @IBOutlet weak var leftOutDeadZoneViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftInDeadZoneViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightOutDeadZoneView: UIView!
    @IBOutlet weak var rightInDeadZoneView: UIView!
    @IBOutlet weak var rightOutDeadZoneViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightInDeadZoneViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dpadLockSwitch: UISwitch!
    
    @IBOutlet weak var leftCenterView: UIView!
    @IBOutlet weak var rightCenterView: UIView!
    
    override var isHidden: Bool {
        didSet {
            if isHidden == false {
                observeJoysticks()
                readControllerData()
            }
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private var joystickRadius = 60.0// 从xib获取
    func observeJoysticks() {
        // 左摇杆
        let l3Frame = self.leftCenterView.frame
        GSGameControllerManager.shared().leftJoystickChanged = { dpad, x, y in
            var frame = l3Frame
            frame.origin.x = l3Frame.origin.x + self.joystickRadius * CGFloat(x)
            frame.origin.y = l3Frame.origin.y - self.joystickRadius * CGFloat(y)
            self.leftCenterView.frame = frame
        }
        
        // 右摇杆
        let r3Frame = self.rightCenterView.frame
        GSGameControllerManager.shared().rightJoystickChanged = { dpad, x, y in
            var frame = r3Frame
            frame.origin.x = r3Frame.origin.x + self.joystickRadius * CGFloat(x)
            frame.origin.y = r3Frame.origin.y - self.joystickRadius * CGFloat(y)
            self.rightCenterView.frame = frame
        }
    }
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("JoystickSettingView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        let unselectedColor = UIColor.white.withAlphaComponent(0.36)
        
        leftSlider = RangeSeekSlider(frame: .zero)
        contentView.addSubview(leftSlider)
        leftSlider.snp.makeConstraints { make in
            make.left.equalTo(leftTitleLabel)
            make.top.equalTo(leftTitleLabel.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 226, height: 80))
        }
        leftSlider.fullWidth = 226
        leftSlider.tintColor = unselectedColor
        leftSlider.colorBetweenHandles = GamepadSettingMainColor
        leftSlider.delegate = self
        leftSlider.lineHeight = 8
        
        rightSlider = RangeSeekSlider(frame: .zero)
        contentView.addSubview(rightSlider)
        rightSlider.snp.makeConstraints { make in
            make.left.equalTo(rightTitleLabel)
            make.top.equalTo(rightTitleLabel.snp.bottom).offset(12)
            make.size.equalTo(leftSlider)
        }
        rightSlider.fullWidth = 226
        rightSlider.tintColor = unselectedColor
        rightSlider.colorBetweenHandles = GamepadSettingMainColor
        rightSlider.delegate = self
        rightSlider.lineHeight = 8
        
//        for subview in contentView.subviews {
//            if subview.isKind(of: UISwitch.self) {
//                subview.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
//            }
//        }
        observeControllerCommand()
    }
    
    // MARK: 重置为默认配置
    func resetConfiguration() {
        eggshellAppDelegate().writeCommandSetJoystickDeadZone(isLeftJoystick: true, isInnerDeadZone: true, value: 10)
        delay(interval: 0.1) {
            eggshellAppDelegate().writeCommandSetJoystickDeadZone(isLeftJoystick: true, isInnerDeadZone: false, value: 100)
            delay(interval: 0.1) {
                eggshellAppDelegate().writeCommandSetJoystickDeadZone(isLeftJoystick: false, isInnerDeadZone: true, value: 10)
                delay(interval: 0.1) {
                    eggshellAppDelegate().writeCommandSetJoystickDeadZone(isLeftJoystick: false, isInnerDeadZone: false, value: 100)
                    delay(interval: 0.1) {
                        eggshellAppDelegate().writeCommandSetDpadLock(isOn: false)
                        delay(interval: 0.1) {
                            if self.isHidden == false {
                                self.readControllerData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 读取手柄数据
    func readControllerData() {
        eggshellAppDelegate().writeCommandReadJoystickDeadZone(isLeftJoystick: true, isInnerDeadZone: true)
        delay(interval: 0.1) {
            eggshellAppDelegate().writeCommandReadJoystickDeadZone(isLeftJoystick: true, isInnerDeadZone: false)
            delay(interval: 0.1) {
                eggshellAppDelegate().writeCommandReadJoystickDeadZone(isLeftJoystick: false, isInnerDeadZone: true)
                delay(interval: 0.1) {
                    eggshellAppDelegate().writeCommandReadJoystickDeadZone(isLeftJoystick: false, isInnerDeadZone: false)
                    delay(interval: 0.1) {
                        eggshellAppDelegate().writeCommandReadDpadLock()
                    }
                }
            }
        }
    }
    
    // MARK: 监听手柄指令
    func observeControllerCommand() {
        NotificationCenter.default.addObserver(self, selector: #selector(didGetDpadLock(notification:)), name: Notification.Name("DidGetDpadLockNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetLeftJoystickInnerDeadZone(notification:)), name: Notification.Name("DidGetLeftJoystickInnerDeadZoneNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetLeftJoystickOutDeadZone(notification:)), name: Notification.Name("DidGetLeftJoystickOutDeadZoneNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetRightJoystickInnerDeadZone(notification:)), name: Notification.Name("DidGetRightJoystickInnerDeadZoneNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetRightJoystickOutDeadZone(notification:)), name: Notification.Name("DidGetRightJoystickOutDeadZoneNotification"), object: nil)
    }
    
    @objc func didGetDpadLock(notification: Notification) {
        let value = notification.object as! Bool
        MainThread {
            self.dpadLockSwitch.isOn = value
        }
    }
    
    @objc func didGetLeftJoystickInnerDeadZone(notification: Notification) {
        let value = notification.object as! Int
        MainThread {
            self.leftSlider.selectedMinValue = CGFloat(value)
            self.leftSlider.layoutSubviews()
            
            let inWidth = CGFloat(value)*1.2
            self.leftInDeadZoneViewWidthConstraint.constant = inWidth
            self.leftInDeadZoneView.layer.cornerRadius = inWidth/2.0
        }
    }
    
    @objc func didGetLeftJoystickOutDeadZone(notification: Notification) {
        let value = notification.object as! Int
        MainThread {
            self.leftSlider.selectedMaxValue = CGFloat(value)
            self.leftSlider.layoutSubviews()
            
            let outWidth = CGFloat(value)*1.2
            self.leftOutDeadZoneViewWidthConstraint.constant = outWidth
            self.leftOutDeadZoneView.layer.cornerRadius = outWidth/2.0
            
            self.leftAlertLabel.isHidden = self.leftSlider.selectedMinInt >= 10 && self.leftSlider.selectedMaxInt >= 10
        }
    }
    
    @objc func didGetRightJoystickInnerDeadZone(notification: Notification) {
        let value = notification.object as! Int
        MainThread {
            self.rightSlider.selectedMinValue = CGFloat(value)
            self.rightSlider.layoutSubviews()
            
            let inWidth = CGFloat(value)*1.2
            self.rightInDeadZoneViewWidthConstraint.constant = inWidth
            self.rightInDeadZoneView.layer.cornerRadius = inWidth/2.0
        }
    }
    
    @objc func didGetRightJoystickOutDeadZone(notification: Notification) {
        let value = notification.object as! Int
        MainThread {
            self.rightSlider.selectedMaxValue = CGFloat(value)
            self.rightSlider.layoutSubviews()
            
            let outWidth = CGFloat(value)*1.2
            self.rightOutDeadZoneViewWidthConstraint.constant = outWidth
            self.rightOutDeadZoneView.layer.cornerRadius = outWidth/2.0
            
            self.rightAlertLabel.isHidden = self.rightSlider.selectedMinInt >= 10 && self.rightSlider.selectedMaxInt >= 10
        }
    }
    
    func checkNeedShowDeadZoneTooSmallAlertLabel() {
        self.leftAlertLabel.isHidden = self.leftSlider.selectedMinInt >= 10 && self.leftSlider.selectedMaxInt >= 10
        self.rightAlertLabel.isHidden = self.rightSlider.selectedMinInt >= 10 && self.rightSlider.selectedMaxInt >= 10
    }
    
    // MARK: 拖动滑动条
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        // 动态修改CornerRadius
        if slider == leftSlider {
            let inWidth = CGFloat(slider.selectedMinInt)*1.2
            leftInDeadZoneViewWidthConstraint.constant = inWidth
            leftInDeadZoneView.layer.cornerRadius = inWidth/2.0
            
            let outWidth = CGFloat(slider.selectedMaxValue)*1.2
            leftOutDeadZoneViewWidthConstraint.constant = outWidth
            leftOutDeadZoneView.layer.cornerRadius = outWidth/2.0
        }
        else if slider == rightSlider {
            let inWidth = CGFloat(slider.selectedMinInt)*1.2
            rightInDeadZoneViewWidthConstraint.constant = inWidth
            rightInDeadZoneView.layer.cornerRadius = inWidth/2.0
            
            let outWidth = CGFloat(slider.selectedMaxValue)*1.2
            rightOutDeadZoneViewWidthConstraint.constant = outWidth
            rightOutDeadZoneView.layer.cornerRadius = outWidth/2.0
        }
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        checkNeedShowDeadZoneTooSmallAlertLabel()
        
        if slider == leftSlider {
            eggshellAppDelegate().writeCommandSetJoystickDeadZone(isLeftJoystick: true, isInnerDeadZone: true, value: slider.selectedMinInt)
            delay(interval: 0.1) {
                eggshellAppDelegate().writeCommandSetJoystickDeadZone(isLeftJoystick: true, isInnerDeadZone: false, value: slider.selectedMaxInt)
            }
        }
        else if slider == rightSlider {
            eggshellAppDelegate().writeCommandSetJoystickDeadZone(isLeftJoystick: false, isInnerDeadZone: true, value: slider.selectedMinInt)
            delay(interval: 0.1) {
                eggshellAppDelegate().writeCommandSetJoystickDeadZone(isLeftJoystick: false, isInnerDeadZone: false, value: slider.selectedMaxInt)
            }
        }
    }
    
    @IBAction func btnActionShowLeftAlertView(_ sender: UIButton) {
        leftAlertView.isHidden = !leftAlertView.isHidden
        contentView.bringSubviewToFront(leftAlertView)
    }
    
    @IBAction func btnActionShowRightAlertView(_ sender: UIButton) {
        rightAlertView.isHidden = !rightAlertView.isHidden
        contentView.bringSubviewToFront(rightAlertView)
    }
    
    @IBAction func switchActionDpadLock(_ sender: UISwitch) {
        eggshellAppDelegate().writeCommandSetDpadLock(isOn: sender.isOn)
    }
    
    @IBAction func btnActionShowDpadLockAlertView(_ sender: Any) {
        dpadLockAlertView.isHidden = !dpadLockAlertView.isHidden
        contentView.bringSubviewToFront(dpadLockAlertView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        leftAlertView.isHidden = true
        rightAlertView.isHidden = true
        dpadLockAlertView.isHidden = true
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
