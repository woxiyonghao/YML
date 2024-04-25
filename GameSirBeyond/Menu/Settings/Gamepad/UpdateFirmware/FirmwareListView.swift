//
//  FirmwareListView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/11/7.
//

import UIKit

class FirmwareListView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: I18nLabel!
    @IBOutlet weak var currentVersionLabel: I18nLabel!
    @IBOutlet weak var closeButton: AnimatedButton!
    @IBOutlet weak var alertLabel: UILabel!
    
    var datas: [[String: Any]] = []
    var currentVersion = "" {
        didSet {
            currentVersionLabel.text = i18n(string: "Current Version") + i18n(string: ":") + currentVersion
            
            datas = controllerFirmwareDatas
            // 固件列表不显示当前版本的固件
            for index in 0..<datas.count {
                let data = datas[index]
                if data["ver"] as! String == currentVersion {
                    datas.remove(at: index)
                    break
                }
            }
            tableView.reloadData()
            
            alertLabel.isHidden = datas.count != 0
        }
    }
    
    var closeCallback = {}
    var updateCallback: (_ data: [String: Any]) -> Void = {data in }
    
    var contentView: UIView!
    func initSubviews() {
        contentView = ((Bundle.main.loadNibNamed("FirmwareListView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        closeButton.tapAction = {
            self.closeCallback()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FirmwareTableViewCell", bundle: .main), forCellReuseIdentifier: NSStringFromClass(FirmwareTableViewCell.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datas.count > indexPath.row {
            let data = datas[indexPath.row]
            var releaseNotes = ""
            if isUsingChinese() {
                releaseNotes = data["upgrade_msg"] as! String
            }
            else {
                releaseNotes = data["upgrade_en_msg"] as! String
            }
//            releaseNotes = "恢复健康大商股份快回家打撒不发货吗三大步伐你妈先擦后方可误工费买不到明年是不发较大说法干撒代发不卡佛挡杀佛金卡戴珊付过款登记说法干哈看啥复合物复合卡基本额看我不呢开挖容纳手机不卡"
            // 计算cell所需高度：74+更新说明的高度
            let releaseNoteHeight = releaseNotes.boundingRect(with: CGSizeMake(350-24*2, CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font: pingFang(size: 12)], context: nil).height+2
            return 65+releaseNoteHeight
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FirmwareTableViewCell.self), for: indexPath) as! FirmwareTableViewCell
        if datas.count > indexPath.row {
            let firmwareData = datas[indexPath.row]
            cell.set(data: firmwareData)
            cell.updateCallback = { firmwareData in
                self.updateCallback(firmwareData)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
