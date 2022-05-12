//
//  Response.swift
//  PinPle
//
//  Created by seob on 2020/04/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
 /*
 "message":"ok",
 "result": {
     "hash":"GyvykVAu",
     "url":"http://me2.do/GyvykVAu",
     "orgUrl":"http://d2.naver.com/helloworld/4874130"
 }
 ,"code":"200"
 */


//네이버 짧은주소
class NaverShortInfo: Mappable {
    //inapp info---------------------------------------------------------//
    var message: String      = ""
    var code: String     = ""
    var result: NaverResult  = NaverResult()
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        message     <- map["message"]
        code     <- map["code"]
        result     <- map["result"] 
    }
}

class NaverResult: Mappable {
    //inapp info---------------------------------------------------------//
    var hash: String      = ""
    var url: String     = ""
    var orgUrl: String  = ""
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        hash     <- map["hash"]
        url     <- map["url"]
        orgUrl     <- map["orgUrl"]
    }
}

struct Response: Codable { // or Decodable
  let result: Int // 0:실패 , 1:성공
}
 
 
