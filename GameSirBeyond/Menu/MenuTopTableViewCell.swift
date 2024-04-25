//
//  MenuTopTableViewCell.swift
//  Eggshell
//
//  Created by leslie lee on 2023/2/8.
//

import Foundation

class MenuTopTableViewCell: UITableViewCell {
    enum userClickButton {
        case Capture
        case Settings
        case Message
        case AddFriend
        case EggShellUserProfile
    }
    
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userInfoButton: UIButton!
    @IBOutlet weak var addFriendButton: AnimatedButton!
    @IBOutlet weak var captureButton: AnimatedButton!
    @IBOutlet weak var settingsButton: AnimatedButton!
    @IBOutlet weak var messageButton: AnimatedButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    typealias UserViewClosure = (userClickButton) -> Void
    var clickClosure:UserViewClosure?
    
    var allButtons: [UIButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userInfoButton.setBackgroundImage(UIImage.from(color: .white, size: userInfoButton.frame.size), for: .highlighted)
        addFriendButton.setBackgroundImage(UIImage.from(color: .white, size: addFriendButton.frame.size), for: .highlighted)
        captureButton.setBackgroundImage(UIImage.from(color: .white, size: captureButton.frame.size), for: .highlighted)
        settingsButton.setBackgroundImage(UIImage.from(color: .white, size: settingsButton.frame.size), for: .highlighted)
        messageButton.setBackgroundImage(UIImage.from(color: .white, size: messageButton.frame.size), for: .highlighted)
        let nColor = UIColor.hex("#3A3A3A")
        userInfoButton.setBackgroundImage(UIImage.from(color:nColor, size: userInfoButton.frame.size), for: .normal)
        addFriendButton.setBackgroundImage(UIImage.from(color: nColor, size: addFriendButton.frame.size), for: .normal)
        captureButton.setBackgroundImage(UIImage.from(color: nColor, size: captureButton.frame.size), for: .normal)
        settingsButton.setBackgroundImage(UIImage.from(color: nColor, size: settingsButton.frame.size), for: .normal)
        messageButton.setBackgroundImage(UIImage.from(color: nColor, size: messageButton.frame.size), for: .normal)
        allButtons = [userInfoButton, addFriendButton, captureButton, settingsButton, messageButton]
        
        addFriendButton.tapAction = {
#if !DEBUG
//            if self.clickClosure != nil {
//                self.clickClosure!(userClickButton.AddFriend)
//            }
#else
            print("📢注意：模拟器下禁用此功能")
#endif
        }
        captureButton.tapAction = {
            if self.clickClosure != nil {
                self.clickClosure!(userClickButton.Capture)
            }
        }
        settingsButton.tapAction = {
            if self.clickClosure != nil {
                self.clickClosure!(userClickButton.Settings)
            }
        }
        messageButton.tapAction = {
#if !DEBUG
            if self.clickClosure != nil {
                self.clickClosure!(userClickButton.Message)
            }
#else
            print("📢注意：模拟器下禁用此功能")
#endif
        }
        
        updateUserInfo()
        NotificationCenter.default.addObserver(forName: Notification.Name("UserDidUpdateInfoNotification"), object: nil, queue: .main) { _ in
            self.updateUserInfo()
        }
    }
    
    func updateUserInfo() {
        nicknameLabel.adjustsFontSizeToFitWidth = true
        nicknameLabel.text = "Hi " + getNickname() + "!"
        avatarImageView.sd_setImage(with: URL.init(string: getAvatarPath()))
    }
    
    @IBAction func btnActionUserInfo() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            self.userInfoView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
                self.userInfoView.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { _ in
                if self.clickClosure != nil {
                    self.clickClosure!(userClickButton.EggShellUserProfile)
                }
            }
        }
    }
    
    // MARK: 手柄操控
    func gamepadKeyUpAction() {
        var highlightedButton: UIButton = UIButton()
        for button in allButtons {
            if button.isHighlighted {
                highlightedButton = button
                break
            }
        }
        
        if highlightedButton == userInfoButton {
            appPlayIneffectiveSound()
            return
        }
        else {
            appPlayScrollSound()
            if highlightedButton == captureButton ||
                highlightedButton == messageButton ||
                highlightedButton == settingsButton ||
                highlightedButton == addFriendButton {
                highlight(button: userInfoButton)
            }
            else {
                highlightDefaultButton()
            }
        }
    }
    
    func gamepadKeyDownAction() -> Bool {
        var highlightedButton: UIButton = UIButton()
        for button in allButtons {
            if button.isHighlighted {
                highlightedButton = button
                break
            }
        }
        
        if highlightedButton == captureButton || highlightedButton == settingsButton || highlightedButton == messageButton || highlightedButton == addFriendButton {
            let needSelectFriendCell = true
            highlightedButton.isHighlighted = false
            return needSelectFriendCell
        }
        else {
            appPlayScrollSound()
            if highlightedButton == userInfoButton {
                highlight(button: captureButton)
            }
            else {
                highlightDefaultButton()
            }
        }
        return false
    }
    
    func gamepadKeyLeftAction() {
        var highlightedButton: UIButton = UIButton()
        for button in allButtons {
            if button.isHighlighted {
                highlightedButton = button
                break
            }
        }
        
        if highlightedButton == userInfoButton ||
            highlightedButton == captureButton {
            appPlayIneffectiveSound()
            return
        }
        else {
            appPlayScrollSound()
            if highlightedButton == addFriendButton {
                highlight(button: messageButton)
            }
            else if highlightedButton == messageButton {
                highlight(button: settingsButton)
            }
            else if highlightedButton == settingsButton {
                highlight(button: captureButton)
            }
            else {
                highlightDefaultButton()
            }
        }
    }
    
    func gamepadKeyRightAction() {
        var highlightedButton: UIButton = UIButton()
        for button in allButtons {
            if button.isHighlighted {
                highlightedButton = button
                break
            }
        }
        
        if highlightedButton == addFriendButton ||
            highlightedButton == userInfoButton {
            appPlayIneffectiveSound()
            return
        }
        else {
            appPlayScrollSound()
            if highlightedButton == userInfoButton {
                highlight(button: addFriendButton)
            }
            else if highlightedButton == captureButton {
                highlight(button: settingsButton)
            }
            else if highlightedButton == settingsButton {
                highlight(button: messageButton)
            }
            else if highlightedButton == messageButton {
                highlight(button: addFriendButton)
            }
            else {
                highlightDefaultButton()
            }
        }
    }
    
    func gamepadKeyAAction() {
        for button in allButtons {
            if button.isHighlighted {
                appPlaySelectSound()
                button.sendActions(for: .touchUpInside)
                return
            }
        }
    }
    
    func highlight(button: UIButton) {
        for aButton in allButtons {
            aButton.isHighlighted = false
        }
        
        for aButton in allButtons {
            if aButton == button {
                aButton.isHighlighted = true
                if aButton == userInfoButton {
                    nicknameLabel.textColor = .black
                }
                else {
                    nicknameLabel.textColor = .white
                }
            }
        }
    }
    
    func highlightDefaultButton() {
        userInfoButton.isHighlighted = true
        nicknameLabel.textColor = .black
    }
    
    func highlightCaptureButton() {
        captureButton.isHighlighted = true
    }
}
