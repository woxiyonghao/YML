//
//  TriggerSettingView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/10/26.
//

import UIKit

let GamepadSettingMainColor = UIColor(red: 0.96, green: 0.69, blue: 0.22, alpha: 1)

class TriggerSettingView: UIView, RangeSeekSliderDelegate {
    
    var leftSlider: RangeSeekSlider!
    var rightSlider: RangeSeekSlider!
    
    let testViewWidth = 180.0
    var leftTestView: UIView!
    var rightTestView: UIView!
    
    @IBOutlet weak var leftTitleLabel: I18nLabel!
    @IBOutlet weak var rightTitleLabel: I18nLabel!
    @IBOutlet weak var leftTriggerBgView: UILabel!
    @IBOutlet weak var rightTriggerBgView: UILabel!
    @IBOutlet weak var leftTestValueLabel: UILabel!
    @IBOutlet weak var rightTestValueLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var leftSwitch: UISwitch!
    @IBOutlet weak var rightSwitch: UISwitch!
    
    override var isHidden: Bool {
        didSet {
            if isHidden == false {
                observeTriggers()
                readControllerData()
                
                resetTestData()
            }
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: 监听扳机键
    func observeTriggers() {
        GSGameControllerManager.shared().keyL2Pressed = { pressed, value in
            print("左扳机键键值：\(value)")
            MainThread {
                let width = self.testViewWidth*CGFloat(value)
                self.leftTestView.snp.updateConstraints { make in
                    make.width.equalTo(width).priority(.medium)
                }
                
                self.leftTestValueLabel.text = String.init(format: "%.0f", 255*value)
            }
        }
        
        GSGameControllerManager.shared().keyR2Pressed = { pressed, value in
            MainThread {
                let width = self.testViewWidth*CGFloat(value)
                self.rightTestView.snp.updateConstraints { make in
                    make.width.equalTo(width).priority(.medium)
                }
                
                self.rightTestValueLabel.text = String.init(format: "%.0f", 255*value)
            }
        }
    }
    
    func resetTestData() {
        self.leftTestValueLabel.text = "0"
        self.rightTestValueLabel.text = "0"
        leftTestView.snp.updateConstraints { make in
            make.width.equalTo(0).priority(.medium)
        }
        rightTestView.snp.updateConstraints { make in
            make.width.equalTo(0).priority(.medium)
        }
    }
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("TriggerSettingView", owner: self, options: nil)?.first) as! UIView)
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
        
        leftTestView = UIView()
        contentView.addSubview(leftTestView)
        leftTestView.backgroundColor = GamepadSettingMainColor
        leftTestView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(leftTriggerBgView)
            make.width.equalTo(testViewWidth).priority(.medium)
        }
        leftTestView.snp.updateConstraints { make in
            // 必须添加.priority(.medium)，否则报错：Fatal error: Updated constraint could not find existing matching constraint to update: <ModuleT4c.LayoutConstraint:0x283844cc0@TriggerSettingsView.swift#169 UIView:0x121da1290.width == 0.0>
            make.width.equalTo(0).priority(.medium)
        }
        
        rightTestView = UIView()
        contentView.addSubview(rightTestView)
        rightTestView.backgroundColor = GamepadSettingMainColor
        rightTestView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(rightTriggerBgView)
            make.width.equalTo(testViewWidth).priority(.medium)
        }
        rightTestView.snp.updateConstraints { make in
            make.width.equalTo(0).priority(.medium)
        }
        
