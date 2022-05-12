//
//  TemInfo.swift
//  PinPle
//
//  Created by WRY_010 on 2020/02/04.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import ObjectMapper

//empcnt = 9;
//mgrcnt = 1;
//name = "\Uc624\Ub300\Uc0b0 \Ud14c\Uc2a4\Ud2b8";
//sid = 308;
//team =             (
//                    {
//        temempcnt = 0;
//        temmgrcnt = 0;
//        temname = "\Ud558\Uc704\Ud300";
//        temsid = 25;
//    }
//);
class Teminfo {

}
// MARK: - 상위팀 리스트
class Ttmlist: Mappable {
    //TopTeam info-------------------------------------------------------//
    var sid: Int           = 0//상위팀 번호
    var name: String       = ""//상위팀 이름
    var mgrcnt: Int        = 0//관리자 수
    var empcnt: Int        = 0//직속팀원 수
    var temlist: [Temlist] = []

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        sid     <- map["sid"]
        name    <- map["name"]
        mgrcnt     <- map["mgrcnt"]
        empcnt    <- map["empcnt"]
        temlist     <- map["team"]
    }
}
// MARK: - 상위팀 팀 해제 추가를 위한 - 하위팀 + 무소속팀 목록
class SubTemlist: Mappable {
    //소속 Team info-------------------------------------------------------//
    var sid: Int           = 0//팀번호
    var ttmsid: Int        = 0//상위팀 번호 .. 현재 소속중인 팀 구분하기 위해.. 소속중인 팀읜 상위팀번호 일치, 무소속은 0
    var name: String       = ""//팀이름


    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        sid     <- map["sid"]
        ttmsid    <- map["ttmsid"]
        name     <- map["name"]
    }
}
// MARK: - 하위팀 리스트
class Temlist: Mappable {
    //소속 Team info-------------------------------------------------------//
    var temsid: Int        = 0//소속팀번호
    var temname: String    = ""//소속팀이름
    var temmgrcnt: Int     = 0//소속팀관리자 수
    var temempcnt: Int     = 0//소속팀 팀원 수

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        temsid     <- map["temsid"]
        temname    <- map["temname"]
        temmgrcnt     <- map["temmgrcnt"]
        temempcnt    <- map["temempcnt"]
    }
}
// MARK: - 팀정보
/*
http://pinpl.wooriyo.com/ios/m/get_ttm_info.jsp?TTMSID=335
{
    anualapr               = 0;
    anuallimit             = 0;
    applyapr               = 0;
    beacon                 = "";
    brktime                = 1;
    cmpsid                 = 1;
    cmtarea                = 4;
    empcnt                 = 4;
    endtm                  = "18:00:00";
    locaddr                = "";
    loclat                 = "0.0";
    loclong                = "0.0";
    memo                   = Sccrf;
    mgrcnt                 = 0;
    name                   = "Rosie I";
    phone                  = 5565;
    schdl                  = 1;
    sid                    = 335;
    starttm                = "09:00:00";
    wifiip                 = "";
    wifimac                = "";
    wifinm                 = "";
    workday                = "2,3,4,5,6";
}
 */
class TemInfo: Mappable {

