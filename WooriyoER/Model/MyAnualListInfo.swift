//
//  MyAnualListInfo.swift
//  PinPle
//
//  Created by seob on 2020/02/18.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 "aprdt": "2020-02-26",
  "sid": 421,
  "aprreason": "",
  "aprwd": "수",
  "aprstatus": 2,
  "type": 5,
  "diffmin": 550


 */
// 직원 연차 신청 내역
class MyAnualListInfo: Mappable {
   //Anual info-----------------------------------------------------//
 var sid: Int          = 0//연차신청 번호
 var type: Int         = 0//연차종류코드(0.연차 1.오전반차 2.오후반차 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육훈련 9.포상 10.공민권 11.생리)
 var aprdt: String     = ""//연차일자
 var aprwd: String     = ""//연차일자 요일
 var diffmin: Int      = 0//연차기간(분단위) 480이상은 1일(1d)로 표시.. 휴게시간포함되어 1일 540으로 입력되어있음
 var aprstatus: Int    = 0//최종 결재승인상태(0.대기 1.보류 2.승인 3.반려)
 var aprreason: String = ""//보류 반려
    // Multi
    var batchdiff: Int = 0
    var batch:Int = 0

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        //Anual info-----------------------------------------------------//
        sid     <- map["sid"]
        type     <- map["type"]
        aprdt     <- map["aprdt"]
        aprwd     <- map["aprwd"]
        diffmin    <- map["diffmin"]
        aprstatus     <- map["aprstatus"]
        aprreason     <- map["aprreason"]
        //Multi---------------------------------------------------------//
        batchdiff     <- map["batchdiff"]
        batch     <- map["batch"]
    }
}
