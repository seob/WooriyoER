//
//  HolidayInfo.swift
//  PinPle
//
//  Created by seob on 2020/03/17.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import ObjectMapper

//"sid": 68,
//"holinm": "부처님오신날",
//"rptsetting": 0,
//"holidt": "2020-04-30"

// MARK: - 회사정보
class HolidayInfo: Mappable {
    var sid: Int = 0 //화사번호... 0인경우 해당회사 없음
    var holinm: String = "" //휴무일 이름
    var rptsetting: Int = 0 // 반복 여부 0 : 반복안함 1: 반복
    var holidt: String = "" //날짜
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        holinm    <- map["holinm"]
        rptsetting  <- map["rptsetting"]
        holidt    <- map["holidt"]
        
    }
}
