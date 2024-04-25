//
//  EditUserInformationView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/23.
//

import UIKit
import Moya
import SwiftyJSON

class EditUserInformationView: UIView, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var closeButton: AnimatedButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var imagePicker: UIImagePickerController?
    var originalNickname = ""
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("EditUserInformationView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        nicknameLabel.text = i18n(string: "Nickname").appending(i18n(string: ":"))
        usernameLabel.text = i18n(string: "Username").appending(i18n(string: ":"))
        nicknameTextField.text = getNickname()
        nicknameTextField.delegate = self
        originalNickname = nicknameTextField.text ?? ""
        usernameTextField.isUserInteractionEnabled = false
        usernameTextField.delegate = self
        usernameTextField.text = getNickname()
        usernameTextField.placeholder = i18n(string: "Nickname")
        
        closeButton.tapAction = {
            self.removeFromSuperview()
        }
        
        delay(interval: 0.2) {
            self.avatarImageView.sd_setImage(with: URL.init(string: getAvatarPath()))
            self.avatarImageView.isUserInteractionEnabled = true
            let tapAvatarGesture = UITapGestureRecognizer(target: self, action: #selector(self.pickAnImage))
            self.avatarImageView.addGestureRecognizer(tapAvatarGesture)
        }
    }
    
    var isShowingImagePickerController = false
    @objc func pickAnImage() {
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.sourceType = .photoLibrary
        viewController()!.present(imagePicker!, animated: true) {
            print("UIImagePickerController: presented")
            self.isShowingImagePickerController = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("error: did not picked a photo")
        }
        
        isShowingImagePickerController = false
        picker.dismiss(animated: true) { [unowned self] in
            self.avatarImageView.image = selectedImage
            self.uploadAvatar(image: selectedImage)
        }
    }
    
    func uploadAvatar(image: UIImage) {
        let networker = MoyaProvider<UserService>()
        networker.request(.uploadAvatar(image: image)) { result in
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 {
                    print("上传头像成功")
                    refreshUserInfo()
                }
                else {
                    print("上传头像失败：", responseData["msg"] as Any)
                }
            }
            case .failure(_): do {
                print("网络错误")
            }
                break
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShowingImagePickerController = false
        picker.dismiss(animated: true) {
            print("UIImagePickerController: dismissed")
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
    
    @IBAction func btnActionSaveChanges() {
        saveNickname()
    }
    
    func saveNickname() {
        let isNicknameNotChanged = originalNickname == nicknameTextField.text
        if isNicknameNotChanged {
            return
        }
        
        if nicknameTextField.text!.lengthOfBytes(using: .utf8) > 30 || nicknameTextField.text!.lengthOfBytes(using: .utf8) < 2 {
            MBProgressHUD.showMsg(in: currentWindow() ?? self, text: i18n(string: "Invalid nickname"))
            nicknameTextField.resignFirstResponder()
            return
        }
        
        // 设置昵称，接口2.7
        let networker = MoyaProvider<UserService>()
        networker.request(.setNickname(name: nicknameTextField.text!)) { result in
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 {
                    print("设置昵称成功")
                    refreshUserInfo()
                }
                else {
                    MBProgressHUD.showMsgWithtext(responseData["msg"] as! String)
                    print("设置昵称失败", responseData["msg"]!)
                }
            }
            case .failure(_): do {
                print("网络错误")
            }
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nicknameTextField {
            nicknameTextField.resignFirstResponder()
            
            saveNickname()
        }
        
        return true
    }
    
    func gamepadKeyBAction() {
        if isShowingImagePickerController {
            imagePicker?.dismiss(animated: true)
            appPlaySelectSound()
            isShowingImagePickerController = false
            return
        }
        
        appPlaySelectSound()
        closeButton.sendActions(for: .touchUpInside)
    }
}
