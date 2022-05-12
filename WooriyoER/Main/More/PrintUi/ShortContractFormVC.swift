//
//  ShortContractFormVC.swift
//  PinPle
//
//  Created by seob on 2020/06/17.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ShortContractFormVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    //계약서 단락 view
    @IBOutlet weak var viewWorkStartDay: UIView!  // 1. 근로개시일
    @IBOutlet weak var viewWorkPlace: UIView!  //2. 근무장소
    @IBOutlet weak var viewWorkContent: UIView!  //3. 업무 내용
    @IBOutlet weak var viewWorkTime: UIView!  //4. 근로일 및 근로일별 근로시간
    @IBOutlet weak var viewPay: UIView! // 5. 임금
    @IBOutlet weak var viewPaidSalary: UIView!  //6. 연차유급휴가
    @IBOutlet weak var viewSocialInsurance: UIView!  //7. 사회보험 적용여부
    @IBOutlet weak var viewLabolDelivery: UIView!  //8. 근로계약서 교부
    @IBOutlet weak var viewDuty: UIView!  //9. 근로계약, 취업규칙 등의 성실한 이행의무
    @IBOutlet weak var viewAnother: UIView!  //10. 기타
    @IBOutlet weak var viewSignCom: UIView! //사업주 서명
    @IBOutlet weak var viewSignWork: UIView! //근로자 서명
    //계약서 단락 view 끝
    
    //계약서 값 변동되는 labal - 표부분 제외
    @IBOutlet weak var lblComName: UILabel!  //상단 타이틀 회사명
    @IBOutlet weak var lblWorkerName: UILabel! //상단 타이블 근로자명
    @IBOutlet weak var lblWorkStartYear: UILabel!  //1. 근로개시일 년
    @IBOutlet weak var lblWorkStartMonth: UILabel! //1. 근로개시일 월
    @IBOutlet weak var lblWorkStartDay: UILabel! //1. 근로개시일 일
    @IBOutlet weak var lblWorkPlace: UILabel! //2. 근무장소
    @IBOutlet weak var lblWorkContent: UILabel! //3. 업무 내용
    @IBOutlet weak var lblRestWeek: UILabel! //4. 주휴일
    @IBOutlet weak var lblBasicPay: UILabel! //5. 임금 - 월(일, 시간)급 액수
    @IBOutlet weak var lblBonusYes: UILabel!  //5. 임금 - 상여금있음 체크
    @IBOutlet weak var lblBonusNo: UILabel! //5. 임금 - 상여금없음 체크
    @IBOutlet weak var lblBonusPay: UILabel!  //5. 임금 - 상여금 액수
    @IBOutlet weak var lblAnotherTotalPay: UILabel! //5. 임금 - 기타급여 전체
    @IBOutlet weak var lblAnotherNo: UILabel! //5. 임금 - 기타금여없음 체크
    @IBOutlet weak var lblOverTimeAdd: UILabel!  //5. 임금 - 초과근로에 대한 가산임금률
    @IBOutlet weak var lblPayDay: UILabel! //5. 임금 - 임금지급일
    @IBOutlet weak var lblDirectlyPay: UILabel!  //5. 임금 - 근로자에게 직접지급
    @IBOutlet weak var lblBankPay: UILabel!  //5. 임금 - 예급통장에 입금
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
    
    //표 sell 구성 객체
    @IBOutlet weak var viewTable: UIView!  //표 메인
    @IBOutlet weak var lblSellOneOne: UILabel!
    @IBOutlet weak var viewSellOneTwo: UIView!
    @IBOutlet weak var viewSellOneThree: UIView!
    @IBOutlet weak var viewSellOneFour: UIView!
    @IBOutlet weak var viewSellOneFive: UIView!
    @IBOutlet weak var viewSellOneSix: UIView!
    @IBOutlet weak var viewSellOneSeven: UIView!
    @IBOutlet weak var lblSellTwoOne: UILabel!
    @IBOutlet weak var viewSellTwoTwo: UIView!
    @IBOutlet weak var viewSellTwoThree: UIView!
    @IBOutlet weak var viewSellTwoFour: UIView!
    @IBOutlet weak var viewSellTwoFive: UIView!
    @IBOutlet weak var viewSellTwoSix: UIView!
    @IBOutlet weak var viewSellTwoSeven: UIView!
    @IBOutlet weak var lblSellThreeOne: UILabel!
    @IBOutlet weak var viewSellThreeTwo: UIView!
    @IBOutlet weak var viewSellThreeThree: UIView!
    @IBOutlet weak var viewSellThreeFour: UIView!
    @IBOutlet weak var viewSellThreeFive: UIView!
    @IBOutlet weak var viewSellThreeSix: UIView!
    @IBOutlet weak var viewSellThreeSeven: UIView!
    @IBOutlet weak var lblSellFourOne: UILabel!
    @IBOutlet weak var viewSellFourTwo: UIView!
    @IBOutlet weak var viewSellFourThree: UIView!
    @IBOutlet weak var viewSellFourFour: UIView!
    @IBOutlet weak var viewSellFourFive: UIView!
    @IBOutlet weak var viewSellFourSix: UIView!
    @IBOutlet weak var viewSellFourSeven: UIView!
    @IBOutlet weak var lblSellFiveOne: UILabel!
    @IBOutlet weak var viewSellFiveTwo: UIView!
    @IBOutlet weak var viewSellFiveThree: UIView!
    @IBOutlet weak var viewSellFiveFour: UIView!
    @IBOutlet weak var viewSellFiveFive: UIView!
    @IBOutlet weak var viewSellFiveSix: UIView!
    @IBOutlet weak var viewSellFiveSeven: UIView!
    //표 sell 구성 객체 끝
    
    //sell 내부 라벨
    @IBOutlet weak var lblSellOneTwo: UILabel!
    @IBOutlet weak var lblSellOneThree: UILabel!
    @IBOutlet weak var lblSellOneFour: UILabel!
    @IBOutlet weak var lblSellOneFive: UILabel!
    @IBOutlet weak var lblSellOneSix: UILabel!
    @IBOutlet weak var lblSellOneSeven: UILabel!
    @IBOutlet weak var lblSellTwoTwo: UILabel!
    @IBOutlet weak var lblSellTwoThree: UILabel!
    @IBOutlet weak var lblSellTwoFour: UILabel!
    @IBOutlet weak var lblSellTwoFive: UILabel!
    @IBOutlet weak var lblSellTwoSix: UILabel!
    @IBOutlet weak var lblSellTwoSeven: UILabel!
    @IBOutlet weak var lblSellThreeTwoHour: UILabel!
    @IBOutlet weak var lblSellThreeTwoMin: UILabel!
    @IBOutlet weak var lblSellThreeThreeHour: UILabel!
    @IBOutlet weak var lblSellThreeThreeMin: UILabel!
    @IBOutlet weak var lblSellThreeFourHour: UILabel!
    @IBOutlet weak var lblSellThreeFourMin: UILabel!
    @IBOutlet weak var lblSellThreeFiveHour: UILabel!
    @IBOutlet weak var lblSellThreeFiveMin: UILabel!
    @IBOutlet weak var lblSellThreeSixHour: UILabel!
    @IBOutlet weak var lblSellThreeSixMin: UILabel!
    @IBOutlet weak var lblSellThreeSevenHour: UILabel!
    @IBOutlet weak var lblSellThreeSevenMin: UILabel!
    @IBOutlet weak var lblSellFourTwoHour: UILabel!
    @IBOutlet weak var lblSellFourTwoMin: UILabel!
    @IBOutlet weak var lblSellFourThreeHour: UILabel!
    @IBOutlet weak var lblSellFourThreeMin: UILabel!
    @IBOutlet weak var lblSellFourFourHour: UILabel!
    @IBOutlet weak var lblSellFourFourMin: UILabel!
    @IBOutlet weak var lblSellFourFiveHour: UILabel!
    @IBOutlet weak var lblSellFourFiveMin: UILabel!
    @IBOutlet weak var lblSellFourSixHour: UILabel!
    @IBOutlet weak var lblSellFourSixMin: UILabel!
    @IBOutlet weak var lblSellFourSevenHour: UILabel!
    @IBOutlet weak var lblSellFourSevenMin: UILabel!
    @IBOutlet weak var lblSellFiveTwoStartHour: UILabel!
    @IBOutlet weak var lblSellFiveTwoStartMin: UILabel!
    @IBOutlet weak var lblSellFiveTwoEndHour: UILabel!
    @IBOutlet weak var lblSellFiveTwoEndMin: UILabel!
    @IBOutlet weak var lblSellFiveThreeStartHour: UILabel!
    @IBOutlet weak var lblSellFiveThreeStartMin: UILabel!
    @IBOutlet weak var lblSellFiveThreeEndHour: UILabel!
    @IBOutlet weak var lblSellFiveThreeEndMin: UILabel!
    @IBOutlet weak var lblSellFiveFourStartHour: UILabel!
    @IBOutlet weak var lblSellFiveFourStartMin: UILabel!
    @IBOutlet weak var lblSellFiveFourEndHour: UILabel!
    @IBOutlet weak var lblSellFiveFourEndMin: UILabel!
    @IBOutlet weak var lblSellFiveFiveStartHour: UILabel!
    @IBOutlet weak var lblSellFiveFiveStartMin: UILabel!
    @IBOutlet weak var lblSellFiveFiveEndHour: UILabel!
    @IBOutlet weak var lblSellFiveFiveEndMin: UILabel!
    @IBOutlet weak var lblSellFiveSixStartHour: UILabel!
    @IBOutlet weak var lblSellFiveSixStartMin: UILabel!
    @IBOutlet weak var lblSellFiveSixEndHour: UILabel!
    @IBOutlet weak var lblSellFiveSixEndMin: UILabel!
    @IBOutlet weak var lblSellFiveSevenStartHour: UILabel!
    @IBOutlet weak var lblSellFiveSevenStartMin: UILabel!
    @IBOutlet weak var lblSellFiveSevenEndHour: UILabel!
    @IBOutlet weak var lblSellFiveSevenEndMin: UILabel!
    //sell 내부 라벨 끝
    
    
    
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
        //표 점선
        
        let borderSell:CGFloat = 0.24
        viewTable.layer.borderWidth = 1
        lblSellOneOne.layer.borderWidth = borderSell
        viewSellOneTwo.layer.borderWidth = borderSell
        viewSellOneThree.layer.borderWidth = borderSell
        viewSellOneFour.layer.borderWidth = borderSell
        viewSellOneFive.layer.borderWidth = borderSell
        viewSellOneSix.layer.borderWidth = borderSell
        viewSellOneSeven.layer.borderWidth = borderSell
        lblSellTwoOne.layer.borderWidth = borderSell
        viewSellTwoTwo.layer.borderWidth = borderSell
        viewSellTwoThree.layer.borderWidth = borderSell
        viewSellTwoFour.layer.borderWidth = borderSell
        viewSellTwoFive.layer.borderWidth = borderSell
        viewSellTwoSix.layer.borderWidth = borderSell
        viewSellTwoSeven.layer.borderWidth = borderSell
        lblSellThreeOne.layer.borderWidth = borderSell
        viewSellThreeTwo.layer.borderWidth = borderSell
        viewSellThreeThree.layer.borderWidth = borderSell
        viewSellThreeFour.layer.borderWidth = borderSell
        viewSellThreeFive.layer.borderWidth = borderSell
        viewSellThreeSix.layer.borderWidth = borderSell
        viewSellThreeSeven.layer.borderWidth = borderSell
        lblSellFourOne.layer.borderWidth = borderSell
        viewSellFourTwo.layer.borderWidth = borderSell
        viewSellFourThree.layer.borderWidth = borderSell
        viewSellFourFour.layer.borderWidth = borderSell
        viewSellFourFive.layer.borderWidth = borderSell
        viewSellFourSix.layer.borderWidth = borderSell
        viewSellFourSeven.layer.borderWidth = borderSell
        lblSellFiveOne.layer.borderWidth = borderSell
        viewSellFiveTwo.layer.borderWidth = borderSell
        viewSellFiveThree.layer.borderWidth = borderSell
        viewSellFiveFour.layer.borderWidth = borderSell
        viewSellFiveFive.layer.borderWidth = borderSell
        viewSellFiveSix.layer.borderWidth = borderSell
        viewSellFiveSeven.layer.borderWidth = borderSell
        
        
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
