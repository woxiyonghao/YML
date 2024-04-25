//
//  TabTableView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/24.
//

import UIKit

enum SettingsTabDataKey: String {
    case type = "type"
    case icon = "icon"
    case selectedIcon = "selectedIcon"
    case title = "title"
    case number = "number"
}

enum SettingsTabType: String {
    case none = "None"
    case account = "Account"
    case controller = "Controller"
    case button = "Button"
    case joystick = "Joystick"
    case trigger = "Trigger"
}

class TabTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var didSelectRow: (_: Int) -> Void = { row in }
    var focusIndexPath = IndexPath(row: 0, section: 0)
    
    var datas: [[String: String]] = [] {
        didSet {
            reloadData()
            selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabTableViewCell", for: indexPath) as! TabTableViewCell
        if datas.count > indexPath.row {
            let data = datas[indexPath.row]
            cell.data = data
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: focusIndexPath)?.isSelected = false
        tableView.cellForRow(at: indexPath)?.isSelected = true
        
        didSelectRow(indexPath.row)
        focusIndexPath = indexPath
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        clipsToBounds = false
        backgroundColor = .clear
        separatorStyle = .none
        contentInsetAdjustmentBehavior = .never
        //        shouldIgnoreContentInsetAdjustment = true
        automaticallyAdjustsScrollIndicatorInsets = false
        
        register(UINib(nibName: "TabTableViewCell", bundle: .main), forCellReuseIdentifier: "TabTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
