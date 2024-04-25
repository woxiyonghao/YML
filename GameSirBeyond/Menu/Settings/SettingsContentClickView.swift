//
//  SettingsContentClickView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/23.
//

import UIKit

class SettingsContentClickView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var arrowImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageViewHeightConstraint: NSLayoutConstraint!
    
    let normalWidth = 426
    let normalHeight = 34
    let maxWidth = 469
    let maxHeight = 40
    
    var type: String? = SettingsContentType.none.rawValue
    var isSelected = false
    
    // 点击
    var clickCallback: (_: SettingsContentClickView) -> Void = {_ in }
    // 只选中，不点击
    var selectCallback: (_: SettingsContentClickView) -> Void = {_ in }
    
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("SettingsContentClickView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(gesture:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        if isSelected {
            clickCallback(self)
        }
        else {
            selectCallback(self)
        }
    }
    
    func set(selected: Bool) {
        if selected {
            contentView.backgroundColor = .white
            titleLabel.textColor = .black
            
            self.snp.updateConstraints { make in
                make.width.equalTo(maxWidth)
                make.height.equalTo(maxHeight)
            }
            
            arrowImageViewWidthConstraint.constant = 9
            arrowImageViewHeightConstraint.constant = 15
            isSelected = true
        }
        else {
            contentView.backgroundColor = .white.withAlphaComponent(0.4)
            titleLabel.textColor = .white
            
            self.snp.updateConstraints { make in
                make.width.equalTo(normalWidth)
                make.height.equalTo(normalHeight)
            }
            
            arrowImageViewWidthConstraint.constant = 0
            arrowImageViewHeightConstraint.constant = 0
            isSelected = false
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
}
