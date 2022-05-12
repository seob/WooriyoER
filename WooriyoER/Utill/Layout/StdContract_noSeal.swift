//
//  StdContract_noSeal.swift
//  PinPle
//
//  Created by seob on 2020/07/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//


import UIKit
import TPPDF

class StdContract_noSeal: ExampleFactory {
    
         func generateDocument() -> [PDFDocument] {
         let document = PDFDocument(format: .a4)
        document.layout = .init(size: CGSize(width: 595, height: 842), margin: UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20), space: (header: 15, footer: 10))
         // Define doccument wide styles
         let bodyStyle = document.add(style: PDFTextStyle(name: "Title",
                                                          font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0),
                                                          color: UIColor.black))
         
         
            document.set(.contentCenter, font: UIFont(name: "NotoSansCJKkr-Medium", size: 20.0) ?? UIFont.boldSystemFont(ofSize: 20.0))
         document.set(.contentCenter, textColor: UIColor.black)
         // Add a string using the title style
         document.add(.contentCenter, textObject: PDFSimpleText(text: "표준근로계약서"))
         
         
         document.set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.boldSystemFont(ofSize: 10.0))
         document.set(indent: 10, left: true)
         let titleStr = "\(CompanyInfo.name)(이하 \"갑\" 이라 한다.)와 \(SelLcEmpInfo.name)(이하 \"을\" 이라 한다.)은(는) 다음과 같이 근로계약을 체결한다."
         document.add(textObject: PDFSimpleText(text: titleStr, style: bodyStyle))
         
         var Strstart = ""
         if(SelLcEmpInfo.enddt == "1900-01-01" || SelLcEmpInfo.enddt == "") {
             Strstart = ""
         }else{
             Strstart = "\(dateformatKo(SelLcEmpInfo.enddt))까지"
         }
         document.add(space: 10)
         document.set(indent: 0, left: true)
         let Str1 = "1. 근로계약기간 : \(dateformatKo(SelLcEmpInfo.startdt)) 부터 \(Strstart)"
         document.add(textObject: PDFSimpleText(text: Str1 , style: bodyStyle))
         
         let Str2 = "2. 근 무 장 소 : \(SelLcEmpInfo.place)"
         document.add(textObject: PDFSimpleText(text: Str2 , style: bodyStyle))
         
         let Str3 = "3. 업무의 내용 : \(SelLcEmpInfo.task)"
         document.add(textObject: PDFSimpleText(text: Str3 , style: bodyStyle))
         
         
         let Str4 = "4. 소정근로시간 : \(substringTime(SelLcEmpInfo.starttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.endtm.timeTrim()))까지 (휴게시간 : \(substringTime(SelLcEmpInfo.brkstarttm.timeTrim()))부터 \(substringTime(SelLcEmpInfo.brkendtm.timeTrim()))까지))"
         document.add(textObject: PDFSimpleText(text: Str4 , style: bodyStyle))
         
         let Str5 = "5. 근무일/휴일 : 매주 \(workingDay(SelLcEmpInfo.workday).replacingOccurrences(of: "\",", with: ","))(또는 매일단위)근무, 주휴일 매주 \(workdayStr(SelLcEmpInfo.workday, 2))"
         document.add(textObject: PDFSimpleText(text: Str5 , style: bodyStyle))
         
         let Str6 = "6. 임 금 :"
         document.add(textObject: PDFSimpleText(text: Str6 , style: bodyStyle))
         
         document.set(indent: 20, left: true)
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
             Str7_2 = "- 기타급여(제수당 등) : 있음(O)"
         }else{
             Str7_2 = "- 기타급여(제수당 등) : 없음(O)"
         }
         
         document.add(textObject: PDFSimpleText(text: Str7_2 , style: bodyStyle))
         
         let section = PDFSection(columnWidths: [0.45,0.10, 0.45])
         if SelLcEmpInfo.otherpay > 0 {
             section.columns[0].add(textObject: PDFSimpleText(text: "\(DecimalWon(value: SelLcEmpInfo.otherpay))원" , style: bodyStyle))
         }else{
             section.columns[0].add(textObject: PDFSimpleText(text: "\t\t\t원" , style: bodyStyle))
         }
         
         section.columns[0].add(textObject: PDFSimpleText(text: "\t\t\t원" , style: bodyStyle))
         
         
         section.columns[2].add(textObject: PDFSimpleText(text: "\t\t원" , style: bodyStyle))
         section.columns[2].add(textObject: PDFSimpleText(text: "\t\t원" , style: bodyStyle))
         document.add(section: section)
         
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
             let Str8 = "7. 연차유급휴가"
             document.add(textObject: PDFSimpleText(text: Str8 , style: bodyStyle))
             
             document.set(indent: 20, left: true)
             let Str8_1 = "\(SelLcEmpInfo.anual)"
             document.add(textObject: PDFSimpleText(text: Str8_1 , style: bodyStyle))
         }
         
         
         document.set(indent: 0, left: true)
         var Str9 = ""
         if SelLcEmpInfo.anual == "" {
             Str9 = "7. 사회보험 적용여부(해당란에 체크)"
         }else{
             Str9 = "8. 사회보험 적용여부(해당란에 체크)"
         }
         
         document.add(textObject: PDFSimpleText(text: Str9 , style: bodyStyle))
         
         document.set(indent: 20, left: true)
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
         
         document.set(indent: 0, left: true)
         if SelLcEmpInfo.delivery != "" {
             let Str10 = "9. 근로계약서 교부"
             document.add(textObject: PDFSimpleText(text: Str10 , style: bodyStyle))
             
             document.set(indent: 20, left: true)
             let Str10_1 = "\(SelLcEmpInfo.delivery)"
             document.add(textObject: PDFSimpleText(text: Str10_1 , style: bodyStyle))
         }
         
         
         document.set(indent: 0, left: true)
         var Str11 = ""
         if SelLcEmpInfo.delivery == "" {
             Str11 = "9. 근로계약, 취업규칙 등의 성실한 이행의무"
         }else{
             Str11 = "10. 근로계약, 취업규칙 등의 성실한 이행의무"
         }
         
         document.add(textObject: PDFSimpleText(text: Str11 , style: bodyStyle))
         
         document.set(indent: 20, left: true)
         let Str11_1 = "- 사업주와 근로자는 각자가 근로계약, 취업규칙, 단체협약을 지키고 성실하게 이행하여하 함"
         document.add(textObject: PDFSimpleText(text: Str11_1 , style: bodyStyle))
         
         document.set(indent: 0, left: true)
         
         if SelLcEmpInfo.other != "" {
             let Str12 = "11. 기 타 "
             document.add(textObject: PDFSimpleText(text: Str12 , style: bodyStyle))
             
             document.set(indent: 20, left: true)
             let Str12_1 = "\(SelLcEmpInfo.other)"
             document.add(textObject: PDFSimpleText(text: Str12_1 , style: bodyStyle))
             
         }
         
         document.add(space: 10)
         document.set(indent: 0, left: true)
         document.set(.contentCenter, font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0))
         document.set(.contentCenter, textColor: UIColor.black)
         // Add a string using the title style
         document.add(.contentCenter, textObject: PDFSimpleText(text: "\(dateformatKo(SelLcEmpInfo.lcdt))"))
         
         
         
         let section3 = PDFSection(columnWidths: [0.45,0.10, 0.45])
         section3.columns[0].set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0))
         section3.columns[0].add(textObject: PDFSimpleText(text: "(사업주) 사업체명 : \(CompanyInfo.name)" , style: bodyStyle))
         section3.columns[0].add(textObject: PDFSimpleText(text: "\t성 명 : \(CompanyInfo.addr)" , style: bodyStyle))
         section3.columns[0].add(textObject: PDFSimpleText(text: "\t대 표 자  : \(CompanyInfo.ceoname)" , style: bodyStyle))
            section3.columns[0].set(font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 7.0) ?? UIFont.systemFont(ofSize: 7.0))
         section3.columns[0].add(.right, text: "(서명)")
         document.add(section: section3)
         
         
         
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



