//
//  StdContractDay.swift
//  PinPle
//
//  Created by seob on 2020/06/30.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import TPPDF

class StdContractDay: ExampleFactory {
    
    func generateDocument() -> [PDFDocument] {
        let document = PDFDocument(format: .a4)
                        document.layout = .init(size: CGSize(width: 595, height: 842), margin: UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20), space: (header: 15, footer: 10))
        // Define doccument wide styles
        let bodyStyle = document.add(style: PDFTextStyle(name: "Title",
                                                         font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0),
                                                         color: UIColor.black))
        
        
        document.set(.contentCenter, font: UIFont(name: "NotoSansCJKkr-Medium", size: 18.0) ?? UIFont.boldSystemFont(ofSize: 18.0))
        document.set(.contentCenter, textColor: UIColor.black)
        // Add a string using the title style
        document.add(.contentCenter, textObject: PDFSimpleText(text: "표준근로계약서"))
        
        
        document.set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0)  ?? UIFont.systemFont(ofSize: 18.0))
        document.set(indent: 10, left: true)
        let titleStr = "\(CompanyInfo.name) (이하 \"갑\" 이라 한다.)와 \(SelLcEmpInfo.name)(이하 \"을\" 이라 한다.)은(는) 다음과 같이 근로계약을 체결한다."
        document.add(textObject: PDFSimpleText(text: titleStr, style: bodyStyle))
        
        
        var Strstart = ""
        if(SelLcEmpInfo.enddt == "1900-01-01" || SelLcEmpInfo.enddt == "") {
            Strstart = ""
        }else{
            Strstart = "\(dateformatKo(SelLcEmpInfo.enddt))까지"
        }
        
        document.set(indent: 0, left: true)
        let Str1 = "1. 근로계약기간 : \(dateformatKo(SelLcEmpInfo.startdt)) 부터 \(Strstart)"
        document.add(textObject: PDFSimpleText(text: Str1 , style: bodyStyle))
        
        let Str2 = "2. 근 무 장 소 : \(SelLcEmpInfo.place)"
        document.add(textObject: PDFSimpleText(text: Str2 , style: bodyStyle))
        
        
        let Str3 = "3. 업무의 내용 : \(SelLcEmpInfo.task)"
        document.add(textObject: PDFSimpleText(text: Str3 , style: bodyStyle))
        
        
        let Str4 = "4. 근로일 및 근로일별 근로시간"
        document.add(textObject: PDFSimpleText(text: Str4 , style: bodyStyle))
        document.add(space: 10)
        document.set(indent: 10, left: true)
        
        let table = PDFTable(rows: 5, columns: 8)
        
        let style = PDFTableStyleDefaults.none
        
        // Change standardized styles
        style.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor(red: 255,
                              green: 255,
                              blue: 255,
                              alpha: 1),
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 9.0) ?? UIFont.systemFont(ofSize: 9.0)
            
        )
        style.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor(red: 255,
                              green: 255,
                              blue: 255,
                              alpha: 1),
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 9.0) ?? UIFont.systemFont(ofSize: 9.0)
            
        )
        
        style.columnHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor(red: 255,
                              green: 255,
                              blue: 255,
                              alpha: 1),
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 9.0) ?? UIFont.systemFont(ofSize: 9.0)
            
        )
        
        style.footerStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor(red: 255,
                              green: 255,
                              blue: 255,
                              alpha: 1),
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 9.0) ?? UIFont.systemFont(ofSize: 9.0)
            
        )
        var monworkmin = ""
        var tueworkmin = ""
        var wedworkmin = ""
        var thurworkmin = ""
        var friworkmin = ""
        var satworkmin = ""
        var sunworkmin = ""
        
        var monstart = ""
        var tuestart = ""
        var wedstart = ""
        var thurstart = ""
        var fristart = ""
        var satstart = ""
        var sunstart = ""
        
        var monend = ""
        var tueend = ""
        var wedend = ""
        var thurend = ""
        var friend = ""
        var satend = ""
        var sunend = ""
        
        var monbk = ""
        var tuebk = ""
        var wedbk = ""
        var thurbk = ""
        var fribk = ""
        var satbk = ""
        var sunbk = ""
        if SelLcEmpInfo.workdaylist.count > 0 {
            for (i , _) in SelLcEmpInfo.workdaylist.enumerated() {
                switch SelLcEmpInfo.workdaylist[i].dayweek {
                case 2:
                    if SelLcEmpInfo.workdaylist[i].workmin > 0 {
                        monworkmin = "\(getMinTohm(SelLcEmpInfo.workdaylist[i].workmin))"
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].starttm.timeTrim() != "00:00" {
                        monstart = "\(substringTime(SelLcEmpInfo.workdaylist[i].starttm))"
                    }else{
                        monstart = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].endtm.timeTrim() != "00:00" {
                        monend = "\(substringTime(SelLcEmpInfo.workdaylist[i].endtm))"
                    }else{
                        monend = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim() != "00:00"  || SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim() != "00:00" {
                        monbk = "\(substringTime(SelLcEmpInfo.workdaylist[i].brkstarttm))\n~ \(substringTime(SelLcEmpInfo.workdaylist[i].brkendtm))"
                    }else{
                        monbk = " - "
                    }
                case 3:
                    if SelLcEmpInfo.workdaylist[i].workmin > 0 {
                        tueworkmin = "\(getMinTohm(SelLcEmpInfo.workdaylist[i].workmin))"
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].starttm.timeTrim() != "00:00" {
                        tuestart = "\(substringTime(SelLcEmpInfo.workdaylist[i].starttm))"
                    }else{
                        tuestart = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].endtm.timeTrim() != "00:00" {
                        tueend = "\(substringTime(SelLcEmpInfo.workdaylist[i].endtm))"
                    }else{
                        tueend = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim() != "00:00"  || SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim() != "00:00" {
                        tuebk = "\(substringTime(SelLcEmpInfo.workdaylist[i].brkstarttm))\n~ \(substringTime(SelLcEmpInfo.workdaylist[i].brkendtm))"
                    }else{
                        tuebk = " - "
                    }
                case 4:
                    if SelLcEmpInfo.workdaylist[i].workmin > 0 {
                        wedworkmin = "\(getMinTohm(SelLcEmpInfo.workdaylist[i].workmin))"
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].starttm.timeTrim() != "00:00" {
                        wedstart = "\(substringTime(SelLcEmpInfo.workdaylist[i].starttm.timeTrim()))"
                    }else{
                        wedstart = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].endtm.timeTrim() != "00:00" {
                        wedend = "\(substringTime(SelLcEmpInfo.workdaylist[i].endtm.timeTrim()))"
                    }else{
                        wedend = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim() != "00:00"  || SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim() != "00:00" {
                        wedbk = "\(substringTime(SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim()))\n~ \(substringTime(SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim()))"
                    }else{
                        wedbk = " - "
                    }
                case 5:
                    if SelLcEmpInfo.workdaylist[i].workmin > 0 {
                        thurworkmin = "\(getMinTohm(SelLcEmpInfo.workdaylist[i].workmin))"
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].starttm.timeTrim() != "00:00" {
                        thurstart = "\(substringTime(SelLcEmpInfo.workdaylist[i].starttm.timeTrim()))"
                    }else{
                        thurstart = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].endtm.timeTrim() != "00:00" {
                        thurend = "\(substringTime(SelLcEmpInfo.workdaylist[i].endtm.timeTrim()))"
                    }else{
                        thurend = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim() != "00:00"  || SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim() != "00:00" {
                        thurbk = "\(substringTime(SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim()))\n~ \(substringTime(SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim()))"
                    }else{
                        thurbk = " - "
                    }
                case 6:
                    if SelLcEmpInfo.workdaylist[i].workmin > 0 {
                        friworkmin = "\(getMinTohm(SelLcEmpInfo.workdaylist[i].workmin))"
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].starttm.timeTrim() != "00:00" {
                        fristart = "\(substringTime(SelLcEmpInfo.workdaylist[i].starttm.timeTrim()))"
                    }else{
                        fristart = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].endtm.timeTrim() != "00:00" {
                        friend = "\(substringTime(SelLcEmpInfo.workdaylist[i].endtm.timeTrim()))"
                    }else{
                        friend = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim() != "00:00"  || SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim() != "00:00" {
                        fribk = "\(substringTime(SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim()))\n~ \(substringTime(SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim()))"
                    }else{
                        fribk = " - "
                    }
                case 7:
                    if SelLcEmpInfo.workdaylist[i].workmin > 0 {
                        satworkmin = "\(getMinTohm(SelLcEmpInfo.workdaylist[i].workmin))"
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].starttm.timeTrim() != "00:00" {
                        satstart = "\(substringTime(SelLcEmpInfo.workdaylist[i].starttm.timeTrim()))"
                    }else{
                        satstart = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].endtm.timeTrim() != "00:00" {
                        satend = "\(substringTime(SelLcEmpInfo.workdaylist[i].endtm.timeTrim()))"
                    }else{
                        satend = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim() != "00:00"  || SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim() != "00:00" {
                        satbk = "\(substringTime(SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim()))\n~ \(substringTime(SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim()))"
                    }else{
                        satbk = " - "
                    }
                case 1:
                    if SelLcEmpInfo.workdaylist[i].workmin > 0 {
                        sunworkmin = "\(getMinTohm(SelLcEmpInfo.workdaylist[i].workmin))"
                    }
                    if SelLcEmpInfo.workdaylist[i].starttm.timeTrim() != "00:00" {
                        sunstart = "\(substringTime(SelLcEmpInfo.workdaylist[i].starttm.timeTrim()))"
                    }else{
                        sunstart = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].endtm.timeTrim() != "00:00" {
                        sunend = "\(substringTime(SelLcEmpInfo.workdaylist[i].endtm.timeTrim()))"
                    }else{
                        sunend = " - "
                    }
                    
                    if SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim() != "00:00"  || SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim() != "00:00" {
                        sunbk = "\(substringTime(SelLcEmpInfo.workdaylist[i].brkstarttm.timeTrim()))\n~ \(substringTime(SelLcEmpInfo.workdaylist[i].brkendtm.timeTrim()))"
                    }else{
                        sunbk = " - "
                    }
                default:
                    break
                }
            }
            
        }
        table.content = [
            [nil, "월요일","화요일","수요일","목요일","금요일","토요일","일요일"],
            ["근로시간",   "\(monworkmin)",  "\(tueworkmin)", "\(wedworkmin)", "\(thurworkmin)", "\(friworkmin)", "\(satworkmin)", "\(sunworkmin)"],
            ["시업",   "\(monstart)",  "\(tuestart)", "\(wedstart)", "\(thurstart)", "\(fristart)", "\(satstart)", "\(sunstart)"],
            ["종업",   "\(monend)",  "\(tueend)", "\(wedend)", "\(thurend)", "\(friend)", "\(satend)", "\(sunend)"],
            ["휴게시간",   "\(monbk)",  "\(tuebk)", "\(wedbk)", "\(thurbk)", "\(fribk)", "\(satbk)", "\(sunbk)"]
        ]
        
        
        table.columns.allCellsAlignment = .center
        
        table.widths = [0.1, 0.1 , 0.1, 0.1, 0.1 ,0.1, 0.1, 0.1 ]
        table.margin = 0
        table.padding = 5
        table.showHeadersOnEveryPage = false
        table.style = style
        document.add(table: table)
        
        
        var Str5 = ""
        var arrayCnt: [String] = []
        
        arrayCnt = SelLcEmpInfo.workday.components(separatedBy: ",")
        arrayCnt = arrayCnt.filter({ !$0.isEmpty })
         
            
        switch arrayCnt.count {
        case 6:
            Str5 = "◦ 주휴일 : 매주 \(workdayStr(SelLcEmpInfo.workday, 3))"
        case 7:
            Str5 = "◦ 주휴일 : 없음"
        default:
            Str5 = "◦ 주휴일 : 매주 \(workdayStr(SelLcEmpInfo.workday, 2))"
        }
         
        document.add(textObject: PDFSimpleText(text: Str5 , style: bodyStyle))
        
        
        document.set(indent: 0, left: true)
        let Str6 = "5. 임 금 :"
        document.add(textObject: PDFSimpleText(text: Str6 , style: bodyStyle))
        
        document.set(indent: 10, left: true)
        var pay = 0
        var paytitle = ""
        switch SelLcEmpInfo.slytype {
        case 0,1:
            pay = SelLcEmpInfo.basepay // 월급
            paytitle = "월급"
        case 2,3:
            pay = SelLcEmpInfo.hourpay // 시급
            paytitle = "시급"
        case 4,5:
            pay = SelLcEmpInfo.daypay // 일급
            paytitle = "일급"
        default:
            break
        }
        let Str7 = "- \(paytitle) : \(DecimalWon(value: pay))원"
        document.add(textObject: PDFSimpleText(text: Str7 , style: bodyStyle))
        
        var Str7_1 = ""
        if SelLcEmpInfo.bonus > 0 {
            Str7_1 = "- 상여금 : 있음(O) \(DecimalWon(value: SelLcEmpInfo.bonus))원"
        }else{
            Str7_1 = "- 상여금 : 없음(O)"
        }
        document.add(textObject: PDFSimpleText(text: Str7_1 , style: bodyStyle))
        
        var Str7_2 = ""
        if SelLcEmpInfo.otherpay > 0 {
            Str7_2 = "- 기타급여(제수당 등) : 있음(O) \(DecimalWon(value: SelLcEmpInfo.otherpay))원(내역별 기제)"
        }else{
            Str7_2 = "- 기타급여(제수당 등) : 없음(O)"
        }
        document.add(textObject: PDFSimpleText(text: Str7_2 , style: bodyStyle))
        
        let Str7_5 = "- 초과근로에 대한 가산임금률 : \(SelLcEmpInfo.addrate)%"
        document.add(textObject: PDFSimpleText(text: Str7_5 , style: bodyStyle))
        
        let Str7_3 = "- 임금지급일: \(SelLcEmpInfo.payday)"
        document.add(textObject: PDFSimpleText(text: Str7_3 , style: bodyStyle))
        
        var Str7_4  = ""
        if SelLcEmpInfo.payroll == 0 {
            Str7_4 = "- 지급방법: 근로자에게 직접지급(O)"
        }else{
            Str7_4 = "- 지급방법: 근로자 명의 예금통장에 입금(O)"
        }
        document.add(textObject: PDFSimpleText(text: Str7_4 , style: bodyStyle))
        
        
        document.set(indent: 0, left: true)
        if SelLcEmpInfo.anual != "" {
            let Str8 = "6. 연차유급휴가 : \(SelLcEmpInfo.anual)"
            document.add(textObject: PDFSimpleText(text: Str8 , style: bodyStyle))
        }
        
        
        document.set(indent: 0, left: true)
        var Str9 = ""
        if SelLcEmpInfo.anual == "" {
            Str9 = "6. 사회보험 적용여부"
        }else{
            Str9 = "7. 사회보험 적용여부"
        }
        
        document.add(textObject: PDFSimpleText(text: Str9 , style: bodyStyle))
        
        document.set(indent: 10, left: true)
        if SelLcEmpInfo.socialinsrn != "" {
            var strSocial = ""
            if SelLcEmpInfo.socialinsrn.contains("1") {
                strSocial += "국민연금"
            }
            
            if SelLcEmpInfo.socialinsrn.contains("2") {
                strSocial += " , 건강보험"
            }
            
            if SelLcEmpInfo.socialinsrn.contains("3") {
                strSocial += " , 고용보험"
            }
            
            if SelLcEmpInfo.socialinsrn.contains("4") {
                strSocial += " , 산재보험"
            }
            document.add(textObject: PDFSimpleText(text: strSocial , style: bodyStyle))
        }
        
        if SelLcEmpInfo.delivery != "" {
            document.set(indent: 0, left: true)
            var Str10 = ""
            if SelLcEmpInfo.anual == "" {
                Str10 = "7. 근로계약서 교부"
            }else{
                Str10 = "8. 근로계약서 교부"
            }
            
            document.add(textObject: PDFSimpleText(text: Str10 , style: bodyStyle))
            
            document.set(indent: 10, left: true)
            let Str10_1 = "\(SelLcEmpInfo.delivery)"
            document.add(textObject: PDFSimpleText(text: Str10_1 , style: bodyStyle))
        }
        
        
        
        document.set(indent: 0, left: true)
        var Str11 = ""
        if SelLcEmpInfo.anual == "" {
            Str11 = "8. 근로계약, 취업규칙 등의 성실한 이행의무"
        }else{
            Str11 = "9. 근로계약, 취업규칙 등의 성실한 이행의무"
        }
        
        document.add(textObject: PDFSimpleText(text: Str11 , style: bodyStyle))
        
        document.set(indent: 20, left: true)
        let Str11_1 = "- 사업주와 근로자는 각자가 근로계약, 취업규칙, 단체협약을 지키고 성실하게 이행하여하 함"
        document.add(textObject: PDFSimpleText(text: Str11_1 , style: bodyStyle))
        
        
        if SelLcEmpInfo.other != "" {
            document.set(indent: 0, left: true)
            var Str12 = ""
            if SelLcEmpInfo.anual == "" {
                Str12 = "9. 기 타 "
            }else{
                Str12 = "10. 기 타 "
            }
            
            document.add(textObject: PDFSimpleText(text: Str12 , style: bodyStyle))
            
            document.set(indent: 10, left: true)
            let Str12_1 = "\(SelLcEmpInfo.other)"
            document.add(textObject: PDFSimpleText(text: Str12_1 , style: bodyStyle))
        }
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        document.set(.contentCenter, font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0))
        document.set(.contentCenter, textColor: UIColor.black)
        // Add a string using the title style
        document.add(.contentCenter, textObject: PDFSimpleText(text: "\(dateformatKo(SelLcEmpInfo.lcdt))"))
        
        
        
        let section = PDFSection(columnWidths: [0.45,0.10, 0.45])
        section.columns[0].set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10))
        section.columns[0].add(textObject: PDFSimpleText(text: "(사업주) 사업체명 : \(CompanyInfo.name)" , style: bodyStyle))
        section.columns[0].add(textObject: PDFSimpleText(text: "\t성 명 : \(CompanyInfo.addr)" , style: bodyStyle))
        section.columns[0].add(textObject: PDFSimpleText(text: "\t대 표 자  : \(CompanyInfo.ceoname)" , style: bodyStyle))
        section.columns[0].set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 7.0) ?? UIFont.systemFont(ofSize: 7.0))
        section.columns[0].add(.right, text: "(서명)")
 
         if SelLcEmpInfo.cslimg != "" {
            let captainAmericaURL = URL(string: SelLcEmpInfo.cslimg)
            URLSession.shared.dataTask(with: captainAmericaURL!) { data, response, error in
                guard let data = data else { return }
                let image = UIImage(data: data)!
                
                SelLcEmpInfo.cmpseal = image
                if SelLcEmpInfo.cslshape == 0 {
                    let size = CGSize(width: 80, height: 80)
                    let path = PDFBezierPath(ref: CGRect(origin: .zero, size: size))
                    path.move(to: PDFBezierPathVertex(position: CGPoint(x: size.width / 2, y: 0), anchor: .topCenter))
                    path.close()
                    let shape = PDFDynamicGeometryShape(path: path, fillColor: .white, stroke: .none)
                    let logoImage = PDFImage(image: image,
                                             size: CGSize(width: 80, height: 80),
                                             options: [.none])
                    
                    let group = PDFGroup(allowsBreaks: false,
                                         backgroundColor: .white,
                                         backgroundShape: shape,
                                         padding: UIEdgeInsets(top: -40, left: 190, bottom: 0, right: 0))
                    DispatchQueue.main.async {
                        group.set(indentation: 0, left: true)
                        group.add(image: logoImage)
                        section.columns[0].add(group: group)
                    }
                }else{
                    let size = CGSize(width: 100, height: 100)
                    let path = PDFBezierPath(ref: CGRect(origin: .zero, size: size))
                    path.move(to: PDFBezierPathVertex(position: CGPoint(x: size.width / 2, y: 0), anchor: .topCenter))
                    path.close()
                    let shape = PDFDynamicGeometryShape(path: path, fillColor: .white, stroke: .none)
                    let logoImage = PDFImage(image: image,
                                             size: CGSize(width: 120, height: 120),
                                             options: [.none])
                    
                    let group = PDFGroup(allowsBreaks: false,
                                         backgroundColor: .white,
                                         backgroundShape: shape,
                                         padding: UIEdgeInsets(top: -40, left: 210, bottom: 0, right: 0))
                    DispatchQueue.main.async {
                        group.set(indentation: 0, left: true)
                        group.add(image: logoImage)
                        section.columns[0].add(group: group)
                    }
                }
            }.resume()
        }
 
        document.add(section: section)
        
        
        
        let section2 = PDFSection(columnWidths: [0.45,0.10, 0.45])
        section2.columns[0].set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0))
        section2.columns[0].add(textObject: PDFSimpleText(text: "(근로자) 주 소 : \(SelLcEmpInfo.addr)" , style: bodyStyle))
        section2.columns[0].add(textObject: PDFSimpleText(text: "\t연 락 처 : \(SelLcEmpInfo.phonenum.pretty())" , style: bodyStyle))
        section2.columns[0].add(textObject: PDFSimpleText(text: "\t성 명 : \(SelLcEmpInfo.name)" , style: bodyStyle))
        section2.columns[0].set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 7.0) ?? UIFont.systemFont(ofSize: 7.0))
        section2.columns[0].add(.right, text: "(서명)")
        document.add(section: section2)
        document.disableColumns(addPageBreak: false)
        return [document]
    }
}

