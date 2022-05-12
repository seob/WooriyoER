//
//  PersonMgr.swift
//  PinPle
//
//  Created by seob on 2020/06/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
import PDFKit

//인사담당자 관리
class PersonInfo: Mappable {
    //Mbr info---------------------------------------------------------//
    var enname : String  = ""//영문이름
    var mbrsid: Int      = 0//회원번호
    var name: String     = ""//이름
    var profimg: String  = ""//사진 URL
    //Emply info-------------------------------------------------------//
    var sid: Int         = 0//직원번호
    var spot: String     = ""//직급(직책)
    var author:Int       = 0//0.인사관리자 1.마스터관리자(대표) 2.최고괄관리자 3.상위팀관리자 4.팀관리자 5.직원
    var notrc:Int        = 0 //출퇴근 기록여부 0.출퇴근기록 1.출퇴근기록하지 않음
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
        author     <- map["author"]
    }
}

//핀플 근로계약서 직원 리스트
class LcEmpList: Mappable {
    //Mbr info---------------------------------------------------------//
    var enname : String  = ""//영문이름
    var mbrsid: Int      = 0//회원번호
    var name: String     = ""//이름
    var profimg: String  = ""//사진 URL
    var status: Int      = 0//근로계약서 상태 0:없음 1:있음
    var regdt: String      = ""//근로계약서 등록일자
    //Emply info-------------------------------------------------------//
    var sid: Int         = 0//직원번호
    var spot: String     = ""//직급(직책)
    //TopTeam, Team info-----------------------------------------------//
    var ttmname:String       = ""//0.인사관리자 1.마스터관리자(대표) 2.최고괄관리자 3.상위팀관리자 4.팀관리자 5.직원
    var temname:String        = "" //출퇴근 기록여부 0.출퇴근기록 1.출퇴근기록하지 않음
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
        status     <- map["status"]
        regdt     <- map["regdt"]
        ttmname     <- map["ttmname"]
        temname     <- map["temname"]
    }
}

// 근로계약서 정보
class LcEmpInfo: Mappable {
    var sid: Int = 0  //번호
    var cmpsid: Int = 0 //회사번호
    var empsid: Int = 0 //직원번호 .. 미합류직원 0
    var profimg: String  = ""//사진 URL
    var name: String = "" //근로자 이름
    var spot: String = "" //근로자 직급
    var birth: String = "" //근로자 생년월일
    var phonenum: String = "" //근로자 폰번호
    var email: String = "" //근로자 이메일
    var addr: String = "" //근로자 주소
    var status: Int = 0 //계약상태 0.미입력 1.계약완료 2.서명요청 3.거절 4.작성중
    var format: Int = 0 //계약서포맷 0.핀플근로계약서 1.표준근로계약서
    var form: Int = 0 //고용형태 0.정규직 1.계약직 2.수습
    var startdt: String = "" //계약 시작일자
    var enddt: String = "" //계약 종료일자
    var paystartdt: String = ""//급여 시작일자
    var payenddt: String = "" //급여 종료일자
    var place: String = "" //근무지
    var task: String = "" //담당업무
    var starttm: String = "" //근무 시작시간
    var endtm: String = "" //근무 종료시간
    var brkstarttm: String = "" //휴게 시작시간
    var brkendtm: String = "" //휴게 종료시간
    var workday: String = "" //근무요일
    var traincntrc:String = "" //수습기간 특약 ..2020-09-02 추가
    var slytype: Int = 0 //급여선택 0.월급 1.연봉 2.시급
    var basepay: Int = 0 //기본급
    var pstnpay: Int = 0 //직책수장
    var ovrtmpay: Int = 0 //연장수당
    var hldypay: Int = 0 //휴일수당
    var bonus: Int = 0//상여금
    var benefits: Int = 0//복지후생
    var otherpay: Int = 0 //기타
    var meals: Int = 0 //식대
    var rsrchsbdy: Int = 0 //연구보조비
    var chldexpns: Int = 0 //자녀보육수당
    var vhclmncst: Int = 0 //차량유지비
    var jobexpns: Int = 0 //일직숙직비
    var hldyalwnc: Int = 0//명절수당
    var hourpay: Int = 0//시급 2020.06.24 추가
    var daypay:Int = 0  //일급 2020.06.24 추가
    var monthpay: Int = 0 //계산된 월급
    var yearpay: Int = 0 //계산된 연봉
    var monthovrtm: Int = 0 //월 연장근로시간
    var addrate: Int = 0 //초과근로 가산입금률
    var payroll: Int = 0 // 임금 지급방법(0.직접지급, 1.통장입금)
    var payday: String = "" // 임금 지급일
    var socialinsrn: String = ""//사회보험
    var anual: String = "" //연차휴가
    var delivery: String = "" //근로계약서 교부
    var other: String = "" //기타사항
    var lcdt: String = "" //계약일
    var sgntrdt: String = "" //근로자 서명 일자
    var regdt: String = "" //작성일자
    var actholder:String = "" //예금주명
    var actbank:String = "" //은행명
    var actnum: String = "" //계좌번호
    
