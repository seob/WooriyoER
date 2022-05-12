//
//  Emply.swift
//  PinPle
//
//  Created by seob on 2020/01/14.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import ObjectMapper

//http://pinpl.wooriyo.com/ios/m/cmp_emplist.jsp?CMPSID=156
//{
//    emply =     (
//                {
//            enname = ios;
//            mbrsid = 305;
//            name = "\Ud64d\Uae38\Ub3d9";
//            profimg = "http://220.124.142.53/mbrphoto/2020/1/13/ios11@test.com_20200113163545.jpg";
//            sid = 276;
//            spot = "\Uc0ac\Uc6d0";
//            tname = "\Uac1c\Ubc1c\Ud300";
//        }
//    );
//}

class EmplyInfo: Mappable {
    var enname : String  = ""//영문이름
    var mbrsid: Int      = 0//회원번호
    var name: String     = ""//이름
    var profimg: String  = ""//사진 URL
    var sid: Int         = 0//직원번호
    var spot: String     = ""//직급(직책)
    var tname: String    = ""//팀명
    var author:Int       = 0//1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.상위팀관찰자 5.팀관리자 6.팀관찰자 7.직원
    var usemin : Int = 0
    var addmin: Int = 0 
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        enname     <- map["enname"]
        mbrsid     <- map["mbrsid"]
        name     <- map["name"]
        profimg     <- map["profimg"]
        sid     <- map["sid"]
        spot     <- map["spot"]
        tname     <- map["tname"]
        author     <- map["author"]
    }
}

// MARK: - 미출근 직원(상위팀-직속 출근직원 리스트)
/*
 "workmin": 0,
 "phone": "",
 "memo": "",
 "startdt": "00:00",
 "type": 0,
 "spot": "test",
 "author": 1,
 "mbrsid": 348,
 "name": "최고관리자",
 "profimg": "http://220.124.142.53/mbrphoto/2020/1/20/admin@ios.com_20200120100138.jpg",
 "empsid": 317,
 "enddt": "00:00",
 "phonenum": "01012345678",
 "enname": "kebin" 
 */
class CmtEmplyInfo: Mappable {
    //Commute info-----------------------------------------------------//
    var startdt : String = ""//수정 출근시간
    var enddt: String    = ""//수정 퇴근시간
    var workmin: Int     = 0//수정 근무시간
    var type: Int        = 0//근무타입(0.데이터 없음 1.정상출근 2.지각 3.조퇴 4.야근 5.휴일근로 6.출장 7.외출 8.연차 9.결근)
    var aprtype: Int      = 0//0.연차 1.오전 2.오후 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육 9.포상 10.공민 11.생리
    //Emply info-------------------------------------------------------//
    var empsid: Int      = 0//직원번호
    var author: Int      = 0//직원권한(1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원).. 관리자 구분
    var spot: String     = ""//직책/직급
    var phone:String     = ""//내선번호
    var memo: String     = ""// 메모
    var ttmsid: Int      = 0//상위팀 번호
    var temsid: Int      = 0//하위팀 번호
    //Mbr info---------------------------------------------------------//
    var mbrsid: Int      = 0//회원번호
    var name: String     = ""//이름
    var enname: String   = ""//영문 이름
    var phonenum:String  = ""//핸드폰번호
    var profimg: String  = API.baseURL// 사진 URL
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        startdt     <- map["startdt"]
        enddt     <- map["enddt"]
        workmin     <- map["workmin"]
        type     <- map["type"]
        aprtype  <- map["aprtype"]
        //Emply info-------------------------------------------------------//
        empsid     <- map["empsid"]
        author     <- map["author"]
        spot     <- map["spot"]
        phone     <- map["phone"]
        memo     <- map["memo"]
        ttmsid     <- map["ttmsid"]
        temsid     <- map["temsid"]
        //Mbr info---------------------------------------------------------//
        mbrsid     <- map["mbrsid"]
        name     <- map["name"]
        enname     <- map["enname"]
        phonenum     <- map["phonenum"]
        profimg     <- map["profimg"]
    }
}
// MARK: 출근직원 상세
/*
 "workmin": 0,
 "sid": 0,
 "startdt": "                ",
 "enddt": "                ",
 "dayweek": "수",
 "type": 0,
 "dtday": "01"
 
 */
