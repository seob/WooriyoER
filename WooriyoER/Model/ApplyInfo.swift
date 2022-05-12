//
//  ApplyInfo.swift
//  PinPle
//
//  Created by seob on 2020/02/13.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - 근로신청 결재,참조리스트
class ApplyListArr: Mappable {
   //AnualApr info-----------------------------------------------------//
    var complete:   Int = 0 //결재대기 구분(0 : 대기 , 1: 완료)
    var sid: Int        = 0//근로신청번호
    var type: Int       = 0//신청종류 코드(0.출장 1.야간근로 2.휴일근로)
    var aprdt: String   = ""//근로신청일자
    var starttm: String = ""//시작시간
    var endtm: String   = ""//종료시간
    var diffmin:Int     = 0//기간(분단위) .. 앱에서 일/시간/분단위 표시해야 됨
    var place:String    = ""//출장장소
    var reason:String   = ""//사유
    var aprstatus:Int   = 0//최종 결재승인상태(0.대기 1.보류 2.승인 3.반려)
    var refflag:Int     = 0//참조자 여부(0.결재자 1.참조자).. 앱에서 결재인지 참조인지 구분하기 위해..
    var regdt:String    = ""//등록일자
    //Emply info-------------------------------------------------------//
    var empsid: Int     = 0//직원번호
    var spot: String    = ""//직책/직급
    var tname: String   = ""//소속(무소속 or 팀명  or 상위팀명)
    //Mbr info---------------------------------------------------------//
    var mbrsid: Int     = 0//회원번호
    var name: String    = ""//이름
    var enname: String  = ""//영문 이름
    var profimg: String = ""//사진 URL
    var aprweekday: String     = "" //연차일자 요일 정보
    var aprname: String        = "" //결재중 결재자 이름
    var aprspot: String        = "" //결재중 결재자 이름

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        //Anual info-----------------------------------------------------//
        complete     <- map["complete"]
        sid     <- map["sid"]
        type     <- map["type"]
        aprdt     <- map["aprdt"]
        starttm     <- map["starttm"]
        endtm     <- map["endtm"]
        diffmin     <- map["diffmin"]
        place     <- map["place"]
        reason     <- map["reason"]
        aprstatus     <- map["aprstatus"]
        refflag     <- map["refflag"]
        regdt     <- map["regdt"]
        //Emply info-------------------------------------------------------//
        empsid     <- map["empsid"]
        spot     <- map["spot"]
        tname     <- map["tname"]
        //Mbr info---------------------------------------------------------//
        mbrsid     <- map["mbrsid"]
        name     <- map["name"]
        enname     <- map["enname"]
        profimg     <- map["profimg"]
        aprweekday   <- map["aprweekday"]
        aprname   <- map["aprname"]
        aprspot   <- map["aprspot"]
    }
}