    var workdaylist : [standDayInfo] = []
    var viewpage :String = "" //뷰이동을 위해 추가 
    
    var PrintsImage : UIImage! //계약서 직인있는양식
    var PrintImage : UIImage! //계약서 직인없는양식
    var cslimg: String = "" //회사직인/서명 이미지 경로 정보 추가
    var pdffile: String = "" // png 파일

    //산출근거 추가 2020.07.05
    var basebs: String = "" // 기본급 산출근거
    var cntnsbs: String = "" // 장기근속수당 산출근거
    var pstnbs: String = "" // 직책수당 산출근거
    var hlfybs: String = "" // 휴일수당 산출근거
    var bonusbs: String = "" // 상여금 산출근거
    var benefitisbs: String = "" // 복지후생 산출근거
    var otherbs: String = "" // 기타 산출근거
    var rsrchbs: String = "" // 연구보조비 산출근거
    var chldbs: String = "" // 자녀보육수당 산출근거
    var vhclbs: String = "" // 차량유지비 산출근거
    var jobbs: String = "" // 일직숙직비 산출근거
    var cntnspay: Int = 0 //장기근속수당(2020-07-04 추가)
    
    var cslshape:Int = 0 //회사 직인모양 0.원형 1.사각형
    
    var adjustpay:Int = 0 //조정수당 2020.07.14
    var adjustbs:String = "" //연차수당 산출근거
    var anualpay: Int = 0 // 연차수당 2020.07.14
    var anualbs: String = "" //조정수당 산출근거
    var nightpay: Int = 0 // 야간 수당 2020.07.14
    var nightbs: String = "" //야간 수당 산출근거
    var dayworktime:Int = 0 //핀플 근로계약서 일별근로  0.미사용 1.사용
    var cmpseal: UIImage = UIImage()
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        cmpsid     <- map["cmpsid"]
        empsid     <- map["empsid"]
        profimg     <- map["profimg"]
        name     <- map["name"]
        spot     <- map["spot"]
        birth     <- map["birth"]
        phonenum     <- map["phonenum"]
        email     <- map["email"]
        addr     <- map["addr"]
        status     <- map["status"]
        format     <- map["format"]
        form     <- map["form"]
        startdt     <- map["startdt"]
        enddt     <- map["enddt"]
        traincntrc     <- map["traincntrc"] 
        paystartdt     <- map["paystartdt"]
        payenddt     <- map["payenddt"]
        place     <- map["place"]
        task     <- map["task"]
        starttm     <- map["starttm"]
        endtm     <- map["endtm"]
        brkstarttm     <- map["brkstarttm"]
        brkendtm     <- map["brkendtm"]
        workday     <- map["workday"]
        slytype     <- map["slytype"]
        basepay     <- map["basepay"]
        pstnpay     <- map["pstnpay"]
        ovrtmpay     <- map["ovrtmpay"]
        hldypay     <- map["hldypay"]
        bonus     <- map["bonus"]
        benefits     <- map["benefits"]
        otherpay     <- map["otherpay"]
        meals     <- map["meals"]
        rsrchsbdy     <- map["rsrchsbdy"]
        chldexpns     <- map["chldexpns"]
        vhclmncst     <- map["vhclmncst"]
        jobexpns     <- map["jobexpns"]
        hldyalwnc     <- map["hldyalwnc"]
        hourpay     <- map["hourpay"]
        daypay      <- map["daypay"]
        monthpay     <- map["monthpay"]
        yearpay     <- map["yearpay"]
        monthovrtm     <- map["monthovrtm"]
        addrate     <- map["addrate"]
        payroll   <- map["payroll"]
        payday    <- map["payday"]
        socialinsrn     <- map["socialinsrn"]
        anual     <- map["anual"]
        delivery     <- map["delivery"]
        other     <- map["other"]
        lcdt     <- map["lcdt"]
        sgntrdt     <- map["sgntrdt"]
        regdt     <- map["regdt"]
        actholder  <- map["actholder"]
        actbank  <- map["actbank"]
        actnum  <- map["actnum"]
        workdaylist   <- map["workdaylist"] //표준계약서 3.시급(근로일별) 5.일급(근로일별) 근로일별 근로시간 있는경우..
        cslimg  <- map["cslimg"]
        cslshape <- map["cslshape"] // 2020.07.07 직인 모양 추가
        pdffile  <- map["pdffile"]
        
        
        basebs  <- map["basebs"]// 기본급 산출근거
        cntnsbs  <- map["cntnsbs"]// 장기근속수당 산출근거
        pstnbs <- map["pstnbs"]// 직책수당 산출근거
        hlfybs <- map["hlfybs"]// 휴일수당 산출근거
        bonusbs <- map["bonusbs"]// 상여금 산출근거
        benefitisbs <- map["benefitisbs"] // 복지후생 산출근거
        otherbs <- map["otherbs"]// 기타 산출근거
        rsrchbs <- map["rsrchbs"] // 연구보조비 산출근거
        chldbs <- map["chldbs"]// 자녀보육수당 산출근거
        vhclbs <- map["vhclbs"] // 차량유지비 산출근거
        jobbs <- map["jobbs"] // 일직숙직비 산출근거
        cntnspay <- map["cntnspay"] // 장기근속수당
        
