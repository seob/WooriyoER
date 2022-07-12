//
//  CmpInfo.swift
//  PinPle
//
//  Created by seob on 2020/01/13.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import ObjectMapper

//http://ios.pinpl.biz/ios/m/get_cmp_info.jsp?CMPSID=7
//{
//    addr = "\Uc804\Uc8fc\Uc2dc \Uc644\Uc0b0\Uad6c \Ud6a8\Uc790\Ub3d9";
//    anualapr = 1;
//    anualddctn1 = 0;
//    anualddctn2 = 1;
//    anualddctn3 = 1;
//    applyapr = 1;
//    beacon = "";
//    brktime = 1;
//    cmtarea = 1;
//    cmtnoti = 1;
//    cmtrc = 0;
//    endtm = "18:00:00";
//    enname = administrator;
//    holiday = 1;
//    loclat = "0.0";
//    loclong = "0.0";
//    logo = "http://115.68.182.123/cmplogo/img_logo_default.png";
//    name = "\Ub098\Ub294\Uad00\Ub9ac\Uc790\Ub2e4";
//    phone = 06311112222;
//    schdl = 0;
//    sid = 7;
//    site = "test.com";
//    starttm = "09:00:00";
//    wifiip = "1.212.109.220";
//    wifimac = "88:36:6c:34:d9:60";
//    wifinm = "Wooriyo_KT";
//    wk52h = 1;
//    workday = "2,3,4,5,6";
//}

// MARK: - 회사정보
class CmpInfo: Mappable {
    var sid: Int = 0 //화사번호... 0인경우 해당회사 없음
    var name: String = "" //회사명
    var enname: String = "" //영문 회사명
    var logo: String = "" //회사로고 이미지 URL
    var phone: String = "" //대표전화
    var site: String = "" //회사 사이트 URL
    var addr: String = "" //회사주소
    var cmtarea: Int = 0 //출퇴근영역(0.설정안함 1.WiFi 2.Gps 3.Beacon)
    var wifinm: String = "" //무선랜 이름
    var wifimac: String = "" //무선랜 맥주소
    var wifiip: String = "" //무선랜 IP
    var beacon: String = "" //비콘 UDID
    var loclat: String = "" //위도
    var loclong: String = "" //경도
    var locaddr: String = "" //좌표 주소
    var locscope: Int = 0 //위치범위 50 , 100, 300 , 500
    var cmtrc: Int = 0 //출퇴근 기록설정(0.회사근무시간으로 출퇴근기록  1.자율기록 )
    var cmtnoti: Int = 0 //출퇴근 전 알림설정(0.사용하지않음 1.사용함)
    var schdl: Int = 0 //근무일정 사용 여부(0.사용안함, 1.사용 )
    var starttm: String = "" //출근시간
    var endtm: String = "" //퇴근시간
    var brktime: Int = 0 //휴게시간 설정(0.설정안함 1.설정)
    var workday: String = "" //근무요일
    var holiday: Int = 0 //특별휴무일 설정(0.미설정 1.설정)
    var anualddctn1:Int = 0 //지각 연차차감(0.미차감, 1.차감)
    var anualddctn2:Int = 0 //조회 연차차감(0.미차감, 1.차감)
    var anualddctn3:Int = 0 //외출 연차차감(0.미차감, 1.차감)
    var anualapr:Int = 0 //연차 결재라인 설정(0.미설정 1.설정)
    var applyapr:Int = 0 //근로신청 결재라인 설정(0.미설정 1.설정)
    var wk52h:Int = 0 //주52시간제  설정(0.주단위 1.월단위 )
    // 2020.04.07 변경된 사항이 없을경우는 서버통신 안되도록 수정 seob
    var tmpbrktime = 99
    var tmpstarttm: String = ""
    var tmpendtm: String = ""
    var tmpworkday: String = ""
    var tmpcmtrc: Int = 0
    var tmpschdl: Int = 0
    var tmpCmtlt: Int = 0 
    var tmpcmtarea: Int = 99 //출퇴근영역(0.설정안함 1.WiFi 2.Gps 3.Beacon)
    var point : Int = 0 //pin point 2020.06.10 추가
    var ceoname : String = "" //대표자명 추가 2020.06.10
    // 2021.02.16 추가
    var freetype : Int = 0 //프리요금제(0.사용안함, 1.핀프리 2.펀프리 3.올프리)(2021-01-29 추가)
    var freedt : String = "" //프리요금제 종료일자(2021-01-29 추가)
    var multicmtarea : String = ""//출퇴근영역 복수설정 유효일자(월유료)(2021-01-29 추가)
    var hidebn : String = "" //근로자 배너제거 유효일자(월유료)(2021-01-29 추가)
    var hidebnm : String = "" //관리자 배너제거 유효일자(월유료)(2021-01-29 추가)
    var empcmt : String = "" //증빙용 근로기록 조회 유효일자(월유료)(2021-04-12 추가)
    
