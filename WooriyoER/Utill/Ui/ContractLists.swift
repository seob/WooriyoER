//
//  Examples.swift
//  PinPle
//
//  Created by seob on 2020/06/30.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation

//enum ContactsUi {
//
//    static var factories: [[(String, ContactFactory)]] {
//        [
//            [
//                ("핀플근로계약서", PinPlCtractView()),
//                ("표준근로계약서(없는거)", DefaultCtract()), //기간없는거
//                ("표준근로게약서(기간있는거)", DefaultCtractTerm()), //기간 있는거
//                ("표준근로계약서(일용)", DefaultCtractDay())
//            ],
//            [
//                ("Experiment", PinPlCtractView()),
//            ]
//        ]
//    }
//}

enum Examples {

    static var factories: [[(String, ExampleFactory)]] {
        [
            [
                ("핀플근로계약서", PinPlCtractView()),
                ("표준근로계약서(없는거)", DefaultCtract()), //기간없는거
                ("표준근로게약서(기간있는거)", DefaultCtractTerm()), //기간 있는거
                ("표준근로계약서(일용)", DefaultCtractDay())
            ],
            [
                ("Experiment", PinPlCtractView()),
            ]
        ]
    }
}




func dateformatKo(_ date:String) -> String {
    let dateStr = date.components(separatedBy: "-")
    let yearText = "\(dateStr[0])년"
    let monthText = "\(dateStr[1])월"
    let dayText = "\(dateStr[2])일"
    
    return yearText + "" + monthText + "" + dayText
}

//시간차 계산
func calTime(_ StrTime: String) -> Int{
    var starttm :Int = 0
    if StrTime != "" {
        let startArr = StrTime.components(separatedBy: ":")
        let selHour: Int  = Int(startArr[0]) ?? 0
        let selMin:Int  = Int(startArr[1]) ?? 0
        starttm = (selHour*60) + selMin
    }else{
        starttm = 0
    }
    
    return starttm
}
//총 근무시간 구하기
func calTotalTime(_ starttm:String,_ endtm:String,_ bkstm:String,_ bketm:String) -> Int {
    var tstarttm:Int = 0
    var tendtm:Int = 0
    var tbkstm:Int = 0
    var tbketm:Int = 0
    tstarttm = starttm != "" ? calTime(starttm.timeTrim()) : 0
    tendtm = endtm != "" ? calTime(endtm.timeTrim()) : 0
    tbkstm = bkstm != "" ? calTime(bkstm.timeTrim()) : 0
    tbketm = bketm != "" ? calTime(bketm.timeTrim()) : 0
    let nDistance:uint = uint((tendtm - tstarttm) - (tbketm - tbkstm))
    return Int(nDistance)
}
//총 휴게시간 구하기
func bkTotalTime(_ bkstm:String,_ bketm:String) -> Int {
    var tbkstm:Int = 0
    var tbketm:Int = 0
    tbkstm = bkstm != "" ? calTime(bkstm.timeTrim()) : 0
    tbketm = bketm != "" ? calTime(bketm.timeTrim()) : 0
    let nDistance:uint = uint((tbketm - tbkstm))
    return Int(nDistance)
}

//시간차 계산
func substringTime(_ StrTime: String) -> String{
    var selHour: Int = 0
    var selMin: Int = 0
    if StrTime != "" {
        let startArr = StrTime.components(separatedBy: ":")
        selHour  = Int(startArr[0]) ?? 0
        selMin  = Int(startArr[1]) ?? 0
    }else{
        selHour = 00
        selMin = 00
    }
    if selMin == 0 {
        return "\(selHour)시 00분"
    }else{
        return "\(selHour)시 \(selMin)분"
    }
}

// 휴무일
func workdayStr(_ str:String , _ type:Int) -> String {
    let workday = str
    let allworkday = "1,2,3,4,5,6,7"
    var selectedArray: Set<String>! //선택한 요일
    var serverArray:Set<String>! //서버 요일
    var strDayTitle:String = ""
    var arrayCnt: [String] = []
    var allarrayCnt: [String] = []
    
    arrayCnt = workday.components(separatedBy: ",")
    arrayCnt = arrayCnt.filter({ !$0.isEmpty })
    
    
    allarrayCnt = allworkday.components(separatedBy: ",")
    allarrayCnt = allarrayCnt.filter({ !$0.isEmpty })
    
    
    selectedArray = Set(arrayCnt) //선택한 요일
    serverArray = Set(allarrayCnt)
    
    selectedArray.sorted()
    serverArray.sorted()
    
    
    let lastIndex = arrayCnt.last
    var nextIndex = 0
    if type == 1 {
        nextIndex = Int(lastIndex ?? "")! + 1
    }else {
        nextIndex = Int(lastIndex ?? "")! + 2
    }
    
    let  noworkday = serverArray.subtracting(selectedArray).sorted() //없는값
    allarrayCnt.append(contentsOf: noworkday)
    
    if (allarrayCnt.contains(String(nextIndex))){
        switch nextIndex {
        case 2:
            strDayTitle = "월요일"
        case 3:
            strDayTitle = "화요일"
        case 4:
            strDayTitle = "수요일"
        case 5:
            strDayTitle = "목요일"
        case 6:
            strDayTitle = "금요일"
        case 7:
            strDayTitle = "토요일"
        case 1:
            strDayTitle = "일요일"
        default:
            break
        }
    }
    
    return strDayTitle
}
//근무일
func workingDay(_ workday: String) -> String {
    var dayArr : [String] = []
    if (workday == "2,3,4,5,6," || workday == "2,3,4,5,6"){
        dayArr.append("주간")
    }else{
        if (workday.contains("1")) { dayArr.append("일") }
        if (workday.contains("2")) { dayArr.append("월") }
        if (workday.contains("3")) { dayArr.append("화") }
        if (workday.contains("4")) { dayArr.append("수") }
        if (workday.contains("5")) { dayArr.append("목") }
        if (workday.contains("6")) { dayArr.append("금") }
        if (workday.contains("7")) { dayArr.append("토") }
    }
    
    let newString = "\(dayArr.joined(separator: "\",\""))"
    return newString
}

//분을 4h 40m 으로 환산
func getMinTohm(_ nDistance: Int) -> String {
    var strbDhm: String = ""
    if (nDistance == 0) {
        strbDhm = "0시간"
    } else {
        var nHour = 0
        var nMin = 0
        nHour = (nDistance) / 60
        nMin = (nDistance) % 60
        
        if (nMin != 0){
            
            strbDhm = "\(nHour)시간 \(nMin)분"
        } else {
            strbDhm = "\(nHour)시간"
        }
    }
    return strbDhm
}

// MARK: - 숫자 콤마
func DecimalWon(value: Int) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let result = numberFormatter.string(from: NSNumber(value: value))!
    
    return result
}

