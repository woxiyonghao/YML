//
//  ESLoadingView.swift
//  Eggshell
//
//  Created by leslie lee on 2022/12/12.
//

final class ESLoadingView: UIView {
    /// 懒加载,提示label
    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .center
       return l
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("CCLoadingView deinit~") }
    
    // MARK: - 初始化器
    init(toast: String) {
        super.init(frame: .zero)
        
        let contentView = UIView()
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = UIColor.hex("#000000", alpha: 0.5)
        addSubview(contentView)
        
        let activity = UIActivityIndicatorView(style: .medium)
        contentView.addSubview(activity)
        
        if !toast.isEmpty {
            // 中间内容视图
            contentView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 120, height: 100))
            }
            
            // 加载转圈视图
            activity.snp.makeConstraints { (make) in
                make.top.equalTo(16)
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: 37, height: 37))
            }
            
            // 文字提示视图
            messageLabel.text = toast
            addSubview(messageLabel)
            messageLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(contentView.snp.bottom)
                make.size.equalTo(CGSize(width: 120, height: 36))
            }
        }else {
            // 中间内容视图
            contentView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 100, height: 100))
            }
            
            // 加载转圈视图
            activity.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }
        activity.startAnimating()
    }
}