//        for subview in contentView.subviews {
//            if subview.isKind(of: UISwitch.self) {
//                subview.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
//            }
//        }
        observeControllerCommand()
    }
    
    // MARK: 重置为默认配置
    func resetConfiguration() {
        eggshellAppDelegate().writeCommandSetTriggerDeadZone(isLeftTrigger: true, isInnerDeadZone: true, value: 5)
        delay(interval: 0.1) {
            eggshellAppDelegate().writeCommandSetTriggerDeadZone(isLeftTrigger: true, isInnerDeadZone: false, value: 100)
            delay(interval: 0.1) {
                eggshellAppDelegate().writeCommandSetTriggerDeadZone(isLeftTrigger: false, isInnerDeadZone: true, value: 5)
                delay(interval: 0.1) {
                    eggshellAppDelegate().writeCommandSetTriggerDeadZone(isLeftTrigger: false, isInnerDeadZone: false, value: 100)
                    delay(interval: 0.1) {
                        eggshellAppDelegate().writeCommandSetQuickTrigger(isLeftTrigger: true, isOn: false)
                        delay(interval: 0.1) {
                            eggshellAppDelegate().writeCommandSetQuickTrigger(isLeftTrigger: false, isOn: false)
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
    }
    
    // MARK: 监听手柄指令
    func observeControllerCommand() {
        NotificationCenter.default.addObserver(self, selector: #selector(didGetLeftQuickTrigger(notification:)), name: Notification.Name("DidGetLeftQuickTriggerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetRightQuickTrigger(notification:)), name: Notification.Name("DidGetRightQuickTriggerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetLeftTriggerInnerDeadZone(notification:)), name: Notification.Name("DidGetLeftTriggerInnerDeadZoneNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetLeftTriggerOutDeadZone(notification:)), name: Notification.Name("DidGetLeftTriggerOutDeadZoneNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetRightTriggerInnerDeadZone(notification:)), name: Notification.Name("DidGetRightTriggerInnerDeadZoneNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetRightTriggerOutDeadZone(notification:)), name: Notification.Name("DidGetRightTriggerOutDeadZoneNotification"), object: nil)
    }
    
    // MARK: 读取手柄数据
    func readControllerData() {
        eggshellAppDelegate().writeCommandReadTriggerDeadZone(isLeftTrigger: true, isInnerDeadZone: true)
        delay(interval: 0.1) {
            eggshellAppDelegate().writeCommandReadTriggerDeadZone(isLeftTrigger: true, isInnerDeadZone: false)
            delay(interval: 0.1) {
                eggshellAppDelegate().writeCommandReadTriggerDeadZone(isLeftTrigger: false, isInnerDeadZone: true)
                delay(interval: 0.1) {
                    eggshellAppDelegate().writeCommandReadTriggerDeadZone(isLeftTrigger: false, isInnerDeadZone: false)
                    delay(interval: 0.1) {
                        eggshellAppDelegate().writeCommandReadQuickTrigger(isLeft: true)
                        delay(interval: 0.1) {
                            eggshellAppDelegate().writeCommandReadQuickTrigger(isLeft: false)
                        }
                    }
                }
            }
        }
    }
    
    @objc func didGetLeftQuickTrigger(notification: Notification) {
        let isOn = notification.object as! Bool
        MainThread {
            self.leftSwitch.isOn = isOn
        }
    }
    
    @objc func didGetRightQuickTrigger(notification: Notification) {
        let isOn = notification.object as! Bool
        MainThread {
            self.rightSwitch.isOn = isOn
        }
    }
    
    @objc func didGetLeftTriggerInnerDeadZone(notification: Notification) {
        let value = notification.object as! Int
        MainThread {
            self.leftSlider.selectedMinValue = CGFloat(value)
            self.leftSlider.layoutSubviews()
        }
    }
    
    @objc func didGetLeftTriggerOutDeadZone(notification: Notification) {
        let value = notification.object as! Int
        MainThread {
            self.leftSlider.selectedMaxValue = CGFloat(value)
            self.leftSlider.layoutSubviews()
        }
    }
    
    @objc func didGetRightTriggerInnerDeadZone(notification: Notification) {
        let value = notification.object as! Int
        MainThread {
            self.rightSlider.selectedMinValue = CGFloat(value)
            self.rightSlider.layoutSubviews()
        }
    }
    
    @objc func didGetRightTriggerOutDeadZone(notification: Notification) {
        let value = notification.object as! Int
        MainThread {
            self.rightSlider.selectedMaxValue = CGFloat(value)
            self.rightSlider.layoutSubviews()
        }
    }
    
    // MARK: 拖动滑动条
    func didEndTouches(in slider: RangeSeekSlider) {
        if slider == leftSlider {
            eggshellAppDelegate().writeCommandSetTriggerDeadZone(isLeftTrigger: true, isInnerDeadZone: true, value: slider.selectedMinInt)
            delay(interval: 0.1) {
                eggshellAppDelegate().writeCommandSetTriggerDeadZone(isLeftTrigger: true, isInnerDeadZone: false, value: slider.selectedMaxInt)
            }
        }
        else if slider == rightSlider {
            eggshellAppDelegate().writeCommandSetTriggerDeadZone(isLeftTrigger: false, isInnerDeadZone: true, value: slider.selectedMinInt)
            delay(interval: 0.1) {
                eggshellAppDelegate().writeCommandSetTriggerDeadZone(isLeftTrigger: false, isInnerDeadZone: false, value: slider.selectedMaxInt)
            }
        }
    }
    
    @IBAction func btnActionShowInfo(_ sender: UIButton) {
        alertView.isHidden = !alertView.isHidden
        contentView.bringSubviewToFront(alertView)
    }
    
    @IBAction func switchActionLeftQuickTrigger(_ sender: UISwitch) {
        eggshellAppDelegate().writeCommandSetQuickTrigger(isLeftTrigger: true, isOn: sender.isOn)
    }
    
    @IBAction func switchActionRightQuickTrigger(_ sender: UISwitch) {
        eggshellAppDelegate().writeCommandSetQuickTrigger(isLeftTrigger: false, isOn: sender.isOn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alertView.isHidden = true
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
