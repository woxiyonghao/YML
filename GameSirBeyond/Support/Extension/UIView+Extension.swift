//
//  UIView+Extension.swift
//  Eggshell
//
//  Created by leslie lee on 2023/2/17.
//

import Foundation
//MARK: - UIView 扩展
public extension UIView {
    /// 切圆角处理操作
   ///
   /// - Parameters:
   ///   - width: UIView 宽度
   ///   - height: UIView 高度
   ///   - corners: UIRectCorner 传递枚举数组 [] 例如： [UIRectCorner.topRight, .topLeft]
   ///   - cornerRadii: CGSize 类型  圆角大小
   func setCorner(width: CGFloat, height: CGFloat, corners: UIRectCorner, cornerRadii: CGSize) {
       self.layoutIfNeeded()
       let maskBezier = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: width, height: height), byRoundingCorners: corners, cornerRadii: cornerRadii)
       let maskLayer = CAShapeLayer.init()
       maskLayer.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
       maskLayer.path = maskBezier.cgPath
       self.layer.mask = maskLayer
   }
    /// 展示loading框(主线程中刷新UI)
    func showLoading(_ message: String = "") {
        // 若当前视图已加载CCLoadingView,则先移除后,再添加;
        if let lastView = subviews.last as? ESLoadingView{ lastView.removeFromSuperview() }
        
        let loadingView = ESLoadingView(toast: message)
        addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 隐藏loading框(主线程中刷新UI)
    func hideLoading() {
        for item in subviews {
            if item.isKind(of: ESLoadingView.self) {
                item.removeFromSuperview()
            }
        }
    }
    

}