class EmplyInfoDetail: Mappable {
    var workmin : Int    = 0//수정 근무시간
    var sid: Int         = 0//출퇴근 번호.. 데이터 없는경우 0
    var startdt: String  = ""//수정 출근시간
    var enddt: String    = ""//수정 퇴근시간
    var dayweek : String = ""//요일
    var type: Int        = 0//근무타입(0.데이터 없음 1.정상출근 2.지각 3.조퇴 4.야근 5.휴일근로 6.출장 7.외출 8.연차 9.결근)
    var dtday: String    = ""//날자(일)
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        workmin     <- map["workmin"]
        sid     <- map["sid"]
        startdt     <- map["startdt"]
        enddt     <- map["enddt"]
        dayweek     <- map["dayweek"]
        type     <- map["type"]
        dtday     <- map["dtday"]
    }
}

// MARK: 직원 월별 출퇴근기록 + 연차정보(남은연차, 입사일자)
/*
 "workmin": 0,
 "sid": 0,
 "startdt": "                ",
 "enddt": "                ",
 "dayweek": "수",
 "type": 0,
 "dtday": "01" 
 */
class EmplyInfoDetailList: Mappable {
    var workmin : Int    = 0//수정 근무시간
    var sid: Int         = 0//출퇴근 번호.. 데이터 없는경우 0
    var startdt: String  = ""//수정 출근시간
    var enddt: String    = ""//수정 퇴근시간
    var dayweek : String = ""//요일
    var type: Int        = 0//근무타입(0.데이터 없음 1.정상출근 2.지각 3.조퇴 4.야근 5.휴일근로 6.출장 7.외출 8.연차 9.결근)
    var dtday: String    = ""//날자(일)
    var aprtype: Int  = 0 //연차종류(0.연차 1.오전반차 2.오후반차 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육훈련 9.포상 10.공민권 11.생리).. type(근무타입)이 8일때에만 참조
    var startcmtarea: String    = "" //출근지 출퇴근영역 정보(2021-02-05 추가)
    var endcmtarea: String    = "" //퇴근지 출퇴근영역 정보(2021-02-05 추가)
    var memo: String = "" //메모
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        workmin     <- map["workmin"]
        sid         <- map["sid"]
        startdt     <- map["startdt"]
        enddt       <- map["enddt"]
        dayweek     <- map["dayweek"]
        type        <- map["type"]
        dtday       <- map["dtday"]
        aprtype       <- map["aprtype"]
        startcmtarea       <- map["startcmtarea"]
        endcmtarea       <- map["endcmtarea"]
        memo       <- map["memo"]
    }
}
/*
 "cmpsid": 32,
 "phone": "",
 "memo": "ㅂㅈㄷㄱ쇼ㅓㅜ",
 "joindt": "2020-01-09",
 "usemin": 480,
 "temsid": 39,
 "spot": "사원",
 "mbrsid": 0,
 "addmin": 60,
 "ttmsid": 19,
 "name": "테스트",
 "tname": "개발팀",
 "profimg": "http://115.68.182.123/mbrphoto/img_photo_default.png",
 "empsid": 232,
 "phonenum": "01012345678",
 "enname": "ios"
 */

