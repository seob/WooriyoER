//
//  TemListInfo.swift
//  PinPle
//
//  Created by seob on 2020/02/19.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 "topteam": [
     {
         "sid": 353,
         "name": "상위팀일까",
         "team": [
             {
                 "temname": "인사팀",
                 "temsid": 8
             }
         ]
     }
 ]
 */
 
struct TemListInfo: Mappable {

var sid: Int           = 0//상위팀번호... 0인경우 해당 상위팀 없음
var name: String       = ""//상위팀명
var team: [TemListInfo2]

init?(map: Map) { team = [] }

mutating func mapping(map: Map) {

    sid     <- map["sid"]
    name     <- map["name"]
    team   = [TemListInfo2(map: map)!] // USING THIS INSTEAD
    }
 }
 
 
class TemListInfo2: Mappable {
 
    var temname: String       = ""//상위팀명
    var temsid: Int =   0
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        temname     <- map["temname"]
        temsid    <- map["temsid"]
    }
}
 
