//
//  AnualInfo.swift
//  PinPle
//
//  Created by WRY_010 on 2020/02/03.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 clearday            = 155;
 empsid              = 24;
 enname              = asdasd;
 joindt              = "2018-07-08";
 mbrsid              = 23;
 name                = "\Uc0ac\Uc6d012";
 profimg             = "http://220.124.142.53/mbrphoto/2020/1/8/oaltest13@test.com_20200108124453.jpg";
 remain              = 1691;
 sid                 = 22;
 spot                = "\Uc0ac\Uc6d0";
 tname               = "\Ud14c\Uc2a4\Ud2b801";
 
 */

class AnualInfo: Mappable {
    //Anual info-----------------------------------------------------//
    var anlsid: Int     = 0//등록번호
    var joindt: String  = ""//입사일자
    var remain: Int     = 0//남은연차(분) .. 앱에서 일/시간/분단위 표시해야 됨
    var clearday: Int   = 0//연차소멸 남은 일수
    //Emply info-------------------------------------------------------//
    var empsid: Int     = 0//직원번호
    var spot: String    = ""//직책/직급
    var tname: String   = ""//소속(무소속 or 팀명  or 상위팀명)
    //Mbr info---------------------------------------------------------//
    var mbrsid: Int     = 0//회원번호
    var name: String    = ""//이름
    var enname: String  = ""//영문 이름
    var profimg: String = ""//사진 URL
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //Anual info-----------------------------------------------------//
        anlsid     <- map["sid"]
        joindt     <- map["joindt"]
        remain     <- map["remain"]
        clearday     <- map["clearday"]
        //Emply info-------------------------------------------------------//
        empsid     <- map["empsid"]
        spot     <- map["spot"]
        tname     <- map["tname"]
        //Mbr info---------------------------------------------------------//
        mbrsid     <- map["mbrsid"]
        name     <- map["name"]
        enname     <- map["enname"]
        profimg     <- map["profimg"]
    }
}

/*
 "aprdt": "2020-01-20",
 "sid": 274,
 "regdt": "2020-01-11",
 "reason": "ㅎㅎㅎ",
 "starttm": "09:00",
 "endtm": "17:00",
 "type": 0,
 "diffmin": 480,
 "spot": "과장",
 "mbrsid": 2,
 "ddctn": 1,
 "aprstatus": 0,
 "name": "이출근",
 "tname": "무소속",
 "profimg": "http://220.124.142.53/mbrphoto/2019/12/18/test@test.com_20191218160401.jpg",
 "empsid": 2,
 "refflag": 0,
 "enname": "Mark"
 
 http://pinpl.wooriyo.com/ios/m/anualapr_list.jsp?EMPSID=139&CURKEY=0&LISTCNT=10
 sObject.put("aprweekday", anualApr.m_strAprDtWeekDay); //연차일자 요일 정보
 sObject.put("aprname", anualApr.m_strAprName); //결재중 결재자 이름
 sObject.put("aprspot", anualApr.m_strAprSpot); //결재중 결재자 직급
 */
// MARK: - 연차 리스트
class AnualListArr: Mappable {
    //AnualApr info-----------------------------------------------------//
    var complete:   Int = 0 //결재대기 구분(0 : 대기 , 1: 완료)
    var sid: Int        = 0//연차신청번호
    var type: Int       = 0//연차종류코드(0.연차 1.오전반차 2.오후반차 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육훈련 9.포상 10.공민권 11.생리)
    var aprdt: String   = ""//연차일자
    var starttm: String = ""//시작시간
    var endtm: String   = ""//종료시간
    var batch:Int       = 0 //일괄신청 구분(0.단일신청, 1.일괄신청)
    var diffmin:Int     = 0//연차기간(분단위) .. 앱에서 일/시간/분단위 표시해야 됨
    var ddctn:Int       = 0//연차차감여부(0.미차감 1.차감)
    var reason:String   = ""//연차사유
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
    var anualaprsub : [Anualaprsub] = []
    var batchdiff:Int = 0 // 멀티일때 총 시간
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
        ddctn     <- map["ddctn"]
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
        anualaprsub <- map["anualaprsub"]
        batchdiff   <- map["batchdiff"]
        batch   <- map["batch"]
        aprweekday   <- map["aprweekday"]
        aprname   <- map["aprname"]
        aprspot   <- map["aprspot"]
    }
}


class TotalAnualInfo: Mappable {
    //Anual info-----------------------------------------------------//
    var anlsid: Int     = 0//등록번호
    var joindt: String  = ""//입사일자
    var remain: Int     = 0//남은연차(분) .. 앱에서 일/시간/분단위 표시해야 됨
    var fical: Int     = 0//남은연차(분) .. 앱에서 일/시간/분단위 표시해야 됨
    var clearday: Int   = 0//연차소멸 남은 일수
    var joinyear: Int   = 0//연차
    //Emply info-------------------------------------------------------//
    var empsid: Int     = 0//직원번호
    var spot: String    = ""//직책/직급
    var tname: String   = ""//소속(무소속 or 팀명  or 상위팀명)
    var ttname:String   = ""//상위팀
    //Mbr info---------------------------------------------------------//
    var mbrsid: Int     = 0//회원번호
    var name: String    = ""//이름
    var enname: String  = ""//영문 이름
    var profimg: String = ""//사진 URL
    
    // Multi
    var batchdiff: Int = 0
    var batch:Int = 0
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //Anual info-----------------------------------------------------//
        anlsid     <- map["sid"]
        joindt     <- map["joindt"]
        remain     <- map["remain"]
        fical     <- map["fical"]
        clearday     <- map["clearday"]
        joinyear    <- map["joinyear"]
        //Emply info-------------------------------------------------------//
        empsid     <- map["empsid"]
        spot     <- map["spot"]
        tname     <- map["temname"]
        ttname     <- map["ttmname"]
        //Mbr info---------------------------------------------------------//
        mbrsid     <- map["mbrsid"]
        name     <- map["name"]
        enname     <- map["enname"]
        profimg     <- map["profimg"]
        //Multi---------------------------------------------------------//
        batchdiff     <- map["batchdiff"]
        batch     <- map["batch"]
    }
}
 
//연차정보 관리 리스트
class anualmgrInfo: Mappable {
    var sid: Int     = 0//번호
    var type: Int  = 0//타입(0.사용연차 1.추가연차)
    var setmin: Int     = 0//변경연차(분)
    var memo: String   = ""//메모
    var regdt: String   = ""//등록,변경일자
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        type     <- map["type"]
        setmin     <- map["setmin"]
        memo     <- map["memo"]
        regdt    <- map["regdt"]
    }
}
 
  
