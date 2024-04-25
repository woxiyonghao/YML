//
//  SettingsView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/22.
//

import UIKit
import SnapKit
import Moya
import SwiftyJSON

class ControllerSettingsView: UIView {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var backButton1: AnimatedButton!
    @IBOutlet weak var backButton2: AnimatedButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var resetAllConfigButton: AnimatedButton!
    @IBOutlet weak var resetCurrentPageConfigButton: AnimatedButton!
    
    var displayingPageIndex = 0
    
    let keyView = KeySettingView(frame: .zero)
    let joystickView = JoystickSettingView(frame: .zero)
    let triggerView = TriggerSettingView(frame: .zero)
    var tableView = TabTableView(frame: CGRect.zero, style: .plain)
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        eggshellAppDelegate().unobserveGamepadKey()
        eggshellAppDelegate().observeGamepadKey()
    }
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        let bgImageView = UIImageView(frame: bounds)
        bgImageView.image = UIImage(named: "full_bg")
        bgImageView.contentMode = .scaleAspectFill
        addSubview(bgImageView)
        addBlurEffect(style: .dark, alpha: 0.3)
        
        contentView = ((Bundle.main.loadNibNamed("ControllerSettingsView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(quitCurrentView), name: Notification.Name("NeedToQuitMFiControllerPage"), object: nil)
        
        leftView.clipsToBounds = false
        
        backButton1.tapAction = {
            self.btnActionBack()
        }
        backButton2.tapAction = {
            self.btnActionBack()
        }
        backButton2.setControllerImage(type: .b)
        
        resetCurrentPageConfigButton.tapAction = {
            var type = ""
            switch self.displayingPageIndex {
            case 0:
                type = i18n(string: "Button")
            case 1:
                type = i18n(string: "Joystick")
            case 2:
                type = i18n(string: "Trigger")
            default:
                break
            }
            type = i18n(string: "[") + type + i18n(string: "]")
            
            var message = i18n(string: "The default configuration of [xxx] will be restored")
            message = message.replacingOccurrences(of: "[xxx]", with: type)
            let alertController = UIAlertController(title: i18n(string: "Reset to default?"), message: message, preferredStyle: .alert)
            let action1 = UIAlertAction(title: i18n(string: "Cancel"), style: .cancel, handler: nil)
            let action2 = UIAlertAction(title: i18n(string: "Confirm"), style: .destructive) { action in
                MBProgressHUD.showActivityLoading("", afterDelay: 2.0)
                
                switch self.displayingPageIndex {
                case 0:
                    print("恢复按键的默认配置")
                    self.keyView.resetConfiguration()
                case 1:
                    print("恢复摇杆的默认配置")
                    self.joystickView.resetConfiguration()
                case 2:
                    print("恢复扳机的默认配置")
                    self.triggerView.resetConfiguration()
                default:
                    break
                }
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            UIViewController.current()?.present(alertController, animated: true)
        }
        
        resetAllConfigButton.tapAction = {
            let alertController = UIAlertController(title: i18n(string: "Reset to default?"), message: i18n(string: "Buttons, Sticks, Triggers and other configurations will all return to default"), preferredStyle: .alert)
            let action1 = UIAlertAction(title: i18n(string: "Cancel"), style: .cancel, handler: nil)
            let action2 = UIAlertAction(title: i18n(string: "Confirm"), style: .destructive) { action in
                MBProgressHUD.showActivityLoading("", afterDelay: 4.0)
                
                print("恢复所有配置")
                self.keyView.resetConfiguration()
                delay(interval: 1.0) {
                    self.joystickView.resetConfiguration()
                    delay(interval: 1.0) {
                        self.triggerView.resetConfiguration()
                        delay(interval: 1.0) {
                            
                        }
                    }
                }
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            UIViewController.current()?.present(alertController, animated: true)
        }
        
        // 左侧表格
        tableView = TabTableView.init(frame: CGRect(x: 0, y: 85, width: 200, height: UIScreen.main.bounds.size.height-85), style: .plain)
        leftView.addSubview(tableView)
        // 数据
        let tableViewDatas = [
            [
                SettingsTabDataKey.icon.rawValue: "key_setting_key",
                SettingsTabDataKey.selectedIcon.rawValue: "key_setting_key_selected",
                SettingsTabDataKey.title.rawValue: i18n(string: "Button"),
                SettingsTabDataKey.number.rawValue: "0",
                SettingsTabDataKey.type.rawValue: SettingsTabType.button.rawValue
            ],
            [
                SettingsTabDataKey.icon.rawValue: "key_setting_joystick",
                SettingsTabDataKey.selectedIcon.rawValue: "key_setting_joystick_selected",
                SettingsTabDataKey.title.rawValue: i18n(string: "Joystick"),
                SettingsTabDataKey.number.rawValue: "0",
                SettingsTabDataKey.type.rawValue: SettingsTabType.joystick.rawValue
            ],
            [
                SettingsTabDataKey.icon.rawValue: "key_setting_trigger",
                SettingsTabDataKey.selectedIcon.rawValue: "key_setting_trigger_selected",
                SettingsTabDataKey.title.rawValue: i18n(string: "Trigger"),
                SettingsTabDataKey.number.rawValue: "0",
                SettingsTabDataKey.type.rawValue: SettingsTabType.trigger.rawValue
            ]
        ]
        tableView.datas = tableViewDatas
        tableView.didSelectRow = { row in
            self.displayView(row: row)
        }
        
        // 扳机设置
        triggerView.frame = rightView.bounds
        rightView.addSubview(triggerView)
        triggerView.isHidden = true
        
        // 摇杆设置
        joystickView.frame = rightView.bounds
        rightView.addSubview(joystickView)
        joystickView.isHidden = true
        
        // 按键设置
        keyView.backgroundColor = .clear
        keyView.frame = rightView.bounds
        rightView.addSubview(keyView)
        keyView.readControllerData()
    }
    
    func displayView(row: Int) {
        displayingPageIndex = row
        
        switch row {
        case 0:
            keyView.isHidden = false
            rightView.bringSubviewToFront(keyView)
            joystickView.isHidden = true
            triggerView.isHidden = true
        case 1:
            keyView.isHidden = true
            joystickView.isHidden = false
            rightView.bringSubviewToFront(joystickView)
            triggerView.isHidden = true
        case 2:
            keyView.isHidden = true
            joystickView.isHidden = true
            triggerView.isHidden = false
            rightView.bringSubviewToFront(triggerView)
        default:
            break
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
    
    func btnActionBack() {
//        let destView = MenuView.init(frame: superview!.bounds)
//        superview?.addSubview(destView)
        NotificationCenter.default.removeObserver(self)
        removeFromSuperview()
    }
    
    // MARK: 手柄操控
    
    func gamepadKeyUpAction() {
        if isControllingRightView {
            let subview = rightView.subviews.last
            if subview is SettingsContentView {
                (subview as! SettingsContentView).selectUpClickView()
            }
            appPlayIneffectiveSound()
            return
        }
        
        let destRow = tableView.focusIndexPath.row-1
        if destRow < 0 {
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        let destIndexPath = IndexPath(row: destRow, section: tableView.focusIndexPath.section)
        tableView.tableView(tableView, didSelectRowAt: destIndexPath)
    }
    
    func gamepadKeyDownAction() {
        if isControllingRightView {
            let subview = rightView.subviews.last
            if subview is SettingsContentView {
                (subview as! SettingsContentView).selectDownClickView()
            }
            return
        }
        
        let destRow = tableView.focusIndexPath.row+1
        if destRow >= tableView.datas.count {
            appPlayIneffectiveSound()
            return
        }
        
        appPlayScrollSound()
        let destIndexPath = IndexPath(row: destRow, section: tableView.focusIndexPath.section)
        tableView.tableView(tableView, didSelectRowAt: destIndexPath)
    }
    
    func gamepadKeyLeftAction() {
        if isControllingRightView {
            appPlayScrollSound()
            
            tableView.cellForRow(at: tableView.focusIndexPath)?.isSelected = true
            
            switch tableView.focusIndexPath.row {
//            case 0:
//                accountView.unselectAllClickView()
//            case 1:
//                controllerView.unselectAllClickView()
            default:
                break
            }
            
            return
        }
        else {
            appPlayIneffectiveSound()
        }
    }
    
    func gamepadKeyRightAction() {
        if isControllingRightView {
            appPlayIneffectiveSound()
            return
        }
        
        if tableView.focusIndexPath.row >= 0 {
            let cell = tableView.cellForRow(at: tableView.focusIndexPath) as? TabTableViewCell
            cell?.isSelected = false
            cell?.isGrayStatus = true
            appPlayScrollSound()

            switch tableView.focusIndexPath.row {
//            case 0:
//                accountView.selectFirstClickView()
//            case 1:
//                controllerView.selectFirstClickView()
            default:
                break
            }
        }
    }
    
    func gamepadKeyAAction() {
        if isControllingRightView {
            appPlaySelectSound()
            if tableView.focusIndexPath.row >= 0 {
                switch tableView.focusIndexPath.row {
//                case 0:
//                    accountView.clickSelectedClickView()
//                case 1:
//                    controllerView.clickSelectedClickView()
                default:
                    break
                }
            }
        }
    }
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        backButton2.sendActions(for: .touchUpInside)
    }
    
    @objc func quitCurrentView() {
        backButton2.sendActions(for: .touchUpInside)
    }
    
    var isControllingRightView: Bool {
        get {
            if rightView.subviews.count > 0 {
                let subview = rightView.subviews.last
                if subview is SettingsContentView {
                    if (subview as! SettingsContentView).focusTag > 0 {
                        return true
                    }
                }
            }
            return false
        }
        set {
            
        }
    }
}
