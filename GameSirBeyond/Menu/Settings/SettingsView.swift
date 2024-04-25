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

class SettingsView: UIView {
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var backButton1: AnimatedButton!
    @IBOutlet weak var backButton2: AnimatedButton!
    @IBOutlet weak var settingsLabel: UILabel!
    
    let accountView = SettingsContentView(frame: .zero)
    let controllerView = SettingsContentView(frame: .zero)
//    let connectAlertView = ConnectControllerAlertView(frame: .zero)
    var tableView = TabTableView(frame: CGRect.zero, style: .plain)
    
    @objc func injected() {
        contentView.removeFromSuperview()
        
        initSubviews()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    var contentView: UIView!
    func initSubviews() {
        let bgImageView = UIImageView(frame: bounds)
        bgImageView.image = UIImage(named: "full_bg")
        bgImageView.contentMode = .scaleAspectFill
        addSubview(bgImageView)
        addBlurEffect(style: .dark, alpha: 0.3)
        
        contentView = ((Bundle.main.loadNibNamed("SettingsView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = bounds// 不能用frame
        // 更新内部控件，否则内部控件的frame将是XIB上的数据。表现为右侧不能点击
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        leftView.clipsToBounds = false
        
        backButton1.tapAction = {
            self.btnActionBack()
        }
        backButton2.tapAction = {
            self.btnActionBack()
        }
        backButton2.setControllerImage(type: .b)
        
        settingsLabel.text = i18n(string: "Settings")
        
        // 左侧表格
        tableView = TabTableView.init(frame: CGRect(x: 0, y: 85, width: 200, height: UIScreen.main.bounds.size.height-85), style: .plain)
        leftView.addSubview(tableView)
        let tableViewDatas = [
            [
                SettingsTabDataKey.icon.rawValue: "tab_user",
                SettingsTabDataKey.selectedIcon.rawValue: "tab_user_selected",
                SettingsTabDataKey.title.rawValue: i18n(string: "Account"),
                SettingsTabDataKey.number.rawValue: "0",
                SettingsTabDataKey.type.rawValue: SettingsTabType.account.rawValue
            ],
            [
                SettingsTabDataKey.icon.rawValue: "tab_controller",
                SettingsTabDataKey.selectedIcon.rawValue: "tab_controller_selected",
                SettingsTabDataKey.title.rawValue: i18n(string: "Controller"),
                SettingsTabDataKey.number.rawValue: "0",
                SettingsTabDataKey.type.rawValue: SettingsTabType.controller.rawValue
            ]
        ]
        tableView.datas = tableViewDatas
        tableView.didSelectRow = { row in
            self.displayView(row: row)
        }
        
        // MARK: 手柄
        controllerView.frame = rightView.bounds
        rightView.addSubview(controllerView)
        controllerView.isHidden = true
        let controllerTestData = [SettingsContentDataKey.title.rawValue: i18n(string: "Controller Test"),
                                  SettingsContentDataKey.prompt.rawValue: "",
                                  SettingsContentDataKey.type.rawValue: SettingsContentType.controllerTest.rawValue]
        var controllerDatas = [
            [SettingsContentDataKey.title.rawValue: i18n(string: "Configure"),
             SettingsContentDataKey.prompt.rawValue: "",
             SettingsContentDataKey.type.rawValue: SettingsContentType.controllerKeySetting.rawValue],
            [SettingsContentDataKey.title.rawValue: i18n(string: "Firmware Upgrade"),
             SettingsContentDataKey.prompt.rawValue: "",
             SettingsContentDataKey.type.rawValue: SettingsContentType.controllerUpdateFirmware.rawValue],
            controllerTestData
        ]
#if !DEBUG
//        let gamepadName = getControllerName()
//        if gamepadName.lowercased() != "leadjoy-m1c" {
//            controllerDatas = [controllerTestData]
//        }
#endif
        controllerView.datas = controllerDatas
        controllerView.didSelectContent = { view, row in
            // 禁止非MFi模式下使用手柄功能
            if !checkIfInMFiMode() {
                return
            }
            
            switch view.type {
            case SettingsContentType.controllerKeySetting.rawValue:
                let destView = ControllerSettingsView(frame: self.bounds)
                self.superview?.addSubview(destView)
            case SettingsContentType.controllerUpdateFirmware.rawValue:
                let destView = UpdateFirmwareView(frame: self.bounds)
                self.superview?.addSubview(destView)
            case SettingsContentType.controllerTest.rawValue:
                let destView = TestKeyView(frame: self.bounds)
                self.superview?.addSubview(destView)
                
            default:
                break
            }
        }
        // 增加一行：手柄名称
        let controllerNameClickView = UIView.init(frame: CGRectMake((UIScreen.main.bounds.size.width-200-CGFloat(426))/2.0, 85-34, 426, 34))
        controllerNameClickView.layer.cornerRadius = 8.0
        controllerView.addSubview(controllerNameClickView)
        controllerNameClickView.backgroundColor = .black.withAlphaComponent(0.35)
        let nameLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 426-30, height: 34))
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = i18n(string: "Controller Name").appending(i18n(string: ":")).appending(getControllerName())
        nameLabel.font = pingFangM(size: 14)
        nameLabel.textColor = .white.withAlphaComponent(0.7)
        controllerNameClickView.addSubview(nameLabel)
        
        
        // MARK: 账号
        accountView.backgroundColor = .clear
        accountView.frame = rightView.bounds
        rightView.addSubview(accountView)
        let accountDatas = [
            [SettingsContentDataKey.title.rawValue: i18n(string: "Edit user information"),
             SettingsContentDataKey.prompt.rawValue: "",
             SettingsContentDataKey.type.rawValue: SettingsContentType.userEditInfo.rawValue],
            [SettingsContentDataKey.title.rawValue: i18n(string: "Log out account"),
             SettingsContentDataKey.prompt.rawValue: "",
             SettingsContentDataKey.type.rawValue: SettingsContentType.userLogoutAccount.rawValue],
            [SettingsContentDataKey.title.rawValue: i18n(string: "Cancel account"),
             SettingsContentDataKey.prompt.rawValue: "",
             SettingsContentDataKey.type.rawValue: SettingsContentType.userCancelAccount.rawValue]
        ] as! [[String: String]]
        accountView.datas = accountDatas
        accountView.didSelectContent = { view, row in
            switch view.type {
            case SettingsContentType.userEditInfo.rawValue:
                let editView = EditUserInformationView(frame: self.bounds)
                self.superview?.addSubview(editView)
            case SettingsContentType.userLogoutAccount.rawValue:
                let quitView = QuitAccountView(frame: self.bounds)
                quitView.titleLabel.text = i18n(string: "Are you sure to log out account?")
                quitView.confirmButton.setTitle(i18n(string: "Log out"), for: .normal)
                quitView.cancelButton.setTitle(i18n(string: "Cancel"), for: .normal)
                self.superview?.addSubview(quitView)
                quitView.didTapCloseButton = {
                    quitView.removeFromSuperview()
                }
                quitView.didTapCancelButton = {
                    quitView.removeFromSuperview()
                }
                quitView.didTapConfirmButton = {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                }
            case SettingsContentType.userCancelAccount.rawValue:
                let destView = CancelAccountView(frame: self.bounds)
                self.superview?.addSubview(destView)
            default:
                break
            }
        }
        
        // 手柄未连接页面
//        connectAlertView.frame = rightView.bounds
//        rightView.addSubview(connectAlertView)
//        connectAlertView.isHidden = true
//        rightView.sendSubviewToBack(connectAlertView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didConnectGamepad), name: Notification.Name("DidConnectControllerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnectGamepad), name: Notification.Name("DidDisconnectControllerNotification"), object: nil)
    }
    
    @objc func didConnectGamepad() {
        hideAlertView()
    }
    
    @objc func didDisconnectGamepad() {
        showAlertView()
    }
    
    // MARK: 提示连接手柄
    func showAlertView() {
//        if displayingPageIndex != 1 {
//            return
//        }
//        
//        MainThread {
//            self.connectAlertView.isHidden = false
//            self.rightView.bringSubviewToFront(self.connectAlertView)
//        }
    }
    
    func hideAlertView() {
//        if displayingPageIndex != 1 {
//            return
//        }
//        
//        MainThread {
//            self.connectAlertView.isHidden = true
//            self.rightView.sendSubviewToBack(self.connectAlertView)
//        }
    }
    
    var displayingPageIndex = 0
    func displayView(row: Int) {
//        displayingPageIndex = row
//        
//        switch row {
//        case 0:
//            accountView.isHidden = false
//            rightView.bringSubviewToFront(accountView)
//            controllerView.isHidden = true
//            
//            connectAlertView.isHidden = true
//            rightView.sendSubviewToBack(connectAlertView)
//        case 1:
//            accountView.isHidden = true
////            controllerView.isHidden = false
//            rightView.bringSubviewToFront(controllerView)
//            
//            if getControllerName() == "" {
////                connectAlertView.isHidden = false
//                rightView.bringSubviewToFront(connectAlertView)
//            }
//            else {
//                connectAlertView.isHidden = true
//                rightView.sendSubviewToBack(connectAlertView)
//            }
//        default:
//            break
//        }
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
            case 0:
                accountView.unselectAllClickView()
            case 1:
                controllerView.unselectAllClickView()
            default:
                break
            }
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
            case 0:
                accountView.selectFirstClickView()
            case 1:
                controllerView.selectFirstClickView()
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
                case 0:
                    accountView.clickSelectedClickView()
                case 1:
                    controllerView.clickSelectedClickView()
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
