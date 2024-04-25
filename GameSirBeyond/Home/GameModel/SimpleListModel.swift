//
//  SimpleListModel.swift
//  GameSirBeyond
//
//  Created by leslie lee on 2024/4/22.
//

import Foundation
import ObjectMapper
class SimpleListModel: Mappable {
    
    var id = 0
    var type = 0 //数据类型 1应用 2资讯 3类别 4精彩瞬间
    var logo = ""
    var name = ""
    var cover_image = ""
    var back_image = ""
    var video_url = ""
    var game_open_param: [[String:Any]] = []
//    {
//    "open_type": 1,    1xbox 2ps 3google 4app store 5geforce 6apple_arcade
//    "jump_url": "1"
//}
    var jump_type = ""
    var jump_url = ""
    var game_name = ""
    var created_time = ""
    var user_nickname = ""
    var is_like = ""
    var total_game_num = ""
    var tag_name = ""
    var tag_colour_type = ""
    var menu_list :[Int] = []
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        logo <- map["logo"]
        name <- map["name"]
        cover_image <- map["cover_image"]
        back_image <- map["back_image"]
        video_url <- map["video_url"]
        game_open_param <- map["game_open_param"]
        jump_type <- map["jump_type"]
        jump_url <- map["jump_url"]
        game_name <- map["game_name"]
        created_time <- map["created_time"]
        user_nickname <- map["user_nickname"]
        is_like <- map["is_like"]
        total_game_num <- map["total_game_num"]
        tag_name <- map["tag_name"]
        tag_name <- map["tag_name"]
        tag_colour_type <- map["tag_colour_type"]
        menu_list <- map["menu_list"]
    }
    
    required init?(map: Map) {
    }
}
