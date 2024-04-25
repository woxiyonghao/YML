//
//  AnimatedButton.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/2/17.
//

import UIKit

class AnimatedButton: I18nButton {

    public var tapAction = {}
    
    // 手动初始化时调用
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        observeAction()
    }
    
    // 在xib中初始化调用
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        observeAction()
    }
    
    private func observeAction() {
        addTarget(self, action: #selector(btnAction), for: .touchUpInside)
    }
    
    @objc private func btnAction() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { _ in
                self.tapAction()
            }
        }
    }
}
