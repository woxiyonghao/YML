//
//  FirmwareTableViewCell.swift
//  Eggshell
//
//  Created by 刘富铭 on 2023/11/7.
//

import UIKit

class FirmwareTableViewCell: UITableViewCell {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var latestTabLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var updateCallback: (_ data: [String: Any]) -> Void = {data in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnActionUpdate(_ sender: Any) {
        updateCallback(firmwareData)
    }
    
    var filePath = ""
    var firmwareData: [String: Any] = [:]
    func set(data: [String: Any]) {
        firmwareData = data
        
        latestTabLabel.isHidden = firmwareData["ver"] as! String != latestControllerFirmwareVersion
        filePath = data["path"] as! String
        dateLabel.text = i18n(string: "(") + (firmwareData["upgrade_time"] as! String) + i18n(string: ")")
        versionLabel.text = firmwareData["ver"] as? String
        if isUsingChinese() {
            infoLabel.text = data["upgrade_msg"] as? String
        }
        else {
            infoLabel.text = data["upgrade_en_msg"] as? String
        }
        
//        infoLabel.text = "恢复健康大商股份快回家打撒不发货吗三大步伐你妈先擦后方可误工费买不到明年是不发较大说法干撒代发不卡佛挡杀佛金卡戴珊付过款登记说法干哈看啥复合物复合卡基本额看我不呢开挖容纳手机不卡"
    }
}
