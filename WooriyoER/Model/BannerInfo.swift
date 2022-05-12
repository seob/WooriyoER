//
//  BannerInfo.swift
//  PinPle
//
//  Created by seob on 2020/02/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 "sid": 2,
 "link": "https://www.daum.net/",
 "name": "유리상사",
 "img": "http://220.124.142.53/ad/2020/2/banner_1.png"
 
 sObject.put("sid", banner.m_nSid); //일번호
 sObject.put("name", banner.m_strName); //이름
 sObject.put("img", banner.m_strImg); //이미지경로
 sObject.put("link", banner.m_strLink); //링크URL
 */
// MARK: - 배너 리스트 
class BannerList: Mappable {
    //mbr info
    var sid : Int = 0  //일번호
    var link: String = "" //이미지 경로
    var name: String = "" //이름
    var img: String = ""  //링크URL
    var image : UIImage?
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        sid <- map["sid"]
        link <- map["link"]
        name <- map["name"]
        img <- map["img"]
        
    }
}
