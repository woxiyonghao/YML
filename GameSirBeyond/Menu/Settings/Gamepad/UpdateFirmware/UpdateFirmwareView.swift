//
//  UpdateFirmwareView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/10/25.
//

import UIKit

class UpdateFirmwareView: UIView {

    @IBOutlet weak var nameLabel: I18nLabel!
    // 返回按钮
    @IBOutlet weak var backButton1: AnimatedButton!
    @IBOutlet weak var backButton2: AnimatedButton!
    // 版本号
    @IBOutlet weak var selectedVersionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: I18nLabel!
    @IBOutlet weak var latestTabLabel: UILabel!
    @IBOutlet weak var releaseNotesTitleLabel: I18nLabel!
    @IBOutlet weak var releaseNotesLabel: UILabel!
    // 最新版本
    @IBOutlet weak var alreadyLatestVersionLabel: UILabel!
    // 升级
    @IBOutlet weak var updateNowButton: UIButton!
    @IBOutlet weak var updatingProgressLabel: UILabel!
    @IBOutlet weak var updatingBgView: UIView!
    @IBOutlet weak var updatingBgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var updatingAlertLabel: UILabel!
    // 所有版本
    @IBOutlet weak var allFirmwareButton: UIButton!
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("UpdateFirmwareView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        updatingProgressLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .medium)// 文字等宽显示，每个文字的显示宽度相同
        backButton1.tapAction = {
            self.btnActionBack()
        }
        backButton2.tapAction = {
            self.btnActionBack()
        }
        backButton2.setControllerImage(type: .b)
        
        nameLabel.text = getControllerName()
        selectedVersionLabel.text = ""
        releaseDateLabel.text = ""
        releaseNotesLabel.text = ""
        releaseNotesTitleLabel.isHidden = true
        
        observeControllerCommand()
        eggshellAppDelegate().writeCommandReadFirmwareVersion()
    }
    
    override func removeFromSuperview() {
        NotificationCenter.default.removeObserver(self)
        
        super.removeFromSuperview()
    }
    
    func btnActionBack() {
        if isUpdating {
            MBProgressHUD.showMsgWithtext(i18n(string: "Upgrading firmware, please wait..."))
            return
        }
        
        removeFromSuperview()
    }
    
