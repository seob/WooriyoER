//
//  CertificateInfo.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper

//재직증명서 직원정보
class Ce_empListInfo: Mappable {
    //Mbr info---------------------------------------------------------//
    var enname : String  = ""//영문이름
    var mbrsid: Int      = 0//회원번호
    var name: String     = ""//이름
    var profimg: String  = ""//사진 URL
    //Emply info-------------------------------------------------------//
    var sid: Int         = 0//직원번호
    var spot: String     = ""//직급(직책)
    var ttmname:String       =  "" //소속(상위팀명).. 없는경우 ''
    var temname:String        =  "" //소속(팀명).. 없는경우 ''
    //CertEmply info-------------------------------------------------//
    var status: Int      = 0//상태 0.미신청 1.신청
    var leave: Int      = 0//퇴직여부(0.재직 1.퇴직) .. 2021-02-10 추가 
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
        ttmname     <- map["ttmname"]
        temname     <- map["temname"]
        status     <- map["status"]
        leave     <- map["leave"]
    }
}

//재직증명서 직원 전체 정보
class Ce_empInfo: Mappable {
    var format:Int = 0//0 재직증명서 , 1:경력증명서
    var sid: Int         = 0//직원번호
    var cmpsid:Int       = 0//회사번호
    var empsid:Int       = 0 //직원번호
    var name: String    = "" //이름
    var dept:String     = "" //소속
    var spot: String     = ""//직급(직책)
    var task: String    = "" //담당업무
    var birth:String    = "" //생년월일
    var phonenum:String    =   "" //연락처
    var addr:String    = "" //주소
    var email:String    = "" //이메일
    var joindt:String    = "" //근무시작일(입사일)
    var isuname:String    = "" //발급자 이름
    var isuspot:String    = "" //발급자 직위
    var cmpname:String    = "" //회사명
    var cmpaddr:String    = "" //회사 주소
    var cmpphone:String    = "" //회사 전화번호
    var cmpceo:String    = "" //회사 대표자
    var cslimg:String    = "" //회사직인 이미지
    var cslshape:String    = "" //회사직인 모양(0.원형 1.사각형)
    var regdt:String    = "" //등록일자
    var status: Int      = 0//상태(0.작성중 1.신청중 2.발급완료)
    var purpose: String  = "" //용도
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        cmpsid     <- map["cmpsid"]
        empsid     <- map["empsid"]
        name     <- map["name"]
        dept     <- map["dept"]
        spot     <- map["spot"]
        task     <- map["task"]
        birth     <- map["birth"]
        addr     <- map["addr"]
        email     <- map["email"]
        joindt     <- map["joindt"]
        isuname     <- map["isuname"]
        isuspot     <- map["isuspot"]
        cmpname     <- map["cmpname"]
        cmpaddr     <- map["cmpaddr"]
        cmpphone     <- map["cmpphone"]
        cmpceo     <- map["cmpceo"]
        cslimg     <- map["cslimg"]
        cslshape     <- map["cslshape"]
        regdt     <- map["regdt"]
        status     <- map["status"]
        phonenum <- map["phonenum"]
        purpose <- map["purpose"]
    }
}

//증명서 발급담당자&삽입로고
class Ce_certiSetinfo: Mappable {
    //증명서 발급 담당자 정보-------------------------------------------------//
    var empsid:Int       = 0 //직원번호
    var name: String    = "" //이름
    var spot: String     = ""//직급(직책)
    var profimg:String    = "" //사진 URL
    //증명서 삽입로고-------------------------------------------------//
    var logo:String    = "" //증명서 삽입로고 URL
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        empsid     <- map["empsid"]
        name     <- map["name"]
        spot     <- map["spot"]
        profimg     <- map["profimg"]
        logo     <- map["logo"]
    }
}

//마스터+인사담당자 목록
class CeMgrList: Mappable {
    //Emply info-------------------------------------------------------//
    var sid:Int       = 0 //직원번호
    var spot: String    = "" //직급
    var author:Int = 0 //1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자
    var notrc:Int = 0 //출퇴근 기록여부 0.출퇴근기록 1.출퇴근기록하지 않음
    //Mbr info---------------------------------------------------------//
    var mbrsid:Int       = 0 //회원번호
    var name: String    = "" //이름
    var enname: String     = ""//영문 이름
    var profimg:String    = "" //사진 URL
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        author     <- map["author"]
        notrc     <- map["notrc"]
        mbrsid     <- map["mbrsid"]
        name     <- map["name"]
        spot     <- map["spot"]
        enname     <- map["enname"]
        profimg     <- map["profimg"]
    }
}

 

//재직증명서 리스트
class CeList: Mappable {
    var sid:Int       = 0 //번호
    var status:Int      = 0 //상태 (2.회사발급, 3.근로자 직접발급)
    var empsid:Int = 0 //직원번호 .. 미합류직원 0
    var name: String    = "" //이름
    var phonenum:String = "" //핸드폰번호
    var email : String  = "" //이메일
    var spot: String     = ""//직급
    var dept:String    = "" //소속
    var pdffile:String    = "" //재직증명서 PDF 파일 경로
    var issuedt:String    = "" //발급일자
    var isuname:String    = "" //발급자 이름
    var isuspot:String    = "" //발급자 직급
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        status     <- map["status"]
        empsid     <- map["empsid"]
        name     <- map["name"]
        phonenum     <- map["phonenum"]
        email     <- map["email"]
        spot     <- map["spot"]
        dept     <- map["dept"]
        pdffile     <- map["pdffile"]
        issuedt     <- map["issuedt"]
        isuname     <- map["isuname"]
        isuspot     <- map["isuspot"]
    }
}
