//
//  SearchFriendView.swift
//  Eggshell
//
//  Created by leslie lee on 2023/2/10.
//

import Foundation
import Moya
import SwiftyJSON

#if targetEnvironment(simulator)
class SearchFriendView: UIView {
}
#else


class SearchUser:NSObject{
    var imageUrl:String = ""
    var nickName:String = ""
}

class SearchFriendView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,  UIScrollViewDelegate {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var closeButton: AnimatedButton!
    @IBOutlet weak var tableView: UITableView!
    
    typealias SearchFriendViewClosure = () -> Void
    var closure: SearchFriendViewClosure?
//    var searchArr: [NIMUser] = []
    var searchArr: [Any] = []
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        addBlurEffect(style: .dark, alpha: 1)
        
        contentView = ((Bundle.main.loadNibNamed("SearchFriendView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        closeButton.layer.masksToBounds = true;
        closeButton.layer.cornerRadius = closeButton.frame.size.height/2;
        closeButton.tapAction = {
            self.removeFromSuperview()
        }
        closeButton.setControllerImage(type: .b)
        
        searchView.layer.masksToBounds = true;
        searchView.layer.cornerRadius = searchView.frame.size.height/2;
        textField.delegate = self
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: pingFang(size: 15)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: i18n(string: "Search friend"), attributes: attributes)
        
        initTableView()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender: ))))
        
        delay(interval: 0.01) {
            self.textField.becomeFirstResponder()
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
    
    //点击空白处关闭键盘方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("收回键盘")
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        sender.cancelsTouchesInView = false
    }
    
    // MARK: 初始化
    func initTableView(){
        self.tableView.clipsToBounds = false
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.tableView.contentInsetAdjustmentBehavior = .never
        //        self.tableView.shouldIgnoreContentInsetAdjustment = true
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = nil
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 100;
        self.tableView.register(UINib(nibName: "SearchFriendViewCell", bundle: .main), forCellReuseIdentifier: "SearchFriendViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFriendViewCell", for: indexPath) as! SearchFriendViewCell
//        cell.setUser(user: searchArr[indexPath.row])
//        cell.selectionStyle = .none
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = searchArr[indexPath.row]
//        let request = NIMUserRequest()
//        request.userId = user.userId ?? ""
//        request.operation = .add    //直接添加好友，无需验证
//        NIMSDK.shared().userManager.requestFriend(request){error in
//            MBProgressHUD.showMsg(in: self, text: i18n(string: "Add friend successfully"))
//            if (self.closure != nil){
//                self.closure!()
//            }
//        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let networker = MoyaProvider<UserService>()
        networker.request(.searchUser(keyWord: textField.text ?? "")) { result in
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
                    self.searchArr.removeAll()
                    let dict = responseData["data"] as? Dictionary<String, Any>
                    let arr:[Dictionary<String, Any>] = dict?["result"]  as? [Dictionary<String, Any>] ?? []
                    for userDict in arr{
//                        let accid = userDict["accid"] as? String ?? ""
//                        let user =  NIMSDK.shared().userManager.userInfo(accid)
//                        NIMSDK.shared().userManager.fetchUserInfos([accid]){arr,error  in
//                            
//                        }
//                        if (user != nil){
//                            self.searchArr.append(user!)
//                        }
                    }
                    self.tableView.reloadData()
                }else {
                    print("网络错误", responseData["msg"]!)
                }
            }
            case .failure(_): do {
                print("网络错误")
            }
                break
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.textField.text = ""
    }
    
    func gamepadKeyBAction() {
        closeButton.sendActions(for: .touchUpInside)
        appPlaySelectSound()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
}
#endif
