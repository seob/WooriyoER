//
//  SuperMgr.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/29.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 author              = 2;
 enname              = Mark;
 mbrsid              = 2;
 name                = "\Uc774\Ucd9c\Uadfc";
 notrc               = 0;
 profimg             = "http://220.124.142.53/mbrphoto/2019/12/18/test@test.com_20191218160401.jpg";
 sid                 = 2;
 spot                = "\Uacfc\Uc7a5";
 */

class SuperMgrInfo: Mappable {
    //Emply info-------------------------------------------------------//
 var sid: Int        = 0//직원번호
 var spot: String    = ""//직급(직책)
 var author: Int     = 0//1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자
 var notrc: Int      = 0//출퇴근 기록여부 0.출퇴근기록 1.출퇴근기록하지 않음
    //Mbr info---------------------------------------------------------//
 var mbrsid: Int     = 0//회원번호
 var name: String    = ""//이름
 var enname: String  = ""//영문 이름
 var profimg: String = ""//사진 URL
//    var profimg: UIImage = UIImage()//사진 URL

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {

        //Emply info-------------------------------------------------------//
        sid     <- map["sid"]
        spot    <- map["spot"]
        author   <- map["author"]
        notrc   <- map["notrc"]

        //Mbr info---------------------------------------------------------//
        mbrsid  <- map["mbrsid"]
        name    <- map["name"]
        enname  <- map["enname"]
        profimg     <- map["profimg"]




    }
}

