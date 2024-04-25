//
//  KeySettingView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/10/26.
//

import UIKit

class KeySettingView: UIView {

    @IBOutlet weak var mfiBgView: UIView!
    @IBOutlet weak var mfiTitleLabel: UILabel!
    @IBOutlet weak var mfiModeImageView: UIImageView!
    @IBOutlet weak var mfiSelectedImageView: UIImageView!
    @IBOutlet weak var mfiButton: UIButton!
    
    @IBOutlet weak var switchBgView: UIView!
    @IBOutlet weak var switchTitleLabel: UILabel!
    @IBOutlet weak var switchModeImageView: UIImageView!
    @IBOutlet weak var switchSelectedImageView: UIImageView!
    @IBOutlet weak var switchButton: UIButton!
    
    override var isHidden: Bool {
        didSet {
            if isHidden == false {
                readControllerData()
            }
        }
    }
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("KeySettingView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        observeControllerCommand()
    }
    
    // MARK: 读取手柄数据
    func readControllerData() {
        eggshellAppDelegate().writeCommandReadABXYLayout()
    }
    
    // MARK: 监听手柄指令
    func observeControllerCommand() {
        NotificationCenter.default.addObserver(self, selector: #selector(didGetABXYLayout(notification:)), name: Notification.Name("DidGetABXYLayoutNotification"), object: nil)
    }
    
    @objc func didGetABXYLayout(notification: Notification) {
        let layout = notification.object as? Int
        if layout == 0 {
            MainThread {
                self.changeMFiLayoutUI(selected: true)
                self.changeSwitchLayoutUI(selected: false)
            }
        }
        else if layout == 1 {
            MainThread {
                self.changeMFiLayoutUI(selected: false)
                self.changeSwitchLayoutUI(selected: true)
            }
        }
    }
    
    // MARK: 重置为默认配置
    func resetConfiguration() {
        eggshellAppDelegate().writeCommandSetABXY(layout: .MFi)
        delay(interval: 0.1) {
            if self.isHidden == false {
                self.readControllerData()
            }
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
    
    @IBAction func btnActionSelectMFiMode(sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        sender.isSelected = !sender.isSelected
        switchButton.isSelected = !sender.isSelected
        
        changeMFiLayoutUI(selected: sender.isSelected)
        changeSwitchLayoutUI(selected: !sender.isSelected)
        
        eggshellAppDelegate().writeCommandSetABXY(layout: .MFi)
        delay(interval: 1) {
            eggshellAppDelegate().writeCommandReadABXYLayout()
        }
    }
    
    @IBAction func btnActionSelectSwitchMode(sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        sender.isSelected = !sender.isSelected
        mfiButton.isSelected = !sender.isSelected
        
        changeMFiLayoutUI(selected: !sender.isSelected)
        changeSwitchLayoutUI(selected: sender.isSelected)
        
        eggshellAppDelegate().writeCommandSetABXY(layout: .Switch)
        delay(interval: 1) {
            eggshellAppDelegate().writeCommandReadABXYLayout()
        }
    }
    
    func changeMFiLayoutUI(selected: Bool) {
        if selected {
            mfiBgView.backgroundColor = .white.withAlphaComponent(0.65)
            mfiModeImageView.image = UIImage(named: "abxy_layout_mfi_selected")
            mfiSelectedImageView.isHidden = false
        }
        else {
            mfiBgView.backgroundColor = .white.withAlphaComponent(0.35)
            mfiModeImageView.image = UIImage(named: "abxy_layout_mfi")
            mfiSelectedImageView.isHidden = true
        }
    }
    
    func changeSwitchLayoutUI(selected: Bool) {
        if selected {
            switchBgView.backgroundColor = .white.withAlphaComponent(0.65)
            switchModeImageView.image = UIImage(named: "abxy_layout_switch_selected")
            switchSelectedImageView.isHidden = false
        }
        else {
            switchBgView.backgroundColor = .white.withAlphaComponent(0.35)
            switchModeImageView.image = UIImage(named: "abxy_layout_switch")
            switchSelectedImageView.isHidden = true
        }
    }
}