class EmpInfoList : Mappable {
    var joindt : String  = ""//입사일자
    var usemin: Int      = 0//사용연차
    var addmin: Int      = 0//추가연차
    var stdmin: Int      = 0//기존연차
    var prevyearmin:Int  = 0 //전년도 남은연차 2020.08.11
    var ficalmin:Int     = 0 //회계년도 연차 2021.12.06
    //Emply info-------------------------------------------------------//
    var empsid: Int      = 0//직원번호
    var cmpsid: Int      = 0//회사번호
    var ttmsid: Int      = 0//상위팀번호
    var temsid: Int      = 0//팀번호
    var spot: String     = ""//직급/직책
    var phone: String    = ""//내선번호
    var tname: String    = ""//소속(무소속 or 팀명  or 상위팀명)
    var memo: String     = ""//메모
    //Mbr info-------------------------stdmin--------------------------------//
    var mbrsid: Int      = 0//회원번호
    var name: String     = ""//이름
    var enname: String   = ""//영문 이름
    var phonenum: String = ""//핸드폰번호
    var profimg: String  = ""//사진 URL
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        joindt     <- map["joindt"]
        usemin     <- map["usemin"]
        addmin     <- map["addmin"]
        stdmin     <- map["stdmin"]
        prevyearmin     <- map["prevyearmin"]
        ficalmin    <- map["ficalmin"]
        //Emply info-------------------------------------------------------//
        empsid     <- map["empsid"]
        cmpsid     <- map["cmpsid"]
        ttmsid     <- map["ttmsid"]
        temsid     <- map["temsid"]
        spot     <- map["spot"]
        phone     <- map["phone"]
        tname     <- map["tname"]
        memo     <- map["memo"]
        //Mbr info---------------------------------------------------------//
        mbrsid     <- map["mbrsid"]
        name     <- map["name"]
        enname     <- map["enname"]
        phonenum     <- map["phonenum"]
        profimg     <- map["profimg"]
    }
}



// MARK: 직원 주간, 월간 근로시간 리스트
/*
 empsid               = 141;
 enname               = "";
 maxworkmin           = 11232;
 mbrsid               = 161;
 name                 = "\Uc54c\Uc544\Ub77c";
 profimg              = "http://220.124.142.53/mbrphoto/img_photo_default.png";
 spot                 = "\Ub300\Ub9ac";
 tname                = "\Uc624\Ub300\Uc0b0 \Ud14c\Uc2a4\Ud2b8";
 workmin              = 10846;
 */

class WarningEmpInfo: Mappable {
    //Wk52h info-----------------------------------------------------//
    var workmin: Int     = 0//근로시간(분단위)
    var maxworkmin: Int  = 0//최대 근로시간(분단위)
    //Emply info-------------------------------------------------------//
    var empsid: Int      = 0//직원번호
    var spot: String     = ""//직책/직급
    var tname: String    = ""//소속(무소속 or 팀명  or 상위팀명)
    //Mbr info---------------------------------------------------------//
    var mbrsid: Int      = 0//회원번호
    var name: String     = ""//이름
    var enname: String   = ""//영문 이름
    var profimg: String  = ""//사진 URL
    
    
    var array            = MbrInfo()
    var array2           = EmplyInfo()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //Wk52h info-----------------------------------------------------//
        workmin     <- map["workmin"]
        maxworkmin     <- map["maxworkmin"]
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

// MARK: - 회사 마스터+최고관리자 리스트 - 출퇴근 제외 설정을 위한 목록
class Msmgrlist: Mappable {
    //Emply info-------------------------------------------------------//
    var sid: Int         = 0//직원번호
    var spot: String     = ""//직급(직책)
    var author: Int      = 0//1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자
    var notrc: Int       = 0//출퇴근 기록여부 0.출퇴근기록 1.출퇴근기록하지 않음
    //Mbr info---------------------------------------------------------//
    var mbrsid: Int      = 0//회원번호
    var name: String     = ""//이름
    var enname: String   = ""//영문 이름
    var profimg: String  = API.baseURL//사진 URL
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //Emply info-------------------------------------------------------//
        sid     <- map["sid"]
        spot     <- map["spot"]
        author     <- map["author"]
        notrc     <- map["notrc"]
        //Mbr info---------------------------------------------------------//
        mbrsid     <- map["mbrsid"]
        name     <- map["name"]
        enname     <- map["enname"]
        profimg     <- map["profimg"]
    }
}

