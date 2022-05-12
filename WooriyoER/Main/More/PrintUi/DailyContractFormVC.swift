//
//  DailyContractFormVC.swift
//  PinPle
//
//  Created by seob on 2020/06/17.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class DailyContractFormVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    //계약서 단락 view
    @IBOutlet weak var viewWorkStartDay: UIView!  // 1. 근로개시일
    @IBOutlet weak var viewWorkPlace: UIView!  //2. 근무장소
    @IBOutlet weak var viewWorkContent: UIView!  //3. 업무 내용
    @IBOutlet weak var viewWorkTime: UIView!  //4. 소정근로시간
    @IBOutlet weak var viewWorkWeek: UIView! //5. 근무일/휴일
    @IBOutlet weak var viewPay: UIView! // 6. 임금
    @IBOutlet weak var viewPaidSalary: UIView!  //7. 연차유급휴가
    @IBOutlet weak var viewSocialInsurance: UIView!  //8. 사회보험 적용여부
    @IBOutlet weak var viewLabolDelivery: UIView!  //9. 근로계약서 교부
    @IBOutlet weak var viewDuty: UIView!  //10. 근로계약, 취업규칙 등의 성실한 이행의무
    @IBOutlet weak var viewAnother: UIView!  //11. 기타
    @IBOutlet weak var viewSignCom: UIView! //사업주 서명
    @IBOutlet weak var viewSignWork: UIView! //근로자 서명
    //계약서 단락 view 끝
    
    //계약서 값 변동되는 labal
    @IBOutlet weak var lblComName: UILabel!  //상단 타이틀 회사명
    @IBOutlet weak var lblWorkerName: UILabel! //상단 타이블 근로자명
    @IBOutlet weak var lblWorkStartYear: UILabel!  //1. 근로개시일 년
    @IBOutlet weak var lblWorkStartMonth: UILabel! //1. 근로개시일 월
    @IBOutlet weak var lblWorkStartDay: UILabel! //1. 근로개시일 일
    @IBOutlet weak var lblWorkEndYear: UILabel! //1. 근로개시일 종료년
    @IBOutlet weak var lblWorkEndMonth: UILabel!  //1. 근로개시일 종료월
    @IBOutlet weak var lblWorkEndDay: UILabel!  //1. 근로개시일 종료일
    @IBOutlet weak var lblWorkPlace: UILabel! //2. 근무장소
    @IBOutlet weak var lblWorkContent: UILabel! //3. 업무 내용
    @IBOutlet weak var lblWorkStartHour: UILabel! //4. 소정근로시간 근로시작 시
    @IBOutlet weak var lblWorkStartMin: UILabel!  //4. 소정근로시간 근로시작 분
    @IBOutlet weak var lblWorkEndHour: UILabel!  //4. 소정근로시간 근로종료 시
    @IBOutlet weak var lblWorkEndMin: UILabel! //4. 소정근로시간 근로종료 분
    @IBOutlet weak var lblRestStartHour: UILabel! //4. 소정근로시간 휴게시작 시
    @IBOutlet weak var lblRestStartMin: UILabel! //4. 소정근로시간 휴게시작 분
    @IBOutlet weak var lblRestEndHour: UILabel!  //4. 소정근로시간 휴게종료 시
    @IBOutlet weak var lblRestEndMin: UILabel! //4. 소정근로시간 휴게종료 분
    @IBOutlet weak var lblWorkWeek: UILabel! //5. 근무일/휴일 근무일
    @IBOutlet weak var lblRestWeek: UILabel! //5. 근무일/휴일 휴일
    @IBOutlet weak var lblBasicPay: UILabel! //6. 임금 - 월(일, 시간)급 액수
    @IBOutlet weak var lblBonusYes: UILabel!  //6. 임금 - 상여금있음 체크
    @IBOutlet weak var lblBonusNo: UILabel! //6. 임금 - 상여금없음 체크
    @IBOutlet weak var lblBonusPay: UILabel!  //6. 임금 - 상여금 액수
    @IBOutlet weak var lblAnotherTotalPay: UILabel! //6. 임금 - 기타급여 전체
    @IBOutlet weak var lblAnotherTimePay: UILabel!  //6. 임금 - 기타급여 시간외근로수당 액수
    @IBOutlet weak var lblAnotherTimeMin: UILabel! //6. 임금 - 기타급여 시간외근로시간
    @IBOutlet weak var lblAnotherNightPay: UILabel!  //6. 임금 - 기타급여 야간근로수당 액수
    @IBOutlet weak var lblAnotherNightMin: UILabel! //6. 임금 - 기타급여 야간근로시간
    @IBOutlet weak var lblAnotherHolidayPay: UILabel! //6. 임금 - 기타급여 휴일근로수당 액수
    @IBOutlet weak var lblAnotherHolidayMin: UILabel!  //6. 임금 - 기타급여 휴일근로시간
    @IBOutlet weak var lblPayDay: UILabel! //6. 임금 - 임금지급일
    @IBOutlet weak var lblDirectlyPay: UILabel!  //6. 임금 - 근로자에게 직접지급
    @IBOutlet weak var lblBankPay: UILabel!  //6. 임금 - 예급통장에 입금
    @IBOutlet weak var lblContractYear: UILabel! //근로계약서 작성일 년
    @IBOutlet weak var lblContractMonth: UILabel! //근로계약서 작성일 월
    @IBOutlet weak var lblContractDay: UILabel!  //근로계약서 작성일 일
    @IBOutlet weak var lblSignComName: UILabel! //사업주 서명작성란 사업체명
    @IBOutlet weak var lblSignComAddr: UILabel! //사업주 서명작성란 주소
    @IBOutlet weak var lblSignComDelegate: UILabel! //사업주 서명작성란 대표자
    @IBOutlet weak var lblSignComPhone: UILabel!  //사업주 서명작성란 전화번호
    @IBOutlet weak var lblSignComSign: UILabel! //사업주 서명작성란 서명
    @IBOutlet weak var lblSignWorkAddr: UILabel! //근로자 서명작성란 주소
    @IBOutlet weak var lblSignWorkPhone: UILabel! //근로자 서명작성란 연락처
    @IBOutlet weak var lblSignWorkName: UILabel! //근로자 서명작성란 이름
    @IBOutlet weak var lblSignWorkSign: UILabel!  //근로자 서명작성란 서명
    //계약서 값 변동되는 labal 끝
    
    //사회보험 적용여부 check 이미지
    @IBOutlet weak var imgCheckEmp: UIImageView! //고용
    @IBOutlet weak var imgCheckInd: UIImageView! //산재
    @IBOutlet weak var imgCheckPub: UIImageView! //국민
    @IBOutlet weak var imgCheckHea: UIImageView! //건강
    //사회보험 적용여부 check 이미지 끝
    
    override func viewDidLoad() {
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        mainView.layer.borderWidth = 1
        imgCheckEmp.layer.borderWidth = 1
        imgCheckInd.layer.borderWidth = 1
        imgCheckPub.layer.borderWidth = 1
        imgCheckHea.layer.borderWidth = 1
    }
    
    @IBAction func barBack(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
}
