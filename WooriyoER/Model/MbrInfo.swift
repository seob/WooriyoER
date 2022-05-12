//
//  MbrInfo.swift
//  PinPle_EE
//
//  Created by seob on 2020/01/23.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import ObjectMapper


/*
 "bcemail": "",
 "cmpsid": 1,
 "sid": 3,
 "birth": "1990-01-20",
 "joindt": "2018-11-20",
 "join": "이메일/카카오",
 "cmpname": "(주)우리요",
 "notrc": 0,
 "empnum": "",
 "spot": "사원",
 "temsid": 0,
 "author": 5,
 "email": "74coolguy@gmail.com",
 "ttmname": "",
 "ttmsid": 0,
 "name": "황형묵",
 "lunar": 1,
 "gender": 0,
 "profimg": "http://220.124.142.53/mbrphoto/img_photo_default.png",
 "empsid": 321,
 "phonenum": "01026549431",
 "temname": "",
 "enname": "elsa"

 */
// MARK: - 회원정보
class MbrInfo: Mappable {
    //mbr info
    var update : Int      = 0//강제 업데이트 설정값(0.권장업데이트 1.강제업데이트)
    var updatemsg: String = ""//업데이트 메세지
    var curver: String    = ""
    var mbrsid: Int       = 0//회원번호
    var email: String     = ""//이메일
    var profimg: String   = API.baseURL//프로필이미지
    var name: String      = ""//이름
    var enname : String   = ""//영문이름
    var bcemail: String   = ""//업무메일
    var gender: Int       = 0//0.남성 1.여성
    var empnum: String    = ""//사원번호
    var birth: String     = ""//생년월일
    var phonenum: String  = ""//핸드폰번호
    var lunar: Int        = 0//0.양력 1.음력
    var regdt: String     = ""
    var pushid: String    = ""//푸시ID
    var cmtsid: Int       = 0// 출근번호
    // 직원 정보
    var empsid: Int       = 0//직원번호
    var cmpsid: Int       = 0//회사번호
    var ttmsid: Int       = 0//상위팀번호
    var temsid: Int       = 0//팀번호
    var author: Int       = 0//권한
    var notrc: Int        = 0//출퇴근기록 제외(0.출퇴근기록 1.출되근기록하지 않음 )..근로자앱에서 1 인 사람은 출근 버튼 선택시 막아야됨
    var spot: String      = ""//직급
    var memo: String      = ""// 메모
    var cmpname: String   = ""//회사이름
    var ttmname: String   = ""//상위팀이름
    var temname: String   = ""//팀이름
    var joindt: String    = ""//입사일(입사일이 '1900-01-01'인경우 입사일 연차정보 입력 페이지 이동)
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        update <- map["update"]
        updatemsg <- map["updatemsg"]
        curver <- map["curver"]
        mbrsid <- map["mbrsid"]
        email <- map["email"]
        profimg <- map["profimg"]
        name <- map["name"]
        enname <- map["enname"]
        bcemail <- map["bcemail"]
        gender <- map["gender"]
        empnum <- map["empnum"]
        birth <- map["birth"]
        lunar <- map["lunar"]
        pushid <- map["pushid"]
        regdt <- map["regdt"]
        phonenum <- map["phonenum"]
        //emp info
        empsid <- map["empsid"]
        cmpsid <- map["cmpsid"]
        ttmsid <- map["ttmsid"]
        temsid <- map["temsid"]
        author <- map["author"]
        notrc <- map["notrc"]
        spot <- map["spot"]
        memo <- map["memo"]
        cmpname <- map["cmpname"]
        ttmname <- map["ttmname"]
        temname <- map["temname"]
        joindt <- map["joindt"]

    }
}
/*
 "bcemail": "",
 "cmpsid": 1,
 "sid": 159,
 "birth": "1998-01-07",
 "memo": "Gg",
 "joindt": "2017-01-21",
 "join": "이메일",
 "cmpname": "(주)우리요",
 "notrc": 0,
 "empnum": "0001",
 "spot": "과장과장과장과장과장",
 "temsid": 0,
 "author": 2,
 "email": "er001@er.er",
 "ttmname": "오대산 테스트",
 "ttmsid": 308,
 "name": "김치라",
 "lunar": 0,
 "gender": 1,
 "profimg": "http://220.124.142.53/mbrphoto/2020/2/3/er001@er.er_20200203170153.jpg",
 "empsid": 139,
 "phonenum": "01088869114",
 "temname": "",
 "enname": "WooRi Choi"
 */
// MARK: - 회원정보 getmbrinfo 탈때만 사용
class getMbrInfo: Mappable {
    //mbr info
    var mbrsid: Int       = 0//회원번호
    var email: String     = ""//이메일
    var profimg: String   = API.baseURL//프로필이미지
    var name: String      = ""//이름
    var enname : String   = ""//영문이름
    var bcemail: String   = ""//업무메일
    var gender: Int       = 0//0.남성 1.여성
    var empnum: String    = ""//사원번호
    var birth: String     = ""//생년월일
    var phonenum: String  = ""//핸드폰번호
    var lunar: Int        = 0//0.양력 1.음력
    // 직원 정보
    var empsid: Int       = 0//직원번호
    var cmpsid: Int       = 0//회사번호
    var ttmsid: Int       = 0//상위팀번호
    var temsid: Int       = 0//팀번호
    var author: Int       = 0//권한
    var notrc: Int        = 0//출퇴근기록 제외(0.출퇴근기록 1.출되근기록하지 않음 )..근로자앱에서 1 인 사람은 출근 버튼 선택시 막아야됨
    var spot: String      = ""//직급
    var memo: String      = ""// 메모
    var cmpname: String   = ""//회사이름
    var ttmname: String   = ""//상위팀이름
    var temname: String   = ""//팀이름
    var joindt: String    = ""//입사일(입사일이 '1900-01-01'인경우 입사일 연차정보 입력 페이지 이동)
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        mbrsid <- map["sid"]
        email <- map["email"]
        profimg <- map["profimg"]
        name <- map["name"]
        enname <- map["enname"]
        bcemail <- map["bcemail"]
        gender <- map["gender"]
        empnum <- map["empnum"]
        birth <- map["birth"]
        lunar <- map["lunar"]
        phonenum <- map["phonenum"]
        //emp info
        empsid <- map["empsid"]
        cmpsid <- map["cmpsid"]
        ttmsid <- map["ttmsid"]
        temsid <- map["temsid"]
        author <- map["author"]
        notrc <- map["notrc"]
        spot <- map["spot"]
        memo <- map["memo"]
        cmpname <- map["cmpname"]
        ttmname <- map["ttmname"]
        temname <- map["temname"]
        joindt <- map["joindt"]   

    }
}
 
