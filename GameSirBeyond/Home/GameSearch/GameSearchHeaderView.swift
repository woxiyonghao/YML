//
//  GameSearchHeaderView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/2.
//

import UIKit

class GameSearchHeaderView: UICollectionReusableView, UITextFieldDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var platformBgView: UIView!
    @IBOutlet weak var platformBgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryLabel: UILabel!// 游戏分类名称，从首页的分类主题进入时显示
    
    var didSearch: (_: String?, _: Int) -> Void = { keyword, platformID in }
    
    var gamePlatforms: [PlatformModel] = []
    var selectedPlatformID = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchBar.searchTextField.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.masksToBounds = true
        searchBar.layer.cornerRadius = searchBar.frame.size.height/2.0
        searchBar.transform = CGAffineTransform(scaleX: 0.875, y: 0.875)// 为了与搜索好友页面的搜索框大小保持一致
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: pingFang(size: 17)
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: i18n(string: "Search game"), attributes: attributes)
        let leftBgView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: searchBar.searchTextField.frame.height))
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: (leftBgView.frame.height - 20)/2.0, width: 20, height: 20))
        leftBgView.addSubview(leftImageView)
        leftImageView.image = UIImage(named: "searchViewSearch")
        leftImageView.contentMode = .scaleAspectFit
        searchBar.searchTextField.leftView = leftBgView
        searchBar.searchTextField.leftViewMode = .always
        searchBar.searchTextField.textColor = .black
        
        gamePlatforms = getGamePlatformModels()
        initPlatforms()
    }
    
    let normalBgColor = UIColor.clear
    let selectedBgColor = UIColor.white
    func initPlatforms() {
        if gamePlatforms.count == 0 {
            return
        }
        
        var lastButtonRight = 0.0
        for index in 0..<gamePlatforms.count {
            let model = gamePlatforms[index]
            
            let platformButton = UIButton(type: .custom)
            platformBgView.addSubview(platformButton)
            platformButton.titleLabel?.font = pingFang(size: 13)
            platformButton.setTitleColor(.white, for: .normal)
            if index == 0 {
                platformButton.backgroundColor = selectedBgColor
                platformButton.setTitleColor(UIColor.hex("#252525"), for: .normal)
            }
            else {
                platformButton.backgroundColor = normalBgColor
                platformButton.setTitleColor(.white, for: .normal)
            }
            platformButton.layer.cornerRadius = 18
            platformButton.layer.masksToBounds = true
            platformButton.tag = 888 + model.id
            platformButton.setTitle(model.name, for: .normal)
            platformButton.addTarget(self, action: #selector(selectPlatform(sender:)), for: .touchUpInside)
            
            let height = 36.0
            let textWidth = platformButton.titleLabel?.text?.boundingRect(with: CGSize(width: CGFLOAT_MAX, height: height), options: .usesLineFragmentOrigin, attributes: [.font: (platformButton.titleLabel?.font)! as UIFont], context: nil)
            var width = (textWidth?.size.width ?? 0)+13.0
            if width < 60.0 { width = 60 }// 最小宽度
            let y = (CGRectGetHeight(platformBgView.frame)-height)/2.0
            var x = 0.0
            if index == 0 {
                x = 8.0
            }
            else {
                x = lastButtonRight + 10.0// 根据上一个按钮的布局来算出x
            }
            platformButton.frame = CGRect(x: x, y: y, width: width, height: height)
            platformButton.setBackgroundImage(UIImage.from(color: .white, size: platformButton.frame.size), for: .highlighted)
            platformButton.setTitleColor(.black, for: .highlighted)
            
            lastButtonRight = CGRectGetMaxX(platformButton.frame)
            
            // 设第一个平台为默认平台
            if index == 0 {
                selectedPlatformID = model.id
            }
        }
        
        platformBgViewWidthConstraint.constant = lastButtonRight + 8
        
//        if lastButtonRight > platformBgViewWidthConstraint.constant {
//            if lastButtonRight+8 > bounds.size.width {
//                platformBgViewWidthConstraint.constant = bounds.size.width
//            }
//            else {
//                platformBgViewWidthConstraint.constant = lastButtonRight + 8
//            }
//        }
    }
    
    @objc func selectPlatform(sender: UIButton) {
        selectedPlatformID = sender.tag-888
        print("选择平台ID：", selectedPlatformID)
        startSearchGame()
        
        for button in platformBgView.subviews {
            if button.isKind(of: UIButton.self) {
                if button == sender {
                    (button as! UIButton).backgroundColor = selectedBgColor
                    (button as! UIButton).setTitleColor(UIColor.hex("#252525"), for: .normal)
                    (button as! UIButton).pressAnimation {}
                }
                else {
                    button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    (button as! UIButton).backgroundColor = normalBgColor
                    (button as! UIButton).setTitleColor(.white, for: .normal)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        startSearchGame()
        endEditing(true)
        return true
    }
    
    var lastSearchKeyword: String = ""
    var lastSearchPlatformID = 0
    func startSearchGame() {
        print("上一个平台ID：", lastSearchPlatformID)
        // 防止重复搜索
        if searchBar.searchTextField.text == lastSearchKeyword &&
            lastSearchPlatformID == selectedPlatformID {
            print("重复搜索，已拦截")
            return
        }
        
        didSearch(searchBar.searchTextField.text, selectedPlatformID)
        
        lastSearchKeyword = searchBar.searchTextField.text ?? ""
        lastSearchPlatformID = selectedPlatformID
    }
    
    // 开始搜索，将会刷新CollectionView，导致textField.endEditing。现象：输入一个字符，键盘立即隐藏
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        print(#function)
//        startSearchGame()
//    }
}
