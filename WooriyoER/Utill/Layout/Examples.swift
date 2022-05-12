//
//  Examples.swift
//  PinPle
//
//  Created by seob on 2020/06/30.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation

enum Examples {
    
    static var factories: [[(String, ExampleFactory)]] {
        [
            [
                ("핀플근로계약서", PinplContract()),
                ("표준근로계약서(없는거)", StdContract()), //기간없는거
                ("표준근로게약서(기간있는거)", StdContract()), //기간 있는거
                ("표준근로계약서(일용)", StdContractDay())
            ],
            [
                ("Experiment", PinplContract()),
            ]
        ]
    }
}

func dateformatKo(_ date:String) -> String {
    let dateStr = date.components(separatedBy: "-")
    let yearText = "\(dateStr[0])년 "
    let monthText = "\(dateStr[1])월 "
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
    print("\n---------- [ workday : \(workday) ] ----------\n")
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
    var nFirst =  0
    var nSecond =  0
    
    var strFirst =  ""
    var strSecond =  ""
    
    let  noworkday = serverArray.subtracting(selectedArray).sorted() //없는값
    var holidayArr: [String] = []
    holidayArr.append(contentsOf: noworkday)
    
    if selectedArray.count == 7 {
        
    }else if selectedArray.count == 6 {
        strSecond = holidayArr[0]
    }else{
        let nLastDay = Int(arrayCnt[arrayCnt.count - 1])
        if (nLastDay! + 1) > 7 {
            
            strFirst = holidayArr[0] //무
            strSecond = holidayArr[1] //유
            
        }else{
            nFirst = nLastDay! + 1
            strFirst = "\(nFirst)"
            if (nFirst + 1) > 7 {
                strSecond = holidayArr[0]
            }else{
                
                let snFirst = "\(nFirst)"
                var nFirstPos = 0
                for i in holidayArr {
                    if snFirst == i {
                        if (nFirst + 1 > Int(holidayArr.last!)!) {
                            print(1)
                            strSecond = holidayArr[0]
                        }else{
                            print(2)
                            strSecond = holidayArr.last!
                        }
                        
                    }
                }
                
                
            }
        }
    }
    
 
    if type == 1 {
        switch strFirst {
        case "2":
            strDayTitle = "월요일"
        case "3":
            strDayTitle = "화요일"
        case "4":
            strDayTitle = "수요일"
        case "5":
            strDayTitle = "목요일"
        case "6":
            strDayTitle = "금요일"
        case "7":
            strDayTitle = "토요일"
        case "1":
            strDayTitle = "일요일"
        default:
            break
        }
    }else{
        switch strSecond {
        case "2":
            strDayTitle = "월요일"
        case "3":
            strDayTitle = "화요일"
        case "4":
            strDayTitle = "수요일"
        case "5":
            strDayTitle = "목요일"
        case "6":
            strDayTitle = "금요일"
        case "7":
            strDayTitle = "토요일"
        case "1":
            strDayTitle = "일요일"
        default:
            break
        }
    }
    
    
    print("\n---------- [ strDayTitle : \(strDayTitle) ] ----------\n")
    
    return strDayTitle
}


//근무일
func workingDay(_ workday: String) -> String {
    var dayArr : String = ""
    if (workday == "2,3,4,5,6," || workday == "2,3,4,5,6"){
        dayArr = "주간"
    }else{
        if (workday.contains("2"))  { dayArr +=  "월,"}
        if (workday.contains("3")) { dayArr += "화,"}
        if (workday.contains("4"))  {dayArr +=  "수,"}
        if (workday.contains("5"))  {dayArr +=  "목,"}
        if (workday.contains("6"))  { dayArr += "금."}
        if (workday.contains("7"))  { dayArr +=  "토,"}
        if (workday.contains("1")) { dayArr += "일"}
    }
    
    // let newString = "\(dayArr.joined(separator: "\",\""))"
    return dayArr
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




//    //시작시간 종료시간 시간차(분)
//    public static long getDiff(String strStartTm, String strEndTm) {
//        long diff = 0;
//        Calendar calStart = Calendar.getInstance();
//        calStart.set(2020, 7, 1, Integer.parseInt(strStartTm.substring(0,2)), Integer.parseInt(strStartTm.substring(3,5)), 0);
//        Calendar calEnd = Calendar.getInstance();
//        calEnd.set(2020, 7, 1, Integer.parseInt(strEndTm.substring(0,2)), Integer.parseInt(strEndTm.substring(3,5)), 0);
//
//        //날짜비교    (calStart > calEnd 인경우 1리턴)
//        if(calStart.compareTo(calEnd) == 1)
//            calEnd.add(Calendar.DATE, 1); //시작시간이 큰 경우 종료시간 + 1일 해줌(음수나오는 것 방지)
//
//        //시간차(밀리세컨드)
//        diff = calEnd.getTimeInMillis() - calStart.getTimeInMillis();
//        //분환산
//        diff = diff / (60*1000);
//
//        return diff;
//
//   }

//func getDiff(_ strStartTm:String, _ strEndTm:String) -> CLong {
//    
//    var diff:CLong = 0;
//    Calendar calStart = Calendar.getInstance();
//    calStart.set(2020, 7, 1, Integer.parseInt(strStartTm.substring(0,2)), Integer.parseInt(strStartTm.substring(3,5)), 0);
//    Calendar calEnd = Calendar.getInstance();
//    calEnd.set(2020, 7, 1, Integer.parseInt(strEndTm.substring(0,2)), Integer.parseInt(strEndTm.substring(3,5)), 0);
//
//    //날짜비교    (calStart > calEnd 인경우 1리턴)
//    if(calStart.compareTo(calEnd) == 1)
//        calEnd.add(Calendar.DATE, 1); //시작시간이 큰 경우 종료시간 + 1일 해줌(음수나오는 것 방지)
//
//    //시간차(밀리세컨드)
//    diff = calEnd.getTimeInMillis() - calStart.getTimeInMillis();
//    //분환산
//    diff = diff / (60*1000);
//    
//    return diff
//}
//
//   //strCheckTm 시작시간 종료시간 사이의 시간인지 체크(true : 범위 안, false : 범위 밖) .. 휴게시간(strCheckTm)이 근로시간 사이의 값인지 체크할때 사용
//   public static boolean getValidTm(String strStartTm, String strEndTm, String strCheckTm) {
//        Calendar calStart = Calendar.getInstance();
//        calStart.set(2020, 7, 1, Integer.parseInt(strStartTm.substring(0,2)), Integer.parseInt(strStartTm.substring(3,5)), 0);
//        Calendar calEnd = Calendar.getInstance();
//        calEnd.set(2020, 7, 1, Integer.parseInt(strEndTm.substring(0,2)), Integer.parseInt(strEndTm.substring(3,5)), 0);
//        Calendar calCheck = Calendar.getInstance();
//        calCheck.set(2020, 7, 1, Integer.parseInt(strCheckTm.substring(0,2)), Integer.parseInt(strCheckTm.substring(3,5)), 0);
//
//        //날짜비교    (calStart > calEnd 인경우 1리턴)
//        if(calStart.compareTo(calEnd) == 1)
//            calEnd.add(Calendar.DATE, 1);
//
//        Boolean bValid = false;
//        if (calStart.before(calCheck) && calEnd.after(calCheck)) {
//             bValid = true;
//        }
//        return bValid;
//   }
//}
