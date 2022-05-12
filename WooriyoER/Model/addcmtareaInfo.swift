//
//  addcmtareaInfo.swift
//  PinPle
//
//  Created by seob on 2021/02/17.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 "addcmtarea": [
     {
         "wifiip": "1.212.109.221",
         "loclat": "0.0",
         "sid": 13,
         "status": 1,
         "wifimac": "88:36:6c:d6:f4:00",
         "name": "test",
         "cmtarea": 1,
         "loclong": "0.0",
         "beacon": "",
         "wifinm": "WooriyoNew",
         "locaddr": ""
     }
 ]
 */
class Addcmtarea: Mappable {
    var sid: Int = 0 //추가 출퇴근영역 번호
    var name : String = ""  // 이름
    var status: Int = 0 //상태(0.사용안함 1.사용)
    var cmtarea: Int = 0  //출퇴근영역(1.WiFi 2.Gps 3.Beacon)
    var wifinm : String = "" //무선랜 이름
    var wifimac: String = "" //무선랜 맥주소
    var wifiip : String = ""  // 무선랜 IP
    var beacon : String = "" //비콘 UDID
    var loclat: String = "" //위도
    var loclong: String = "" //경도
    var locaddr : String = "" //좌표 주소
    var locscope: Int = 0 //위치범위 50 , 100, 300 , 500
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid           <- map["sid"]
        name          <- map["name"]
        status        <- map["status"]
        cmtarea       <- map["cmtarea"]
        wifinm        <- map["wifinm"]
        wifimac       <- map["wifimac"]
        wifiip        <- map["wifiip"]
        beacon        <- map["beacon"]
        loclat        <- map["loclat"]
        loclong       <- map["loclong"]
        locaddr       <- map["locaddr"]
        locscope       <- map["locscope"]
    }
}

