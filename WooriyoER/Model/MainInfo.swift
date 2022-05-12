//
//  MbrInfo.swift
//  PinPle_EE
//
//  Created by seob on 2020/01/23.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import ObjectMapper


/*
 anualaprcnt     = 0;
 anualcnt        = 0;
 apraddcnt       = 0;
 aprtripcnt      = 0;
 cmtoffcnt       = 1;
 cmtoncnt        = 0;
 empcnt          = 1;
 tripcnt         = 0;
 */
class MainInfo: Mappable {
 var empcnt      = 0//전체 직원수
 var cmtoncnt    = 0//출근 직원수
 var cmtoffcnt   = 0//미출근 직원수
 var anualcnt    = 0//연차 직원수
 var tripcnt     = 0//출장 직원수
 var anualaprcnt = 0//연차신청 수
 var aprtripcnt  = 0//출장신청 수
 var apraddcnt   = 0//야근,휴일근로신청 수



    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        empcnt <- map["empcnt"]
        cmtoncnt <- map["cmtoncnt"]
        cmtoffcnt <- map["cmtoffcnt"]
        anualcnt <- map["anualcnt"]
        tripcnt <- map["tripcnt"]
        anualaprcnt <- map["anualaprcnt"]
        aprtripcnt <- map["aprtripcnt"]
        apraddcnt <- map["apraddcnt"]
    }
}

