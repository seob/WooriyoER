//
//  PinplContract_noSeal.swift
//  PinPle
//
//  Created by seob on 2020/07/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//


import UIKit
import TPPDF

class PinplContract_noSeal: ExampleFactory {
    
    func generateDocument() -> [PDFDocument] {
        let document = PDFDocument(format: .a4)
        document.layout = .init(size: CGSize(width: 595, height: 842), margin: UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20), space: (header: 15, footer: 10))
        
        let bodyTitleStyle1 = document.add(style: PDFTextStyle(name: "BodyTitle",
                                                               font:  UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ,
                                                               color: UIColor.black))
        
        let bodyStyle2 = document.add(style: PDFTextStyle(name: "Body",
                                                          font:  UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ,
                                                          color: UIColor.black))
        
        document.set(.contentCenter, font: UIFont(name: "NotoSansCJKkr-Medium", size: 20.0) ?? UIFont.boldSystemFont(ofSize: 20.0))
        document.set(.contentCenter, textColor: UIColor.black)
        // Add a string using the title style
        document.add(.contentCenter, textObject: PDFSimpleText(text: "근  로  계  약  서"))
        
        
        document.set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0)  ?? UIFont.systemFont(ofSize: 10.0))
        document.set(textColor: UIColor.black)
        document.set(indent: 10, left: true)
        let titleStr = "\(CompanyInfo.name)(이하 \"갑\" 이라 한다.)와 \(SelLcEmpInfo.name)(이하 \"을\" 이라 한다.)은(는) 다음과 같이 근로계약을 체결한다."
        document.add(textObject: PDFSimpleText(text: titleStr, style: bodyStyle2))
        
        
        var formStr = ""
        switch SelLcEmpInfo.form {
        case 0:
            formStr = "정규직"
        case 1:
            formStr = "계약직"
        case 2:
            formStr = "수습"
        default:
            break
        }
        document.set(indent: 0, left: true)
        let Str1 = "1. 목적 : \"갑\"은 \"을\"을 \(formStr)으로 임용하기 위해서 본 근로계약서를 작성함"
        document.add(textObject: PDFSimpleText(text: Str1 , style: bodyTitleStyle1))
        let Str2 = "2. 근로개시일 및 연봉적용일"
        document.add(textObject: PDFSimpleText(text: Str2 , style: bodyTitleStyle1))
        document.set(indent: 10, left: true)
        
        var Strstart = ""
        if(SelLcEmpInfo.enddt == "1900-01-01" || SelLcEmpInfo.enddt == "") {
            Strstart = ""
        }else{
            Strstart = "\(dateformatKo(SelLcEmpInfo.enddt))까지"
        }
        
        let Str3 = "1) \"을\"의 근로개시일 : \(dateformatKo(SelLcEmpInfo.startdt))부터 \(Strstart)"
        document.add(textObject: PDFSimpleText(text: Str3 , style: bodyStyle2))
        var payenddt = ""
        if(SelLcEmpInfo.payenddt == "1900-01-01" || SelLcEmpInfo.payenddt == "") {
            payenddt = ""
        }else{
            payenddt = "\(dateformatKo(SelLcEmpInfo.payenddt))까지"
        }
        
        let Str4 = "2) \"을\"의 연봉적용일 : \(dateformatKo(SelLcEmpInfo.paystartdt))부터 \(payenddt)"
        document.add(textObject: PDFSimpleText(text: Str4 , style: bodyStyle2))
        document.set(indent: 0, left: true)
        let Str5 = "3. 근무지/담당업무 : \(SelLcEmpInfo.place) / \(SelLcEmpInfo.task)"
        document.add(textObject: PDFSimpleText(text: Str5 , style: bodyTitleStyle1))
        
        document.set(indent: 0, left: true)
        
        let Str6 = "4. 소정근로시간 : \(substringTime(SelLcEmpInfo.starttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.endtm.timeTrim()))까지 (휴게시간 : \(substringTime(SelLcEmpInfo.brkstarttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.brkendtm.timeTrim()))까지)"
        document.add(textObject: PDFSimpleText(text: Str6 , style: bodyTitleStyle1))
        
        
        //        var Cellworkmin = 0
        //        if (SelLcEmpInfo.starttm.timeTrim() != "" && SelLcEmpInfo.endtm.timeTrim() != ""){
        //            Cellworkmin = calTotalTime(SelLcEmpInfo.starttm.timeTrim(), SelLcEmpInfo.endtm.timeTrim(), SelLcEmpInfo.brkstarttm.timeTrim(), SelLcEmpInfo.brkendtm.timeTrim())
        //        }else{
        //            Cellworkmin = 0
        //        }
        
        //        document.set(indent: 20, left: true)
        //        let Str7 = "- 근로시간 : \(substringTime(SelLcEmpInfo.starttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.endtm.timeTrim()))까지 (휴게시간 : \(substringTime(SelLcEmpInfo.brkstarttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.brkendtm.timeTrim()))까지)"
        //        document.add(textObject: PDFSimpleText(text: Str7 , style: bodyStyle2))
        //
        //        document.set(indent: 20, left: true)
        //
        let Str8 = "5. 근무일 : \(workingDay(SelLcEmpInfo.workday).replacingOccurrences(of: "\",", with: ","))"
        document.add(textObject: PDFSimpleText(text: Str8 , style: bodyStyle2))
        //
        //
        //        var Cellbkmin = 0
        //        if (SelLcEmpInfo.brkstarttm.timeTrim() != "" && SelLcEmpInfo.brkendtm.timeTrim() != ""){
        //            Cellbkmin = bkTotalTime(SelLcEmpInfo.brkstarttm.timeTrim(), SelLcEmpInfo.brkendtm.timeTrim())
        //        }else{
        //            Cellbkmin = 0
        //        }
        //
        //        document.set(indent: 20, left: true)
        //        let Str9 = "- 휴게시간 : \(substringTime(SelLcEmpInfo.brkstarttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.brkendtm.timeTrim()))까지 (\(getMinTohm(Int(Cellbkmin.magnitude))))"
        //        document.add(textObject: PDFSimpleText(text: Str9 , style: bodyStyle2))
        
        document.set(indent: 0, left: true)
        let Str10 = "6. 휴무일"
        
        document.add(textObject: PDFSimpleText(text: Str10 , style: bodyTitleStyle1))
        
        var arrayCnt: [String] = []
        
        arrayCnt = SelLcEmpInfo.workday.components(separatedBy: ",")
        arrayCnt = arrayCnt.filter({ !$0.isEmpty })
        if arrayCnt.count == 7 {
            
        }else if arrayCnt.count == 6 {
            document.set(indent: 10, left: true)
            let Str11 = "1) 주휴일은 매주 \(workdayStr(SelLcEmpInfo.workday, 2)), 「근로자의날제정에관한법률」에 따른 근로자의 날(5월1일)은 유급휴일.\n2) 1주간 소정근로일에 개근 시 \(workdayStr(SelLcEmpInfo.workday, 2))을 유급 주휴일로 부여."
            document.add(textObject: PDFSimpleText(text: Str11 , style: bodyStyle2))
        }else{
            document.set(indent: 10, left: true)
            let Str11 = "1) 주휴일은 매주 \(workdayStr(SelLcEmpInfo.workday, 2)), 「근로자의날제정에관한법률」에 따른 근로자의 날(5월1일)은 유급휴일.\n2) 1주간 소정근로일에 개근 시 \(workdayStr(SelLcEmpInfo.workday, 2))을 유급 주휴일로 부여, \(workdayStr(SelLcEmpInfo.workday, 1))은 무급휴무로 부여."
            document.add(textObject: PDFSimpleText(text: Str11 , style: bodyStyle2))
        }
        
        document.set(indent: 0, left: true)
        let Str13 = "7. 임금"
        document.add(textObject: PDFSimpleText(text: Str13 , style: bodyTitleStyle1))
        
        document.set(indent: 10, left: true)
        let Str13_1 = "\(SelLcEmpInfo.payday)"
        document.add(textObject: PDFSimpleText(text: Str13_1 , style: bodyStyle2))
        
        document.set(indent: 0, left: true)
        
        
        let table = PDFTable(rows: 19 , columns: 3)
        let style = PDFTableStyleDefaults.none
        
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
            
            font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
            
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
            
            font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
            
        )
        
        style.columnHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor(red: 206,
                              green: 227,
                              blue: 246,
                              alpha: 1),
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
            
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
            
            font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
            
        )
        var meal = ""
        if SelLcEmpInfo.meals > 100000 {
            meal = "비과세 해당금액 : 100,000원"
        }else{
            meal = "비과세 해당금액 : \(DecimalWon(value: SelLcEmpInfo.meals))원"
        }
        
        table.content = [
            ["급 여 내 역", nil,  "산출근거"],
            ["기본급(A)", "\(DecimalWon(value: SelLcEmpInfo.basepay))", "\(SelLcEmpInfo.basepay > 0 ? SelLcEmpInfo.basebs : "")"],
            ["장기근속수당", "\(DecimalWon(value: SelLcEmpInfo.cntnspay))", "\(SelLcEmpInfo.cntnspay > 0 ? SelLcEmpInfo.cntnsbs : "")"],
            ["직책수당", "\(DecimalWon(value: SelLcEmpInfo.pstnpay))", "\(SelLcEmpInfo.pstnpay > 0 ? SelLcEmpInfo.pstnbs : "")"],
            ["연장근로수당", "\(DecimalWon(value: SelLcEmpInfo.ovrtmpay))", "\(SelLcEmpInfo.ovrtmpay > 0 ? "{(A)÷209×1.5}×\(SelLcEmpInfo.monthovrtm)h" : "")"],
            ["휴일수당", "\(DecimalWon(value: SelLcEmpInfo.hldypay))", "\(SelLcEmpInfo.hldypay > 0 ? SelLcEmpInfo.hlfybs : "")"],
            ["상여금", "\(DecimalWon(value: SelLcEmpInfo.bonus))", "\(SelLcEmpInfo.bonus > 0 ? SelLcEmpInfo.bonusbs : "")"],
            ["복지후생", "\(DecimalWon(value: SelLcEmpInfo.benefits))", "\(SelLcEmpInfo.benefits > 0 ? SelLcEmpInfo.benefitisbs : "")"],
            ["기타", "\(DecimalWon(value: SelLcEmpInfo.otherpay))", "\(SelLcEmpInfo.otherpay > 0 ? SelLcEmpInfo.otherbs : "")"],
            ["비과세 항목",nil, nil],
            ["식대", "\(DecimalWon(value: SelLcEmpInfo.meals))", "\(SelLcEmpInfo.meals > 0 ? meal : "")"],
            ["연구보조비", "\(DecimalWon(value: SelLcEmpInfo.rsrchsbdy))", "\(SelLcEmpInfo.rsrchsbdy > 0 ? SelLcEmpInfo.rsrchbs : "")"],
            ["자녀보육수당", "\(DecimalWon(value: SelLcEmpInfo.chldexpns))", "\(SelLcEmpInfo.chldexpns > 0 ? SelLcEmpInfo.chldbs : "")"],
            ["차량유지비", "\(DecimalWon(value: SelLcEmpInfo.vhclmncst))", "\(SelLcEmpInfo.vhclmncst > 0 ? SelLcEmpInfo.vhclbs : "")"],
            ["일직&숙직비", "\(DecimalWon(value: SelLcEmpInfo.jobexpns))", "\(SelLcEmpInfo.jobexpns > 0 ? SelLcEmpInfo.jobbs : "")"],
            ["계(B)", "\(DecimalWon(value: SelLcEmpInfo.jobexpns))", ""],
            ["명절수당(C)", "\(DecimalWon(value: SelLcEmpInfo.jobexpns))", "\(SelLcEmpInfo.jobexpns > 0 ? "설,추석 각 \(DecimalWon(value: SelLcEmpInfo.hldyalwnc))원" : "")"],
            ["총 연봉급여[{(B)*12개월}+(C)]", "\(DecimalWon(value: SelLcEmpInfo.yearpay))", nil],
            ["지급계좌", "예금주: \(SelLcEmpInfo.actholder)  계좌번호:\(SelLcEmpInfo.actnum)  금융기관 :\(SelLcEmpInfo.actbank)", nil]
        ]
        
        table.columns.allCellsAlignment = .center
        
        table.widths = [0.3, 0.3 , 0.4]
        table.margin = 0
        table.padding = 0
        table.showHeadersOnEveryPage = true
        
        table[rows: 0, columns: 0...1].merge()
        table[rows: 9, columns: 0...2].merge()
        table[rows: 17, columns: 1...2].merge()
        table[rows: 18, columns: 1...2].merge()
        
        table[rows: 0, columns: 0...1].allCellsStyle =  PDFTableCellStyle(
                   colors: (
                       fill: UIColor(red: 206,
                                     green: 227,
                                     blue: 246,
                                     alpha: 1),
                       text: UIColor.black
                   ),
                   borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                                top: PDFLineStyle(type: .full),
                                                right: PDFLineStyle(type: .full),
                                                bottom: PDFLineStyle(type: .full)),
                   
                   font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
                   
               )
        table.style = style
        document.add(table: table)
        document.set(indent: 0, left: true)
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
        
        let Str14 = "8. 사회보험 가입 : \(strSocial)"
        document.add(textObject: PDFSimpleText(text: Str14 , style: bodyTitleStyle1))
        
        
        if SelLcEmpInfo.anual != "" {
            let Str15 = "9. 연차유급휴가 : \(SelLcEmpInfo.anual)"
            document.add(textObject: PDFSimpleText(text: Str15 , style: bodyTitleStyle1))
        }
        
        if SelLcEmpInfo.delivery != "" {
            var Str16 = ""
            if SelLcEmpInfo.delivery == "" {
                Str16 = "9. 근로계약서 교부"
            }else{
                Str16 = "10. 근로계약서 교부"
            }
            document.add(textObject: PDFSimpleText(text: Str16 , style: bodyTitleStyle1))
            
            document.set(indent: 10, left: true)
            let Str16_1 = "\(SelLcEmpInfo.delivery)"
            document.add(textObject: PDFSimpleText(text: Str16_1 , style: bodyStyle2))
        }
        
        
        if SelLcEmpInfo.other != "" {
            document.set(indent: 0, left: true)
            var Str17 = ""
            if SelLcEmpInfo.delivery == "" {
                Str17 = "10. 기타사항"
            }else{
                Str17 = "11. 기타사항"
            }
            document.add(textObject: PDFSimpleText(text: Str17 , style: bodyTitleStyle1))
            
            
            document.set(indent: 10, left: true)
            let Str17_1 = "\(SelLcEmpInfo.other)"
            document.add(textObject: PDFSimpleText(text: Str17_1 , style: bodyStyle2))
        }else{
            document.set(indent: 0, left: true)
            var Str17 = ""
            if SelLcEmpInfo.delivery == "" {
                Str17 = "10. 기타사항"
            }else{
                Str17 = "11. 기타사항"
            }
            document.add(textObject: PDFSimpleText(text: Str17 , style: bodyTitleStyle1))
            document.set(indent: 10, left: true)
            let Str17_1 = "\(defaultEtcText)"
            document.add(textObject: PDFSimpleText(text: Str17_1 , style: bodyStyle2))
        }
        
        document.add(space: 10)
        document.set(.contentCenter, font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.boldSystemFont(ofSize: 10.0))
        document.set(.contentCenter, textColor: UIColor.black)
        
        // Add a string using the title style
        var lcdt = ""
        if(SelLcEmpInfo.lcdt == "1900-01-01" || SelLcEmpInfo.lcdt != "") {
            lcdt = "\(dateformatKo(SelLcEmpInfo.lcdt))"
        }else{
            lcdt = ""
        }
        document.add(.contentCenter, textObject: PDFSimpleText(text: "\(lcdt)"))
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        
        let section = PDFSection(columnWidths: [0.45,0.10, 0.45])
        
        section.columns[0].set(font: UIFont(name: "NotoSansCJKkr-Medium", size: 10.0) ?? UIFont.boldSystemFont(ofSize: 10.0))
        
        
        section.columns[0].add(textObject: PDFSimpleText(text: "\"갑\"" , style: bodyStyle2))
        section.columns[0].add(textObject: PDFSimpleText(text: "\n주   소 : \(CompanyInfo.addr)" , style: bodyStyle2))
        section.columns[0].add(textObject: PDFSimpleText(text: "회 사 명 : \(CompanyInfo.name)" , style: bodyStyle2))
        section.columns[0].add(textObject: PDFSimpleText(text: "연 락 처 : \(CompanyInfo.phone.pretty())" , style: bodyStyle2))
        section.columns[0].add(textObject: PDFSimpleText(text: "대   표 : \(CompanyInfo.ceoname)" , style: bodyStyle2))
        section.columns[0].set(font: UIFont(name: "NotoSansCJKkr-Medium", size: 7.0) ?? UIFont.systemFont(ofSize: 7.0))
        section.columns[0].add(.right, text: "(인)")
        
        section.columns[2].add(textObject: PDFSimpleText(text: "\"을\"" , style: bodyStyle2))
        section.columns[2].add(textObject: PDFSimpleText(text: "\n주   소 : \(SelLcEmpInfo.addr)" , style: bodyStyle2))
        section.columns[2].add(textObject: PDFSimpleText(text: "생년월일 : \(SelLcEmpInfo.birth)" , style: bodyStyle2))
        section.columns[2].add(textObject: PDFSimpleText(text: "연 락 처 : \(SelLcEmpInfo.phonenum.pretty())" , style: bodyStyle2))
        section.columns[2].add(textObject: PDFSimpleText(text: "성   명 : \(SelLcEmpInfo.name)" , style: bodyStyle2))
        section.columns[2].set(font: UIFont(name: "NotoSansCJKkr-Medium", size: 7.0) ?? UIFont.systemFont(ofSize: 7.0))
        section.columns[2].add(.right, text: "(인)")
        document.add(section: section)
        
        return [document]
    }
}


