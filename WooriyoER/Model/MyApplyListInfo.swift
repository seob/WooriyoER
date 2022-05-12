//
//  MyApplyListInfo.swift
//  PinPle
//
//  Created by seob on 2020/02/18.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper

// 직원 출장/연장근로신청 내역 리스트
class MyApplyListInfo: Mappable {
   //Apply info-----------------------------------------------------//
 var sid: Int          = 0//근로신청 번호
 var type: Int         = 0//근로신청 종류(0.출장 1.야간근로 2.휴일근로)
 var aprdt: String     = ""//근로신청 일자
 var aprwd: String     = ""//근로신청일자 요일
 var starttm :String   = ""//시작시간
 var endtm: String     = ""//종료시간
 var diffmin: Int      = 0//근로신청기간(분단위) 480이상은 1일(1d)로 표시.. 휴게시간포함되어 1일 540으로 입력되어있음
 var aprstatus: Int    = 0//최종 결재승인상태(0.대기 1.보류 2.승인 3.반려)
 var aprreason: String = ""//보류 반려
   
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        //Apply info-----------------------------------------------------//
        sid     <- map["sid"]
        type     <- map["type"]
        aprdt     <- map["aprdt"]
        aprwd     <- map["aprwd"]
        starttm     <- map["starttm"]
        endtm     <- map["endtm"]
        diffmin    <- map["diffmin"]
        aprstatus     <- map["aprstatus"]
        aprreason     <- map["aprreason"]
    }
}
