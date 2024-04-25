//
//  SearchFriendViewCell.swift
//  Eggshell
//
//  Created by leslie lee on 2023/2/13.
//

import Foundation

#if targetEnvironment(simulator)
class SearchFriendViewCell:UITableViewCell {
}
#else
//import NIMSDK
class SearchFriendViewCell:UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var acatarImageView: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var infoLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        bgView.backgroundColor = UIColor.hex("#303030")
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = bgView.frame.size.height/2
    }
    
//    func setUser(user:NIMUser){
//        titleLab.text = user.userInfo?.nickName ?? user.userId
//        infoLab.text = user.userInfo?.sign ?? "game win"
//        acatarImageView.sd_setImage(with: URL(string: user.userInfo?.avatarUrl ?? ""), placeholderImage: UIImage(named: "icon_120"))
//    }
}
#endif
