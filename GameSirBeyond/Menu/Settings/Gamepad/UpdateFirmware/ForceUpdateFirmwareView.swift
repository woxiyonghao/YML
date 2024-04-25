//
//  ForceUpdateFirmwareView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/11/6.
//

import UIKit

class ForceUpdateFirmwareView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateButton: I18nButton!
    @IBOutlet weak var updatingProgressLabel: I18nLabel!
    @IBOutlet weak var updatingProgressBgView: UIView!
    @IBOutlet weak var updatingBgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var updatingAlertLabel: I18nLabel!
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("ForceUpdateFirmwareView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        updatingProgressLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .medium)// 文字等宽显示，每个文字的显示宽度相同
        observeControllerCommand()
        
        updatingProgressLabel.isHidden = true
        updatingProgressBgView.isHidden = true
        updatingAlertLabel.isHidden = true
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: 监听手柄指令
    func observeControllerCommand() {
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFirmwareProgress(notification:)), name: Notification.Name("DidUpdateFirmwareProgressNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnectController), name: Notification.Name("DidDisconnectControllerNotification"), object: nil)
    }
    
    @objc func didDisconnectController() {
        MainThread {
            self.updatingAlertLabel.text = i18n(string: "The controller has been disconnected, waiting for the controller to reconnect...")
            self.updatingAlertLabel.isHidden = false
            self.updatingProgressLabel.isHidden = true
            self.updatingProgressBgView.isHidden = true
        }
    }
    
     var isUpdating = false
    @objc func didUpdateFirmwareProgress(notification: Notification) {
        isUpdating = true
        
        let progress = notification.object as! CGFloat
        MainThread {
            self.updateButton.isHidden = true
            self.updatingProgressLabel.text = i18n(string: "Upgrading...").appendingFormat("%.1f%%", progress)
            self.updatingBgViewWidthConstraint.constant = 152.0/100.0*progress
            self.updatingProgressLabel.isHidden = false
            self.updatingProgressBgView.isHidden = false
            self.updatingAlertLabel.isHidden = false
            
            if progress >= 100.0 {
                self.finishUpdating()
            }
        }
    }
    
    func finishUpdating() {
        titleLabel.text = i18n(string: "Firmware upgrade successful, please wait for the controller to restart...")
        updatingProgressLabel.isHidden = true
        updatingProgressBgView.isHidden = true
        updatingAlertLabel.isHidden = true
        delay(interval: 2) {
            self.removeFromSuperview()
        }
    }
    
    @IBAction func btnActionUpdate(_ sender: Any) {
        eggshellAppDelegate().forceToUpdateFirmware()
    }
    
    @IBAction func btnActionClose(_ sender: Any) {
        if isUpdating {
            MBProgressHUD.showMsgWithtext(i18n(string: "Upgrading firmware, please wait..."))
            return
        }
        removeFromSuperview()
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
