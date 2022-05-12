//
//  PDFViewer.swift
//  PinPle
//
//  Created by seob on 2020/06/25.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import TPPDF

class PDFViewer: ExampleFactory {
    
    var sid = 0
    var selInfo : LcEmpInfo = LcEmpInfo()
    func getlcsid(_ sid: LcEmpInfo) -> LcEmpInfo {
        let responseData : LcEmpInfo = LcEmpInfo()
        self.selInfo = responseData
        return responseData
    }
      
    func generateDocument() -> [PDFDocument] {
        let document = PDFDocument(format: .a4)
        
        document.layout.space.header = 5
        document.layout.space.footer = 5
        
        let headingStyle1 = document.add(style: PDFTextStyle(name: "Heading 1",
                                                             font: UIFont.systemFont(ofSize: 13.0),
                                                             color: UIColor.black))
        
        let bodyTitleStyle1 = document.add(style: PDFTextStyle(name: "BodyTitle",
                                                               font: UIFont.boldSystemFont(ofSize: 13.0),
                                                               color: UIColor.black))
        
        let bodyStyle2 = document.add(style: PDFTextStyle(name: "Body",
                                                          font: UIFont.systemFont(ofSize: 11.0),
                                                          color: UIColor.black))
         
        
        document.set(.contentCenter, font: UIFont.boldSystemFont(ofSize: 20.0))
        document.set(.contentCenter, textColor: UIColor(red: 0.171875, green: 0.2421875, blue: 0.3125, alpha: 1.0))
        // Add a string using the title style
        document.add(.contentCenter, textObject: PDFSimpleText(text: "근로계약서"))
        
        
        document.add(space: 30.0)
        document.set(font: UIFont.systemFont(ofSize: 15))
        document.set(textColor: UIColor.black)
        let titleStr = "\(CompanyInfo.name)(이하 \"갑\" 이라 한다.)와 \(SelLcEmpInfo.name)(이하 \"을\" 이라 한다.)은(는) 다음과 같이 근로계약을 체결한다."
        document.add(textObject: PDFSimpleText(text: titleStr, style: headingStyle1))
        
        document.add(space: 20)
        
        
        let Str1 = "1. 목적 : \"갑\"은 \"을\"을 정규직으로 임용하기 위해서 본 근로계약서를 작성함"
        document.add(textObject: PDFSimpleText(text: Str1 , style: bodyTitleStyle1))
        document.add(space: 10)
        
        let Str2 = "2. 근로개시일 및 연봉적용일"
        document.add(textObject: PDFSimpleText(text: Str2 , style: bodyTitleStyle1))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str3 = "- \"을\"의 근로개시일 : \(dateformatKo(SelLcEmpInfo.startdt))부터 \(dateformatKo(SelLcEmpInfo.enddt))까지"
        document.add(textObject: PDFSimpleText(text: Str3 , style: bodyStyle2))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str4 = "- \"을\"의 연봉적용일 : \(dateformatKo(SelLcEmpInfo.paystartdt))부터 \(dateformatKo(SelLcEmpInfo.payenddt))까지"
        document.add(textObject: PDFSimpleText(text: Str4 , style: bodyStyle2))
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str5 = "3. 근무지/담당업무 : \(SelLcEmpInfo.place) / \(SelLcEmpInfo.task)"
        document.add(textObject: PDFSimpleText(text: Str5 , style: bodyTitleStyle1))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str5_1 = "- 근무지와 담당업무는 \"갑\"과\"을\"의 논의 하에 변경될 수 있습니다."
        document.add(textObject: PDFSimpleText(text: Str5_1 , style: bodyStyle2))
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str6 = "4. 소정근로시간"
        document.add(textObject: PDFSimpleText(text: Str6 , style: bodyTitleStyle1))
        
        
        var Cellworkmin = 0
        if (SelLcEmpInfo.starttm.timeTrim() != "" && SelLcEmpInfo.endtm.timeTrim() != ""){
            Cellworkmin = self.calTotalTime(SelLcEmpInfo.starttm.timeTrim(), SelLcEmpInfo.endtm.timeTrim(), SelLcEmpInfo.brkstarttm.timeTrim(), SelLcEmpInfo.brkendtm.timeTrim())
        }else{
            Cellworkmin = 0
        }
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str7 = "- 근로시간 : \(substringTime(SelLcEmpInfo.starttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.endtm.timeTrim()))까지 (\(getMinTohm(Int(Cellworkmin.magnitude))))"
        document.add(textObject: PDFSimpleText(text: Str7 , style: bodyStyle2))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        
        let Str8 = "- 근 무 일 : \(workingDay(SelLcEmpInfo.workday).replacingOccurrences(of: "\",", with: ","))"
        document.add(textObject: PDFSimpleText(text: Str8 , style: bodyStyle2))
        
        
        var Cellbkmin = 0
        if (SelLcEmpInfo.brkstarttm.timeTrim() != "" && SelLcEmpInfo.brkendtm.timeTrim() != ""){
            Cellbkmin = self.bkTotalTime(SelLcEmpInfo.brkstarttm.timeTrim(), SelLcEmpInfo.brkendtm.timeTrim())
        }else{
            Cellbkmin = 0
        }
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str9 = "- 휴게시간 : \(substringTime(SelLcEmpInfo.brkstarttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.brkendtm.timeTrim()))까지 (\(getMinTohm(Int(Cellbkmin.magnitude))))"
        document.add(textObject: PDFSimpleText(text: Str9 , style: bodyStyle2))
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str10 = "5. 휴무일"
        document.add(textObject: PDFSimpleText(text: Str10 , style: bodyTitleStyle1))
        
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str11 = "- 주휴일은 매주 \(workdayStr(SelLcEmpInfo.workday, 2)), 「근로자의날제정에관한법률」에 따른 근로자의 날(5월1일)은 유급휴일.\n--  1주간 소정근로일에 개근 시 \(workdayStr(SelLcEmpInfo.workday, 2))을 유급 주휴일로 부여, \(workdayStr(SelLcEmpInfo.workday, 1))은 무급휴무로 부여"
        document.add(textObject: PDFSimpleText(text: Str11 , style: bodyStyle2))
        
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str13 = "6. 임금"
        document.add(textObject: PDFSimpleText(text: Str13 , style: bodyTitleStyle1))
        
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str13_1 = "\(SelLcEmpInfo.payday)"
        document.add(textObject: PDFSimpleText(text: Str13_1 , style: bodyStyle2))
        
        document.add(space: 30)
        document.set(indent: 0, left: true)
        let table = PDFTable(rows: 18, columns: 5)
        
        let style = PDFTableStyleDefaults.none

        // Change standardized styles
        style.footerStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor(red: 247  ,
                              green: 247,
                              blue: 250,
                              alpha: 1.0),
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                      top: PDFLineStyle(type: .full),
                      right: PDFLineStyle(type: .full),
                      bottom: PDFLineStyle(type: .full)),

            font: UIFont.systemFont(ofSize: 10)
            
        )
        
        let totalpay = SelLcEmpInfo.basepay + SelLcEmpInfo.pstnpay + SelLcEmpInfo.ovrtmpay + SelLcEmpInfo.hldypay + SelLcEmpInfo.bonus + SelLcEmpInfo.benefits + SelLcEmpInfo.otherpay + SelLcEmpInfo.meals + SelLcEmpInfo.rsrchsbdy + SelLcEmpInfo.chldexpns + SelLcEmpInfo.vhclmncst + SelLcEmpInfo.jobexpns
        let subTotalPay = SelLcEmpInfo.meals + SelLcEmpInfo.rsrchsbdy + SelLcEmpInfo.chldexpns + SelLcEmpInfo.vhclmncst + SelLcEmpInfo.jobexpns
        
        let hldya = (SelLcEmpInfo.basepay/10)
        table.content = [
            ["월 급여", "구분",   nil ,   nil, "산출근거"],
            [nil,   "기본급(A)", nil , "\(DecimalWon(value: SelLcEmpInfo.basepay))", "주휴수당 포함"],
            [nil,   "직책수당",  nil , "\(DecimalWon(value: SelLcEmpInfo.pstnpay))", "\"을\"의 연봉적용일"],
            [nil,   "연장수당",nil ,"\(DecimalWon(value: SelLcEmpInfo.ovrtmpay))", "{(A)÷209×1.5}×28"],
            [nil,   "휴일수당", nil ,  "\(DecimalWon(value: SelLcEmpInfo.hldypay))", nil],
            [nil,   "상여금", nil ,"\(DecimalWon(value: SelLcEmpInfo.bonus))", nil],
            [nil,   "복지후생", nil ,  "\(DecimalWon(value: SelLcEmpInfo.benefits))", nil],
            [nil,   "기타", nil ,"\(DecimalWon(value: SelLcEmpInfo.otherpay))", nil],
            [nil,   "비과세", "식대" ,"\(DecimalWon(value: SelLcEmpInfo.meals))", "비과세 해당금액 : \(DecimalWon(value: SelLcEmpInfo.meals))원"],
            [nil,   nil, "연구보조비" ,"\(DecimalWon(value: SelLcEmpInfo.rsrchsbdy))", nil],
            [nil,   nil, "자녀보육수당" ,"\(DecimalWon(value: SelLcEmpInfo.chldexpns))", nil],
            [nil,   nil, "차량유지비" ,"\(DecimalWon(value: SelLcEmpInfo.vhclmncst))", nil],
            [nil,   nil, "일직&숙직비" ,"\(DecimalWon(value: SelLcEmpInfo.jobexpns))", nil],
            [nil,   nil, "소계" ,"\(DecimalWon(value: subTotalPay))", nil],
            ["합계(B)",   nil, nil ,"\(DecimalWon(value: totalpay))", nil],
            ["명절수당(C)",   nil, nil ,"\(DecimalWon(value: SelLcEmpInfo.hldyalwnc * 2))", "설,추석 각 \(DecimalWon(value: hldya))원(기본금의 10%)"],
            ["총 연봉급여[{(B)*12개월}+(C)]",   nil, nil  ,"\(DecimalWon(value: SelLcEmpInfo.yearpay))", nil],
            ["지급계좌",   "예금주명: \(SelLcEmpInfo.actholder)", nil ,"계좌번호:\(SelLcEmpInfo.actnum)", "금융기관명 :\(SelLcEmpInfo.actbank)"]
        ]
        table.rows.allRowsAlignment = [.center, .center, .center, .center , .center]
        
        table.columns.allCellsAlignment = .center
        
        table.widths = [0.2, 0.2 , 0.1, 0.2, 0.3]
        table.margin = 0
        table.padding = 5
        table.showHeadersOnEveryPage = false
        table.style.columnHeaderCount = 1
        
        
        for i in 1..<8 {
            table[rows: i, columns: 1..<3].merge()
        }
        
        table[rows: 0, columns: 1..<4].merge()
        
        table[rows: 0..<14, column: 0].merge()
        
        
        table[rows: 8..<14, column: 1].merge()
        
        table[rows: 14, columns: 0..<3].merge()
        table[rows: 15, columns: 0..<3].merge()
        table[rows: 16, columns: 0..<3].merge()
        table[rows: 16, columns: 3...4].merge()
        table[rows: 17, columns: 1...2].merge()
        document.add(table: table)
        
        
        if SelLcEmpInfo.socialinsrn != "" {
            document.add(space: 30)
            document.set(indent: 0, left: true)
            var strSocial = ""
            if SelLcEmpInfo.socialinsrn.contains("1") {
                strSocial += "국민연금"
            }
            
            if SelLcEmpInfo.socialinsrn.contains("2") {
                strSocial += " 건강보험"
            }
            
            if SelLcEmpInfo.socialinsrn.contains("3") {
                strSocial += " 고용보험"
            }
            
            if SelLcEmpInfo.socialinsrn.contains("4") {
                strSocial += " 산재보험"
            }

            let Str14 = "7. 사회보험 가입 : \(strSocial)"
            document.add(textObject: PDFSimpleText(text: Str14 , style: bodyTitleStyle1))
        }
        
        if SelLcEmpInfo.anual != "" {
            document.add(space: 10)
            let Str15 = "8. 연차유급휴가 : \(SelLcEmpInfo.anual)"
            document.add(textObject: PDFSimpleText(text: Str15 , style: bodyTitleStyle1))
        }
        
         if SelLcEmpInfo.delivery != "" {
            document.add(space: 10)
            let Str16 = "9. 근로계약서 교부"
            document.add(textObject: PDFSimpleText(text: Str16 , style: bodyTitleStyle1))
            
            document.add(space: 10)
            document.set(indent: 20, left: true)
            let Str16_1 = "\(SelLcEmpInfo.delivery)"
            document.add(textObject: PDFSimpleText(text: Str16_1 , style: bodyStyle2))
        }
 
        
        if SelLcEmpInfo.other != "" {
            document.add(space: 10)
            document.set(indent: 0, left: true)
            let Str17 = "10. 기타사항"
            document.add(textObject: PDFSimpleText(text: Str17 , style: bodyTitleStyle1))
            
            
            document.add(space: 10)
            document.set(indent: 20, left: true)
            let Str17_1 = "\(SelLcEmpInfo.other)"
            document.add(textObject: PDFSimpleText(text: Str17_1 , style: bodyStyle2))
        }
        
        document.add(space: 150)
        document.set(.contentCenter, font: UIFont.boldSystemFont(ofSize: 15.0))
        document.set(.contentCenter, textColor: UIColor(red: 0.171875, green: 0.2421875, blue: 0.3125, alpha: 1.0))
        // Add a string using the title style
        document.add(.contentCenter, textObject: PDFSimpleText(text: "\(dateformatKo(SelLcEmpInfo.lcdt))"))
        
        document.add(space: 50)
        document.set(indent: 0, left: true)
        
        let section = PDFSection(columnWidths: [0.45,0.10, 0.45])
        
        section.columns[0].add(textObject: PDFSimpleText(text: "\"갑\"" , style: bodyStyle2))
        section.columns[0].add(textObject: PDFSimpleText(text: "\n주소 : \(CompanyInfo.addr)" , style: bodyStyle2))
        section.columns[0].add(textObject: PDFSimpleText(text: "회사명 : \(CompanyInfo.name)" , style: bodyStyle2))
        section.columns[0].add(textObject: PDFSimpleText(text: "연락처 : \(CompanyInfo.phone)" , style: bodyStyle2))
        section.columns[0].add(textObject: PDFSimpleText(text: "대 표 : \(CompanyInfo.ceoname)" , style: bodyStyle2))
        section.columns[0].add(.right, text: "(인)")