    //회계년도 2021-11-03
    var stanualyear: String = "" // 회계년도 기준일자
    var stanual : Int = 0 // 입사일 기준 설정 ( 1 : 입사일 기준 , 0:회계년도 기준 ) deault 1
    var ficalyear: String = "" //회계년도 복수설정 유효일자(월유료)
    
    var stDiaplayAnual : Int = 0 // 근로자 연차 노출 설정 ( 1 : 회사전체 , 0:팀별 ) deault 1
    var displayAualDate: String = "" //근로자 연차 노출 유효일자(월유료)
    
    var datalimits: String = "" // 데이터 보관 유효일자 추가 2021.12.16
    var notice : String = "" //사내공지 종료일자(2022-02-12 추가)
    var cmtlt:Int = 0 //자동퇴근기록 설정 (1. 출근시간으로 자동기록 , 2.회사퇴근시간으로 자동기록, 3.자동 퇴근기록 사용안함 default 1) 2022.01.10 추가
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        name    <- map["name"]
        enname  <- map["enname"]
        logo    <- map["logo"]
        phone   <- map["phone"]
        site    <- map["site"]
        addr    <- map["addr"]
        cmtarea <- map["cmtarea"]
        wifinm    <- map["wifinm"]
        wifimac  <- map["wifimac"]
        wifiip    <- map["wifiip"]
        beacon   <- map["beacon"]
        loclat    <- map["loclat"]
        loclong    <- map["loclong"]
        locaddr    <- map["locaddr"]
        locscope    <- map["locscope"]
        cmtrc <- map["cmtrc"]
        cmtnoti    <- map["cmtnoti"]
        schdl  <- map["schdl"]
        starttm    <- map["starttm"]
        endtm   <- map["endtm"]
        brktime    <- map["brktime"]
        workday    <- map["workday"]
        holiday <- map["holiday"]
        anualddctn1    <- map["anualddctn1"]
        anualddctn2   <- map["anualddctn2"]
        anualddctn3    <- map["anualddctn3"]
        anualapr    <- map["anualapr"]
        applyapr <- map["applyapr"]
        wk52h    <- map["wk52h"]
        point    <- map["point"]
        ceoname    <- map["ceo"]
        freetype    <- map["freetype"]
        freedt    <- map["freedt"]
        multicmtarea    <- map["multicmtarea"]
        hidebn    <- map["hidebn"]
        hidebnm    <- map["hidebnm"]
        empcmt    <- map["empcmt"]
        stanualyear    <- map["stAnualYear"]
        stanual    <- map["stAnual"]
        ficalyear    <- map["ficalyear"]
        datalimits    <- map["datalimits"]
        cmtlt    <- map["cmtLt"]
        notice    <- map["notice"]
        stDiaplayAnual    <- map["stDAnual"]
        displayAualDate    <- map["displayAualDate"]
    }
}
