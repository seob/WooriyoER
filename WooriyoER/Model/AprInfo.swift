//
//  AprInfo.swift
//  PinPle
//
//  Created by WRY_010 on 2020/02/05.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - 결재라인
/*
     "apr3empsid": 0,
 "sid": 41,
 "clearday": 338,
 "ref1name": "최현이",
 "ref1empsid": 235,
 "apr1": 0,
 "apr2": 0,
 "ref1spot": "대표",
 "apr3": 0,
 "ref2": 0,
 "ref1": 0,
 "remainmin": 6780,
 "apr1spot": "이사",
 "apr2empsid": 0,
 "ref2empsid": 0,
 "apr1empsid": 237
 */
class AprInfo: Mappable {
    var sid: Int         = 0//번호 .. 0인경우 현재 저장된 설정정보 없음.. 앱에서 이값을 먼저 체크하고 0보다 큰경우에만 설정정보 세팅
    var apr1empsid: Int  = 0//1차 결재자 직원번호
    var apr1name: String = ""//1차 결재자 이름
    var apr1spot: String = ""//1차 결재자 직급
    var apr2empsid: Int  = 0//2차 결재자 직원번호 ..0인경우 설정된 직원없음
    var apr2name: String = ""//2차 결재자 이름
    var apr2spot: String = ""//2차 결재자 직급
    var apr3empsid: Int  = 0//3차 결재자 직원번호 ..0인경우 설정된 직원없음
    var apr3name: String = "";//3차 결재자 이름
    var apr3spot: String = ""//3차 결재자 직급
    var ref1empsid: Int  = 0//1차 참조자 직원번호 ..0인경우 설정된 직원없음
    var ref1name: String = ""//1차 참조자 이름
    var ref1spot: String = ""//1차 참조자 직급
    var ref2empsid: Int  = 0//2차 참조자 직원번호 ..0인경우 설정된 직원없음
    var ref2name: String = ""//2차 참조자 이름
    var ref2spot: String = ""//2차 참조자 직급
    var remainmin:Int    = 0 //남은연차(분).. 앱에서 일/시간/분으로 변환해서 사용
    var clearday:Int     = 0 //연차갱신 남은일 수
    var apr1:Int    = 0 //1차 결재자 승인상태(0.대기 1.보류 2.승인 3.반려)
    var apr2:Int    = 0 //2차 결재자 승인상태(0.대기 1.보류 2.승인 3.반려)
    var apr3:Int    = 0 //3차 결재자 승인상태(0.대기 1.보류 2.승인 3.반려)
    var ref1:Int    = 0 //1차 참조사 확인상태(0. 미확인 1.확인)
    var ref2:Int    = 0 //2차 참조사 확인상태(0. 미확인 1.확인)
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        apr1empsid    <- map["apr1empsid"]
        apr1name     <- map["apr1name"]
        apr1spot    <- map["apr1spot"]
        apr2empsid    <- map["apr2empsid"]
        apr2name     <- map["apr2name"]
        apr2spot    <- map["apr2spot"]
        apr3empsid    <- map["apr3empsid"]
        apr3name     <- map["apr3name"]
        apr3spot    <- map["apr3spot"]
        ref1empsid    <- map["ref1empsid"]
        ref1name     <- map["ref1name"]
        ref1spot    <- map["ref1spot"]
        ref2empsid    <- map["ref2empsid"]
        ref2name     <- map["ref2name"]
        ref2spot    <- map["ref2spot"]
        remainmin    <- map["remainmin"]
        clearday    <- map["clearday"]
        apr1    <- map["apr1"]
        apr2    <- map["apr2"]
        apr3    <- map["apr3"]
        ref1    <- map["ref1"]
        ref2    <- map["ref2"]
         
    }
}