    var sid: Int           = 0//상위팀번호... 0인경우 해당 상위팀 없음
    var cmpsid: Int        = 0//회사번호
    var name: String       = ""//상위팀명
    var memo: String       = ""//메모
    var phone: String      = ""//전화번호
    var cmtarea: Int       = 0//출퇴근영역 설정(0.설정안함 1.WiFi 2.Gps 3.Beacon  4.회사출퇴근영역이용)
    var wifinm: String     = ""//무선랜 이름
    var wifimac: String    = ""//무선랜 맥주소
    var wifiip: String     = ""//무선랜 IP
    var beacon: String     = ""//비콘 UDID
    var loclat: String     = ""//위도
    var loclong: String    = ""//경도
    var locaddr: String    = ""//좌표 주소
    var schdl: Int         = 0//근무일정 사용 여부(0.사용안함 1.회사일정 2.팀일정)
    var starttm: String    = ""//출근시간
    var endtm: String      = ""//퇴근시간
    var brktime: Int       = 0//휴게시간 설정(0.설정안함 1.설정)
    var workday: String    = ""//근무요일
    var anuallimit: Int    = 0//연차신청제한
    var anualapr: Int      = 0//연차 결재라인 설정(0.회사설정 1.팀자체설정)
    var applyapr: Int      = 0//근로신청 결재라인 설정(0.회사설정 1.팀자체설정)
    var mgrcnt: Int        = 0//관리자 수
    var empcnt: Int        = 0//팀원 수
    var locscope: Int = 0 //위치범위 50 , 100, 300 , 500
    var cmtlt:Int = 0 //자동퇴근기록 설정 (1. 출근시간으로 자동기록 , 2.회사퇴근시간으로 자동기록, 3.자동 퇴근기록 사용안함 default 1) 2022.01.10 추가
    var tmpcmtarea: Int       = 99 
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        sid     <- map["sid"]
        cmpsid    <- map["cmpsid"]
        name     <- map["name"]
        memo    <- map["memo"]
        phone     <- map["phone"]
        cmtarea    <- map["cmtarea"]
        wifinm     <- map["wifinm"]
        wifimac    <- map["wifimac"]
        wifiip     <- map["wifiip"]
        beacon    <- map["beacon"]
        loclat     <- map["loclat"]
        loclong    <- map["loclong"]
        locaddr     <- map["locaddr"]
        schdl    <- map["schdl"]
        starttm     <- map["starttm"]
        endtm    <- map["endtm"]
        brktime     <- map["brktime"]
        workday    <- map["workday"]
        anuallimit     <- map["anuallimit"]
        anualapr    <- map["anualapr"]
        applyapr     <- map["applyapr"]
        mgrcnt    <- map["mgrcnt"]
        empcnt     <- map["empcnt"]
        locscope     <- map["locscope"]
        cmtlt    <- map["cmtLt"] 
    }
}
 
// 팀별 재택 출퇴근 설정직원 info
class HomeCmtAreaInfo: Mappable {
    //HomeCmtArea info-------------------------------------------------//
    var sid: Int           = 0//재택출퇴근영역 번호
    var status: Int        = 0//상태(0.삭제요청중 1.등록) .. 삭제요청중인 경우 버튼 삭제요청 중 으로 표시
    var cmtarea: Int       = 0//출퇴근영역 설정(0.설정안함 1.WiFi 2.Gps 3.Beacon  4.회사출퇴근영역이용)
    var wifinm: String     = ""//무선랜 이름
    var wifimac: String    = ""//무선랜 맥주소
    var wifiip: String     = ""//무선랜 IP
    var beacon: String     = ""//비콘 UDID
    var loclat: String     = ""//위도
    var loclong: String    = ""//경도
    var locaddr: String    = ""//좌표 주소
    var locscope: Int = 0 //위치범위 50 , 100, 300 , 500
    //Mbr info---------------------------------------------------------//
    var name: String       = ""//이름
    var profimg: String    = ""//사진 URL
    var mbrsid: Int        = 0//회원번호
    //Emply info-------------------------------------------------------//
    var empsid: Int        = 0//직원번호
    var spot: String       = ""//직급
    
    var author:Int         = 0//권한
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        sid     <- map["sid"]
        status     <- map["status"]
        cmtarea    <- map["cmtarea"]
        wifinm     <- map["wifinm"]
        wifimac    <- map["wifimac"]
        wifiip     <- map["wifiip"]
        beacon    <- map["beacon"]
        loclat     <- map["loclat"]
        loclong    <- map["loclong"]
        locaddr     <- map["locaddr"]
        locscope     <- map["locscope"]
        
        name     <- map["name"]
        profimg     <- map["profimg"]
        mbrsid     <- map["mbrsid"]
        
        empsid     <- map["empsid"]
        spot     <- map["spot"]
        author     <- map["author"]
    }
}