    // MARK: 监听手柄指令
    func observeControllerCommand() {
        NotificationCenter.default.addObserver(self, selector: #selector(didGetFirmwareVersion(notification:)), name: Notification.Name("DidGetFirmwareVersionNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFirmwareProgress(notification:)), name: Notification.Name("DidUpdateFirmwareProgressNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSwitchToMFiMode), name: Notification.Name("DidOpenControllerSessionNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnectController), name: Notification.Name("DidDisconnectControllerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quitCurrentView), name: Notification.Name("NeedToQuitMFiControllerPage"), object: nil)
    }
    
    // 进入升级后，手柄必然会断开。包括人为拔掉手柄
    @objc func didDisconnectController() {
        if isUpdating {
            isUpdating = false
            MainThread {
                self.updatingAlertLabel.text = i18n(string: "The controller has been disconnected, waiting for the controller to reconnect...")
                self.updatingAlertLabel.isHidden = false
                self.updatingProgressLabel.isHidden = true
                self.updatingBgView.isHidden = true
            }
        }
    }
    
    var currentVersion = ""
    @objc func didGetFirmwareVersion(notification: Notification) {
        let versionData = notification.object as! [String]// 由于固件的错误，把大小版本互换了。原版本号为0.3，而实际数据代表3.0。iOS端显示逻辑为"00 03" -> 0.3
        let bigVersion = GSDataTool.int(withHexString: versionData[0])
        let smallVersion = GSDataTool.int(withHexString: versionData[1])
        let version = "\(bigVersion).\(smallVersion)"
        currentVersion = version
    
        MainThread {
            self.nameLabel.text = getControllerName() + "  " + version
            self.checkIfNeedUpdate()
        }
    }
    
    var isUpdating = false
    @objc func didUpdateFirmwareProgress(notification: Notification) {
        isUpdating = true
        
        let progress = notification.object as! CGFloat
        MainThread {
            self.updatingProgressLabel.text = i18n(string: "Upgrading...").appendingFormat("%.1f%%", progress)
            self.updatingBgViewWidthConstraint.constant = 152.0/100.0*progress
            
            self.updatingBgView.isHidden = false
            self.updatingProgressLabel.isHidden = false
            self.updatingAlertLabel.isHidden = false
            self.updatingAlertLabel.text = i18n(string: "Upgrading alert text")
            self.allFirmwareButton.isHidden = true
        }
        
        if progress >= 100.0 {
            isUpdating = false
            finishUpdating()
        }
    }
    
    @objc func didSwitchToMFiMode() {
        eggshellAppDelegate().writeCommandReadFirmwareVersion()
    }
    
    func finishUpdating() {
        updatingAlertLabel.text = i18n(string: "Firmware upgrade successful, please wait for the controller to restart...")
        updatingProgressLabel.isHidden = true
        updatingBgView.isHidden = true
        allFirmwareButton.isHidden = false
    }
    
    var canUpdate = false
    // MARK: 版本号对比
    func checkIfNeedUpdate() {
        if currentVersion == selectedControllerFirmwareVersion {
            canUpdate = false
            
            alreadyLatestVersionLabel.isHidden = false
            allFirmwareButton.isHidden = false
            
            selectedVersionLabel.isHidden = true
            releaseDateLabel.isHidden = true
            latestTabLabel.isHidden = true
            releaseNotesTitleLabel.isHidden = true
            releaseNotesLabel.isHidden = true
            
            updateNowButton.isHidden = true
            updatingProgressLabel.isHidden = true
            updatingBgView.isHidden = true
            updatingAlertLabel.isHidden = true
            print("不需要升级固件")
            return
        }
        
        canUpdate = true
        
        alreadyLatestVersionLabel.isHidden = true
        
        releaseNotesTitleLabel.isHidden = false
        selectedVersionLabel.isHidden = false
        selectedVersionLabel.text = i18n(string: "Version") + i18n(string: ":") + selectedControllerFirmwareVersion
        releaseDateLabel.isHidden = false
        releaseDateLabel.text = i18n(string: "(") + selectedControllerFirmwareDate + i18n(string: ")")
        releaseNotesLabel.isHidden = false
        releaseNotesLabel.text = selectedControllerFirmwareReleaseNotes
        latestTabLabel.isHidden = selectedControllerFirmwareVersion != latestControllerFirmwareVersion
        
        updateNowButton.isHidden = false
        updatingProgressLabel.isHidden = true
        updatingBgView.isHidden = true
        updatingAlertLabel.isHidden = true
        
        allFirmwareButton.isHidden = false
    }
    
    @IBAction func btnActionUpdate(_ sender: Any) {
        startUpdate()
    }
    
    func startUpdate() {
        if canUpdate {
            eggshellAppDelegate().prepareToUpdateFirmware()
            
            allFirmwareButton.isHidden = true
            isUpdating = true
            updateNowButton.isHidden = true
        }
    }
    
    @IBAction func btnActionShowFirmwareListView(_ sender: Any) {
        allFirmwareButton.isHidden = true
        
        let firmwareListView = FirmwareListView(frame: CGRect(x: 0, y: 0, width: 350, height: 300))
        addSubview(firmwareListView)
        firmwareListView.center = contentView.center
        firmwareListView.currentVersion = currentVersion
        firmwareListView.updateCallback = { firmwareData in
            selectFirmware(data: firmwareData)
            
            self.selectedVersionLabel.text = i18n(string: "Version") + i18n(string: ":") + selectedControllerFirmwareVersion
            self.releaseDateLabel.text = i18n(string: "(") + selectedControllerFirmwareDate + i18n(string: ")")
            self.releaseNotesLabel.text = selectedControllerFirmwareReleaseNotes
            
            self.checkIfNeedUpdate()
            self.startUpdate()
            
            firmwareListView.removeFromSuperview()
        }
        
        firmwareListView.closeCallback = {
            self.allFirmwareButton.isHidden = false
            firmwareListView.removeFromSuperview()
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
    
    func gamepadKeyBAction() {
        appPlaySelectSound()
        backButton2.sendActions(for: .touchUpInside)
    }
    
    @objc func quitCurrentView() {
        backButton2.sendActions(for: .touchUpInside)
    }
    
}