        anualpay <- map["anualpay"] //연차수당
        anualbs <- map["anualbs"] //연차수당 산출근거
        adjustpay <- map["adjustpay"] // 조정수당
        adjustbs <- map["adjustbs"] // 조정수당 산출근거
        nightpay <- map["nightpay"] // 야간 수당
        nightbs <- map["nightbs"] // 야간 수당 산출근거
        
        dayworktime <- map["dayworktime"] // 핀플 근로계약서 일별근로  0.미사용 1.사용
    }
}


// 근로계약서 정보
class cmpSignInfo: Mappable {
    var sid: Int = 0  //직인번호
    var name: String = "" //직인이름
    var sealimg: String = "" //직인파일 경로
    var useflag:  Int = 0 //사용유무 0.미사용 1.사용
    var type : Int = 0 //종류 0.직인 1.서명
    var shape: Int = 0 //직인모양 0.원형 1.사각형
    var ischecked: Bool = false
    var certflag:Int = 0 //증명서 사용유무 0.미사용 1.사용
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        name     <- map["name"]
        sealimg     <- map["sealimg"]
        useflag     <- map["useflag"]
        type     <- map["type"]
        shape     <- map["shape"]
        certflag     <- map["certflag"]
    }
}


// 표준근로계약서 일별 정보
class standDayInfo: Mappable {
    var wdysid: Int = 0  //번호
    var dayweek: Int = 0 //요일 (1.일 2.월 3.화 4.수 5.목 6.금 7.토)
    var starttm: String = "" //근로 시작시간
    var endtm: String = "" //근로 종료시간
    var brkstarttm : String = "" //휴게 시작시간
    var brkendtm : String = "" //휴게 종료시간
    var workmin :  Int = 0 ///근로시간(분)
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        wdysid     <- map["wdysid"]
        dayweek     <- map["dayweek"]
        starttm     <- map["starttm"]
        endtm     <- map["endtm"]
        brkstarttm     <- map["brkstarttm"]
        brkendtm     <- map["brkendtm"]
        workmin     <- map["workmin"]
    }
}


// 연차 일괄 선택
struct MultiConstractDate {
    var wdysid: Int = 0  //번호
    var dayweek: Int = 0 //요일 (1.일 2.월 3.화 4.수 5.목 6.금 7.토)
    var starttm: String = "" //근로 시작시간
    var endtm: String = "" //근로 종료시간
    var brkstarttm : String = "" //휴게 시작시간
    var brkendtm : String = "" //휴게 종료시간
    var workmin :  Int = 0 ///근로시간(분) 
}
