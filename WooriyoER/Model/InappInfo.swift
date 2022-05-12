//
//  InappInfo.swift
//  PinPle
//
//  Created by seob on 2020/06/19.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
 
//인앱 상품 정보
class InappInfo: Mappable {
    //inapp info---------------------------------------------------------//
    var pin: Int      = 0//타입번호
    var name: String     = ""//상품명
    var price: String  = ""//가격
    var product: String = "" // 상품명
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        pin     <- map["pin"]
        name     <- map["name"]
        price     <- map["price"]
        product     <- map["product"]
    }
}
