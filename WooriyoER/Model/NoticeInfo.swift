//
//  NoticeInfo.swift
//  PinPle
//
//  Created by seob on 2022/01/26.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper

//공지사항 리스트
class NoticeListInfo: Mappable {
    var sid: Int      = 0
    var title: String     = ""
    var regdt: String     = ""
    var content: String     = ""
    var empsid: Int      = 0
    var type: Int      = 0
    var mbrName: String      = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        title     <- map["title"]
        regdt     <- map["regdt"]
        content     <- map["content"]
        empsid     <- map["empsid"]
        type     <- map["type"]
        mbrName     <- map["name"]
    }
}
