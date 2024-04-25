//
//  PlatformModel.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/1.
//

import ObjectMapper

/// 游戏平台数据的模型
class PlatformModel: Mappable {

    var id = 0
    var name = ""
    var total_num = 0
//    var logo = ""
//    var packageName = ""
//    var storeUrl = ""
//    var fileSize = ""
//    var downloadUrl = ""
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        total_num <- map["total_num"]
//        logo <- map["platformLogo"]
//        packageName <- map["packageName"]
//        storeUrl <- map["storeUrl"]
//        fileSize <- map["filesize"]
//        downloadUrl <- map["downloadUrl"]
    }
    
    required init?(map: Map) {
        
    }
    
}