//        let logoImage = PDFImage(image: UIImage(named: "Icon.png")!,
//                                 size: CGSize(width: 50, height: 50),
//                                 options: [.resize])
//
//        section.columns[0].add(.right, image: logoImage)
        
        section.columns[2].add(textObject: PDFSimpleText(text: "\"을\"" , style: bodyStyle2))
        section.columns[2].add(textObject: PDFSimpleText(text: "\n주소 : \(SelLcEmpInfo.addr)" , style: bodyStyle2))
        section.columns[2].add(textObject: PDFSimpleText(text: "생년월일 : \(SelLcEmpInfo.birth)" , style: bodyStyle2))
        section.columns[2].add(textObject: PDFSimpleText(text: "연락처 : \(SelLcEmpInfo.phonenum)" , style: bodyStyle2))
        section.columns[2].add(textObject: PDFSimpleText(text: "성 명 : \(SelLcEmpInfo.name)" , style: bodyStyle2))
        section.columns[2].add(.right, text: "(인)")
        document.add(section: section)
        
        return [document]
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
         }else if type == 2{
             nextIndex = Int(lastIndex ?? "")! + 2
         }else {
            //주 6일일때
            let  noworkday = serverArray.subtracting(selectedArray).sorted() //없는값
            allarrayCnt.append(contentsOf: noworkday)
            nextIndex = Int(allarrayCnt[0]) ?? 0
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
         var dayArr : String = ""
         if (workday == "2,3,4,5,6," || workday == "2,3,4,5,6"){
             dayArr = "주간"
         }else{
              if (workday.contains("1")) { dayArr += ",일"}
              if (workday.contains("2"))  { dayArr +=  "월,"}
              if (workday.contains("3")) { dayArr += "화,"}
              if (workday.contains("4"))  {dayArr +=  "수,"}
              if (workday.contains("5"))  {dayArr +=  "목,"}
              if (workday.contains("6"))  { dayArr += "금."}
              if (workday.contains("7"))  { dayArr +=  "토,"}
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
}
 
