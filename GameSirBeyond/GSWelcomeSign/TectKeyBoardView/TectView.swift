//
//  TectView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/15.
//

import UIKit

class TectView: UIView {

    let array = [
        "上","下","左","右",
        "X","Y","B","A",
        "L1","L2","R1","R2",
        "更多","截图","首业","三"
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        var coll:UICollectionView!
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 60, height: 30)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.scrollDirection = .vertical
        
        coll = UICollectionView.init(frame: bounds, collectionViewLayout: flowLayout)
        coll.backgroundColor = .clear
        
        coll.showsVerticalScrollIndicator = false
        coll.showsHorizontalScrollIndicator = false
        coll.delegate = self
        coll.dataSource = self
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "item");
        if #available(iOS 10.0, *) {
            // 11.预加载
            coll.isPrefetchingEnabled = true
        }
        coll.contentInset = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        addSubview(coll)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue), object: nil)
//        delay(interval: AntiShakeTime) { [weak self] in
//            guard let `self` = self else {return}
//            NotificationCenter.default.addObserver(self, selector: #selector(pressA), name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue), object: nil)
//        }
extension TectView :UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        cell.backgroundColor = .black
        
        var label = cell.contentView.viewWithTag(888) as? UILabel
        if label == nil {
            label = UILabel()
            label!.textAlignment = .center
            label?.textColor = .white
            label?.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(label!)
            label!.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            label!.tag = 888
        }
        label?.text = array[indexPath.row]
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.tag = 10 + indexPath.row
        if cell.gestureRecognizers == nil {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
            longPress.minimumPressDuration = ScreenshotLongPressBeginTime
            cell.addGestureRecognizer(longPress)
        }
        
        return cell
    }
    
    @objc func longPress(tap:UITapGestureRecognizer){
//        
//        if tap.view?.tag == 23 {
//            if tap.state == .began {
//                print("长按响应开始")
//                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyScreenshotLongPressedBegin.rawValue), object: nil)
//            } else {
//                print("长按响应结束")
//                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyScreenshotLongPressedEnd.rawValue), object: nil)
//            }
//            //print("长按 \(tap.view?.tag)")
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(array[indexPath.row])
        if indexPath.row == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue), object: nil)
            return
        }
        if indexPath.row == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue), object: nil)
            return
        }
        if indexPath.row == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveLeft.rawValue), object: nil)
            return
        }
        if indexPath.row == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveRight.rawValue), object: nil)
            return
        }
        if indexPath.row == 4 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyXPressed.rawValue), object: nil)
            return
        }
        if indexPath.row == 5 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyYPressed.rawValue), object: nil)
            return
        }
        if indexPath.row == 6 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressed.rawValue), object: nil)
            return
        }
        if indexPath.row == 7 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue), object: nil)
            return
        }
        
        if indexPath.row == 13 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyScreenshotPressed.rawValue), object: nil)
            return
        }
        
        if indexPath.row == 14 {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyHomePressed.rawValue), object: nil)
            return
        }
    }
    
}
