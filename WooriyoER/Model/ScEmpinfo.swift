//
//  ScEmpinfo.swift
//  PinPle
//
//  Created by seob on 2021/11/17.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper

//핀플 보안서약서  직원 리스트
class ScEmpList: Mappable {
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

// 보안서약서 정보
class ScEmpInfo: Mappable {
    var sid: Int = 0  //번호
    var cmpsid: Int = 0 //회사번호
    var empsid: Int = 0 //직원번호 .. 미합류직원 0
    var profimg: String  = ""//사진 URL
    var cmpname: String  = ""//수신처
    var name: String = "" //근로자 이름
    var spot: String = "" //근로자 직급
    var birth: String = "" //근로자 생년월일
    var phonenum: String = "" //근로자 폰번호
    var email: String = "" //근로자 이메일
    var addr: String = "" //근로자 주소
    var status: Int = 0 //계약상태 0.미입력 1.계약완료 2.서명요청 3.거절 4.작성중
    var format: Int = 0 //계약서포맷 0.핀플근로계약서 1.표준근로계약서
    var optList : [optScInfo] = []
    var viewpage: String = ""
    var PrintsImage : UIImage! //계약서 직인있는양식
    var PrintImage : UIImage! //계약서 직인없는양식
    var cslimg: String = "" //회사직인/서명 이미지 경로 정보 추가
    var pdffile: String = "" // png 파일
 
    var lcdt: String = "" //계약일
    var sgntrdt: String = "" //근로자 서명 일자
    var regdt: String = "" //작성일자
    
    var cslshape:Int = 0 //회사 직인모양 0.원형 1.사각형
    
  
    var cmpseal: UIImage = UIImage()
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sid     <- map["sid"]
        cmpsid     <- map["cmpsid"]
        empsid     <- map["empsid"]
        profimg     <- map["profimg"]
        cmpname     <- map["cmpName"]         
        name     <- map["name"]
        spot     <- map["spot"]
        birth     <- map["birth"]
        phonenum     <- map["phonenum"]
        email     <- map["email"]
        addr     <- map["addr"]
        status     <- map["status"]
        format     <- map["format"]
        cslimg  <- map["cslimg"]
        cslshape <- map["cslshape"] // 2020.07.07 직인 모양 추가
        pdffile  <- map["pdffile"]
        lcdt     <- map["lcdt"]
        sgntrdt     <- map["sgntrdt"]
        regdt     <- map["regdt"]
        optList   <- map["optList"]
    }
}
 
// 보안서약서 상세조항 정보
class optScInfo: Mappable {
    var odysid: Int = 0  //번호
    var optname: String = "" //내용
    var opttype: Int = 0 //1 본문 , 2 조항
    var optseq: Int = 0 // 순서
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        odysid     <- map["odysid"]
        optname     <- map["optname"]
        opttype     <- map["opttype"]
        optseq     <- map["optseq"]
    }
}

// 연차 일괄 선택
struct MultiScDate {
    var odysid: Int = 0  //번호
    var optname: String = "" //내용
    var opttype: Int = 0 //1 본문 , 2 조항
    var optseq: Int = 0 // 순서
}
