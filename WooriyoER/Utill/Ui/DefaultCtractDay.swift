//
//  DefaultCtractDay.swift
//  PinPle
//
//  Created by seob on 2020/06/30.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import TPPDF

class DefaultCtractDay: ExampleFactory {
    
    func generateDocument() -> [PDFDocument] {
        let document = PDFDocument(format: .a4)
        
        // Define doccument wide styles
        let bodyStyle = document.add(style: PDFTextStyle(name: "Title",
                                                         font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ,
                                                         color: UIColor.black))
        let headingStyle1 = document.add(style: PDFTextStyle(name: "Heading 1",
                                                             font: UIFont(name: "NotoSansCJKkr-Medium", size: 15.0) ,
                                                             color: UIColor.black))
        
        
        document.set(.contentCenter, font: UIFont.boldSystemFont(ofSize: 15.0))
        document.set(.contentCenter, textColor: UIColor.black)
        // Add a string using the title style
        document.add(.contentCenter, textObject: PDFSimpleText(text: "표준근로계약서"))
        
        
        
        document.add(space: 30.0)
        document.set(font: UIFont.systemFont(ofSize: 15))
        document.set(textColor: UIColor.black)
        let titleStr = "핀플 (이하 \"갑\" 이라 한다.)와 홍길동(이하 \"을\" 이라 한다.)은(는) 다음과 같이 근로계약을 체결한다."
        document.add(textObject: PDFSimpleText(text: titleStr, style: headingStyle1))
        
        
        document.add(space: 10)
        let Str1 = "1. 근로계약기간 : 2020년 06월 31일부터 2020년 06월 31일까지"
        document.add(textObject: PDFSimpleText(text: Str1 , style: bodyStyle))
        
        document.add(space: 10)
        let Str2 = "2. 근 무 장 소 : 테스트"
        document.add(textObject: PDFSimpleText(text: Str2 , style: bodyStyle))
        
        document.add(space: 10)
        let Str3 = "3. 업무의 내용 : 테스트"
        document.add(textObject: PDFSimpleText(text: Str3 , style: bodyStyle))
        
        document.add(space: 10)
        let Str4 = "4. 근로일 및 근로일별 근로시간"
        document.add(textObject: PDFSimpleText(text: Str4 , style: bodyStyle))
        
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        
        let table = PDFTable(rows: 8, columns: 8)
        
        let style = PDFTableStyleDefaults.none
        
        // Change standardized styles
        style.footerStyle = PDFTableCellStyle(
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
            
        )
        
        table.content = [
            [nil, "(월)요일","(월)요일","(월)요일","(월)요일","(월)요일","(월)요일","(월)요일"],
            ["근로시간",   "시간",  "시간", "시간", "시간", "시간", "시간", "시간"],
            ["시업",   "시 분",  "시 분", "시 분", "시 분", "시 분", "시 분", "시 분"],
            ["종업",   "시 분",  "시 분", "시 분", "시 분", "시 분", "시 분", "시 분"],
            ["휴게시간",   "시 분\n시 분",  "시 분\n시 분",  "시 분\n시 분",  "시 분\n시 분",  "시 분\n시 분",  "시 분\n시 분",  "시 분\n시 분"]
        ]
        table.rows.allRowsAlignment = [.center, .center, .center, .center , .center]
        
        table.columns.allCellsAlignment = .center
        
        table.widths = [0.1, 0.1 , 0.1, 0.1, 0.1,0.1,0.1,0.1]
        table.margin = 0
        table.padding = 5
        table.showHeadersOnEveryPage = false
        table.style.columnHeaderCount = 1
        
        
        document.add(table: table)
        
        let Str5 = "◦ 주휴일 : 매주 토요일"
        document.add(textObject: PDFSimpleText(text: Str5 , style: bodyStyle))
        
        
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str6 = "5. 임 금 :"
        document.add(textObject: PDFSimpleText(text: Str6 , style: bodyStyle))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str7 = "- 월(일,시간)급 : \t\t\t원"
        document.add(textObject: PDFSimpleText(text: Str7 , style: bodyStyle))
        
        document.add(space: 10)
        let Str7_1 = "- 상여금 : 있음( ) \t\t\t원, 없음(◦)"
        document.add(textObject: PDFSimpleText(text: Str7_1 , style: bodyStyle))
        
        document.add(space: 10)
        let Str7_2 = "- 기타급여(제수당 등) : 있음( ), 없음(◦)"
        document.add(textObject: PDFSimpleText(text: Str7_2 , style: bodyStyle))
        
        document.add(space: 10)
        let Str7_5 = "- 초과근로에 대한 가산임금률 : %"
        document.add(textObject: PDFSimpleText(text: Str7_5 , style: bodyStyle))
        
        
        document.add(space: 10)
        let Str7_3 = "- 임금지급일: 매월(매주 또는 매일) 월요일(휴일의 경우는 전일 지급)"
        document.add(textObject: PDFSimpleText(text: Str7_3 , style: bodyStyle))
        
        document.add(space: 10)
        let Str7_4 = "- 지급방법: 근로자에게 직접지급(◦), 근로자 명의 예금통장에 입금(  )"
        document.add(textObject: PDFSimpleText(text: Str7_4 , style: bodyStyle))
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str8 = "6. 연차유급휴가 : ssssss"
        document.add(textObject: PDFSimpleText(text: Str8 , style: bodyStyle))
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str9 = "7. 사회보험 적용여부(해당란에 체크)"
        document.add(textObject: PDFSimpleText(text: Str9 , style: bodyStyle))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str9_1 = "☑︎ 고용보험 ☑︎ 산재보험 ☑︎ 국민연금 ☑︎ 건강보험"
        document.add(textObject: PDFSimpleText(text: Str9_1 , style: bodyStyle))
        
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str10 = "8. 근로계약서 교부"
        document.add(textObject: PDFSimpleText(text: Str10 , style: bodyStyle))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str10_1 = "내용"
        document.add(textObject: PDFSimpleText(text: Str10_1 , style: bodyStyle))
        
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str11 = "9. 근로계약, 취업규칙 등의 성실한 이행의무"
        document.add(textObject: PDFSimpleText(text: Str11 , style: bodyStyle))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str11_1 = "- 사업주와 근로자는 각자가 근로계약, 취업규칙, 단체협약을 지키고 성실하게 이행하여하 함"
        document.add(textObject: PDFSimpleText(text: Str11_1 , style: bodyStyle))
        
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        let Str12 = "10. 기 타 "
        document.add(textObject: PDFSimpleText(text: Str12 , style: bodyStyle))
        
        document.add(space: 10)
        document.set(indent: 20, left: true)
        let Str12_1 = "기타 내용"
        document.add(textObject: PDFSimpleText(text: Str12_1 , style: bodyStyle))
        
        
        document.add(space: 10)
        document.set(indent: 0, left: true)
        document.set(.contentCenter, font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 10.0) ?? UIFont.boldSystemFont(ofSize: 10.0))
        document.set(.contentCenter, textColor: UIColor.black)
        // Add a string using the title style
        document.add(.contentCenter, textObject: PDFSimpleText(text: "2020년 06월01일"))
        
        document.add(space: 10)
        let Str13 = "(사업주) 사업체명 : 홍길동 \t(전화:\t\t)"
        document.add(textObject: PDFSimpleText(text: Str13 , style: bodyStyle))
        
        document.add(space: 10)
        let Str13_1 = "\t주  소 : "
        document.add(textObject: PDFSimpleText(text: Str13_1 , style: bodyStyle))
        
        document.add(space: 10)
        let Str13_2 = "\t대 표 자 : \t(서명)"
        document.add(textObject: PDFSimpleText(text: Str13_2 , style: bodyStyle))
        
        document.add(space: 10)
        let Str13_3 = "(근로자) 주 소 :"
        document.add(textObject: PDFSimpleText(text: Str13_3 , style: bodyStyle))
        
        document.add(space: 10)
        let Str13_4 = "\t연 락 처 : "
        document.add(textObject: PDFSimpleText(text: Str13_4 , style: bodyStyle))
        
        document.add(space: 10)
        let Str13_5 = "\t성 명 : \t(서명)"
        document.add(textObject: PDFSimpleText(text: Str13_5 , style: bodyStyle))
        return [document]
    }
}
