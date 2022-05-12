//
//  StandardContractFormVC.swift
//  PinPle
//
//  Created by seob on 2020/06/17.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class StandardContractFormVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    //계약서 단락 view - 6. 임금부터 만든상태.
    @IBOutlet weak var viewPay: UIView! // 6. 임금
    @IBOutlet weak var viewPaidSalary: UIView!  //7. 연차유급휴가
    
    @IBOutlet weak var lblSalary: UILabel! //연차유급휴가 내용
    @IBOutlet weak var viewSocialInsurance: UIView!  //8. 사회보험 적용여부
    @IBOutlet weak var viewLabolDelivery: UIView!  //9. 근로계약서 교부
    
    @IBOutlet weak var lblDelivery: UILabel! //근로계약서 교부 내용
    @IBOutlet weak var viewDuty: UIView!  //10. 근로계약, 취업규칙 등의 성실한 이행의무
    @IBOutlet weak var viewAnother: UIView!  //11. 기타
     @IBOutlet weak var lblanother: UILabel!
    //계약서 단락 view 끝
    
    //계약서 값 변동되는 labal
    @IBOutlet weak var lblComName: UILabel!  //상단 타이틀 회사명
    @IBOutlet weak var lblWorkerName: UILabel! //상단 타이블 근로자명
    @IBOutlet weak var lblWorkStartYear: UILabel!  //1. 근로개시일 년
    @IBOutlet weak var lblWorkStartMonth: UILabel! //1. 근로개시일 월
    @IBOutlet weak var lblWorkStartDay: UILabel! //1. 근로개시일 일
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
    @IBOutlet weak var lblAnotherYes: UILabel! //6. 임금 - 기타급여있음 체크
    @IBOutlet weak var lblAnotherNo: UILabel! //6. 임금 - 기타금여없음 체크
    @IBOutlet weak var lblAnotherOnePay: UILabel! //6. 임금 - 기타급여 첫번째 금액
    @IBOutlet weak var lblAnotherTwoPay: UILabel! //6. 임금 - 기타급여 두번째 금액
    @IBOutlet weak var lblAnotherThreePay: UILabel! //6. 임금 - 기타급여 세번째 금액
    @IBOutlet weak var lblAnotherFourPay: UILabel! //6. 임금 - 기타급여 네번째 금액
    @IBOutlet weak var lblPayDay: UILabel! //6. 임금 - 임금지급일
    @IBOutlet weak var lblDirectlyPay: UILabel!  //6. 임금 - 근로자에게 직접지급
    @IBOutlet weak var lblBankPay: UILabel!  //6. 임금 - 예급통장에 입금
  
    @IBOutlet weak var lblContractDay: UILabel!  //근로계약서 작성일
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
    
    
    //사회보험 적용여부 btn
    @IBOutlet weak var btnEmp: UIButton!
    @IBOutlet weak var btnInd: UIButton!
    @IBOutlet weak var btnPub: UIButton!
    @IBOutlet weak var btnHea: UIButton!
    //사회보험 적용여부 btn 끝
    //사회보험 적용여부 check 이미지
    @IBOutlet weak var imgCheckEmp: UIImageView!
    @IBOutlet weak var imgCheckInd: UIImageView!
    @IBOutlet weak var imgCheckPub: UIImageView!
    @IBOutlet weak var imgCheckHea: UIImageView!
    //사회보험 적용여부 check 이미지 끝
    
    var standInfo : LcEmpInfo = LcEmpInfo()
    var viewflagType = ""
    override func viewDidLoad() {
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        mainView.layer.borderWidth = 1
        
        //사회보험 적용여부 check 이미지 기본 보더
        imgCheckEmp.layer.borderWidth = 1
        imgCheckInd.layer.borderWidth = 1
        imgCheckPub.layer.borderWidth = 1
        imgCheckHea.layer.borderWidth = 1
        
        
        setUi()
    }
    
    fileprivate func setUi(){
        lblComName.text = CompanyInfo.name
        lblWorkerName.text = standInfo.name
        let startdt = getDateArray(standInfo.startdt)
        lblWorkStartYear.text = "\(startdt[0])"
        lblWorkStartMonth.text = "\(startdt[1])"
        lblWorkStartDay.text = "\(startdt[2])"
        lblWorkPlace.text = standInfo.place
        lblWorkContent.text = standInfo.task
        
        //소정 근로시간 시 , 분
        let worksttimeArr = standInfo.starttm.components(separatedBy: ":")
        lblWorkStartHour.text = worksttimeArr[0]
        lblWorkStartMin.text = worksttimeArr[1]
        
        let workendtimeArr = standInfo.endtm.components(separatedBy: ":")
        lblWorkEndHour.text = workendtimeArr[0]
        lblWorkEndMin.text = workendtimeArr[1]
        
        let bkstarttimeArr = standInfo.brkstarttm.components(separatedBy: ":")
        lblRestStartHour.text = workendtimeArr[0]
        lblRestStartMin.text = workendtimeArr[1]
        
        let bkendtimeArr = standInfo.brkendtm.components(separatedBy: ":")
        lblRestEndHour.text = bkendtimeArr[0]
        lblRestEndMin.text = bkendtimeArr[1]
        
        //기타급여
        lblAnotherOnePay.text = "\(DecimalWon(value: standInfo.otherpay))"
        
        //근로계약서 작성일
        let lcdt = getDateArray(standInfo.lcdt) //계약일
        lblContractDay.text = standInfo.lcdt
        
        //사업체명
        lblSignComName.text = CompanyInfo.name
        lblSignComAddr.text = CompanyInfo.addr
        lblSignComDelegate.text = CompanyInfo.ceoname
        lblSignComPhone.text = CompanyInfo.phone
        
        //근로자
        lblSignWorkAddr.text = standInfo.addr
        lblSignWorkPhone.text = standInfo.phonenum
        lblSignWorkName.text = standInfo.name
        
        //연차유급휴가
        if standInfo.anual != "" {
            viewPaidSalary.isHidden = false
            lblSalary.text = standInfo.anual
        }else{
            viewPaidSalary.isHidden = true
        }
        
        //근로 계약서 교부
        if standInfo.delivery != "" {
            viewLabolDelivery.isHidden = false
            lblDelivery.text = standInfo.delivery
        }else{
             viewLabolDelivery.isHidden = true
        }
        
        //기타
        lblanother.text = standInfo.other
    }
    
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "Lc_Step7VC" {
            var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
            if SE_flag {
                vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
             if viewflagType == "stand_step5" {
                vc.standInfo = self.standInfo
                vc.viewflagType = "stand_step5"
             }else{
                vc.selInfo = self.standInfo
            }
            self.present(vc, animated: false, completion: nil)
        }else{
            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
            if SE_flag {
                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }

        
    }
}
