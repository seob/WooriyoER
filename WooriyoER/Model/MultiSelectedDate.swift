//
//  MultiSelectedDate.swift
//  PinPle
//
//  Created by seob on 2020/04/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
// 연차 일괄 선택
struct MultiSelectedDate {
    var aprdt: String = "" //선택된 날짜
    var type: Int = 0 //연차 타입 ["연차", "오전 반차", "오후 반차", "조퇴", "외출", "병가", "공가", "경조", "교육 및 훈련", "포상휴가", "공민권행사", "생리휴가"]
    var ddctn: Int = 0 //0:차감 , 1:미차감
    var subwd:String = "" //요일
    var subsid: Int = 0
    
     
    
    
    init(_ date: String, _ type: Int , _ ddctn: Int, _ subwd:String , _ subsid: Int) {
        self.aprdt = date
        self.type = type
        self.ddctn = ddctn
        self.subwd = subwd
        self.subsid = subsid
        
    }
}
