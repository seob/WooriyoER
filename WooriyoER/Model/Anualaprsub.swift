//
//  Anualaprsub.swift
//  PinPle
//
//  Created by seob on 2020/04/01.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 "anualaprsub": [
     {
         "subddctn": 1,
         "subwd": "월",
         "subaprdt": "2020-03-30",
         "subtype": 1,
         "subsid": 10
     },
     {
         "subddctn": 1,
         "subwd": "화",
         "subaprdt": "2020-03-31",
         "subtype": 0,
         "subsid": 11
     }
 ]
 */
class Anualaprsub: Mappable {
    //mbr info
    var subddctn : Int = 0  // 0 :미차감 1: 차감
    var subwd: String = "" //요일
    var subaprdt: String = "" //신청날짜
    var subtype: Int = 0  //연차종류코드(0.연차 1.오전반차 2.오후반차 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육훈련 9.포상 10.공민권 11.생리)
    var subsid : Int = 0 //sid
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        subddctn    <- map["subddctn"]
        subwd       <- map["subwd"]
        subaprdt    <- map["subaprdt"]
        subtype     <- map["subtype"]
        subsid      <- map["subsid"]
    }
}
