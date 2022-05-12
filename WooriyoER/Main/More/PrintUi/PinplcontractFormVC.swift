//
//  PinplcontractFormVC.swift
//  PinPle
//
//  Created by seob on 2020/06/16.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import PDFKit

class PinplcontractFormVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UIView!  //급여계산 테이블
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitleText: UILabel! //근로계약서 타이틀
    
    
    //title lable - 실제 데이터 변경되는 labal
    @IBOutlet weak var lblTitleCom: UILabel! //회사명(갑)
    @IBOutlet weak var lblWorker: UILabel! //근로자명(을)
    //title lable 끝
    
    //상단 label - 실제 데이터 변경되는 labal
    @IBOutlet weak var lblWorkDate: UILabel! //근로개시일
    @IBOutlet weak var lblWorkendDate: UILabel! //근로종료일
    @IBOutlet weak var lblAnnualDate: UILabel! //연봉적용일
    @IBOutlet weak var lblAnnualendDate: UILabel! //연봉종료적용일
    @IBOutlet weak var lblPlace: UILabel! //근무지
    @IBOutlet weak var lblTask: UILabel! //담당업무
    @IBOutlet weak var lblWorkStartTime: UILabel! //근로시작시간
    @IBOutlet weak var lblWorkEndTime: UILabel! //근로종료시간
    @IBOutlet weak var lblTotalWorkTime: UILabel! //총근로시간 (8시간)
    @IBOutlet weak var lblRestStartTime: UILabel! //휴게시작시간
    @IBOutlet weak var lblRestEndTime: UILabel! //휴게종료시간
    @IBOutlet weak var lblTotalRestTime: UILabel! //총휴게시간 (1시간)
    @IBOutlet weak var lblSalaryDate: UILabel! //입금지급날짜
    //일반 label 끝
    
    //tableView 내부 view 및 label
    //고정 text - 레이아웃용으로만 사용
    @IBOutlet weak var lblSortation: UILabel! //구분
    @IBOutlet weak var lblBasis: UILabel! //산출근거
    @IBOutlet weak var lblMonSalary: UILabel! //월급여
    @IBOutlet weak var lblBasicSalary: UILabel! //기본급
    @IBOutlet weak var lblPosition: UILabel! //직책수당
    @IBOutlet weak var lblOvertime: UILabel! //연장수당
    @IBOutlet weak var lblHoliday: UILabel!  //휴일수당
    @IBOutlet weak var lblBonus: UILabel! //상여금
    @IBOutlet weak var lblWelfare: UILabel! //복지후생
    @IBOutlet weak var lblOutside: UILabel! //기타
    @IBOutlet weak var lblNontaxable: UILabel! //비과세
    @IBOutlet weak var lblEat: UILabel! //식대
    @IBOutlet weak var lblResearch: UILabel! //연구보조비
    @IBOutlet weak var lblChlidCare: UILabel!  //자녀보육수당
    @IBOutlet weak var lblCar: UILabel! //차량유지비
    @IBOutlet weak var lblBoard: UILabel! //일직&숙식비
    @IBOutlet weak var lblSubtotal: UILabel! //소계
    @IBOutlet weak var lblTotal: UILabel! //합계
    @IBOutlet weak var lblNationalHoliday: UILabel!  //명절수당
    @IBOutlet weak var lblTotalCalculation: UILabel!  //총연봉급여
    @IBOutlet weak var lblAccount: UILabel!  //지급계좌
    @IBOutlet weak var lblDepositary: UILabel!  //예금주
    @IBOutlet weak var lblAccountNum: UILabel! //계좌번호
    @IBOutlet weak var lblBank: UILabel! //금융기관
    //고정 text 끝
    //동적 text - 실제 데이터 변경되는 labal
    @IBOutlet weak var lblBasicPay: UILabel! //기본급 액수
    @IBOutlet weak var lblPositionPay: UILabel! //직책수당 액수
    @IBOutlet weak var lblOvertimePay: UILabel! //연장수당 액수
    @IBOutlet weak var lblHolidayPay: UILabel! //휴일수당 액수
    @IBOutlet weak var lblBonusPay: UILabel! //상여금 액수
    @IBOutlet weak var lblWelfarePay: UILabel! //복지후생 액수
    @IBOutlet weak var lblOutsidePay: UILabel! //기타 액수
    @IBOutlet weak var lblEatPay: UILabel! //식대 액수
    @IBOutlet weak var lblResearchPay: UILabel! //연구보조비 액수
    @IBOutlet weak var lblChlidCarePay: UILabel! //자녀보육수당 액수
    @IBOutlet weak var lblCarPay: UILabel! //차량유지비 액수
    @IBOutlet weak var lblBoardPay: UILabel! //일직&숙직비 액수
    @IBOutlet weak var lblSubtotalPay: UILabel! //소계 액수
    @IBOutlet weak var lblTotalPay: UILabel! //합계액수
    @IBOutlet weak var lblNationalHolidayPay: UILabel! //명절수당 액수
    @IBOutlet weak var lblTotalCalculationPay: UILabel! //총연봉급여 액수
    @IBOutlet weak var lblDepositaryName: UILabel! //예금주 이름
    @IBOutlet weak var lblAccountNumber: UILabel! //계좌번호 숫자
    @IBOutlet weak var lblBankName: UILabel! //금융기관 이름
    @IBOutlet weak var lblBasicBasis: UILabel! //기본급 산출근거
    @IBOutlet weak var lblPositionBasis: UILabel! //직책수당 산출근거
    @IBOutlet weak var lblOvertimeBasis: UILabel! //연장수당 산출근거
    @IBOutlet weak var lblHolidayBasis: UILabel! //휴일수당 산출근거
    @IBOutlet weak var lblBonusBasis: UILabel! //휴일수당 산출근거
    @IBOutlet weak var lblWelfareBasis: UILabel! //복지후생 산출근거
    @IBOutlet weak var lblOutsideBasis: UILabel! //기타금액 산출근거
    @IBOutlet weak var lblEatBasis: UILabel! //식대 산출근거
    @IBOutlet weak var lblResearchBasis: UILabel! //연구보조비 산출근거
    @IBOutlet weak var lblChlidCareBasis: UILabel! //자녀보육수당 산출근거
    @IBOutlet weak var lblCarBasis: UILabel!  //차량유지비 산출근거
    @IBOutlet weak var lblBoardBasis: UILabel! //일직&숙식비 산출근거
    @IBOutlet weak var lblSubtotalBasis: UILabel!  //소계 산출근거
    @IBOutlet weak var lblTotalBasis: UILabel!  //합계 산출근거
    @IBOutlet weak var lblNationalHolidayBasis: UILabel! //명절수당 산출근거
    @IBOutlet weak var viewChlidCare: UIView! //자녀보육수당 view
    //동적 text 끝
    //tableView 내부 view 및 label 끝
    
    //제외 가능 view들
    @IBOutlet weak var viewInsurance: UIView! //사회보험 가입 view
    @IBOutlet weak var viewPaidVacation: UIView! //연차유급휴가 view
    @IBOutlet weak var viewContractIssue: UIView! //근로계약서교부 view
    @IBOutlet weak var viewOutside: UIView! //기타사항 view
    
    @IBOutlet weak var lblDelivery: UILabel! //근로계약서교부
    @IBOutlet weak var lblInsurance: UILabel! //사회보험
    @IBOutlet weak var lblanual: UILabel! //연차유급휴가
    @IBOutlet weak var lblother: UILabel! //기타사항
    
    //제외 가능 view 끝
    
    @IBOutlet weak var lblContractDate: UILabel! //근로계약서 작성일
    
    //작성자 정보 labal - 실제 데이터 변경되는 labal
    @IBOutlet weak var lblComAddr: UILabel! //갑 주소
    @IBOutlet weak var lblComNum: UILabel! //사업자등록번호
    @IBOutlet weak var lblComName: UILabel! //회사명
    @IBOutlet weak var lblComPhoneNum: UILabel! //갑 연락처
    @IBOutlet weak var lblComBossName: UILabel! //대표명
    @IBOutlet weak var lblWorkerAddr: UILabel! // 을 주소
    @IBOutlet weak var lblWorkerBirthday: UILabel! //을 생년월일
    @IBOutlet weak var lblWorkerPhoneNum: UILabel! //을 연락처
    @IBOutlet weak var lblWorkerName: UILabel! //을 이름
    
    @IBOutlet weak var lblholidayFirst: UILabel! //휴무일 첫번째. ( 탭3칸 -  주휴일은 매주 일요일, 「근로자의날제정에관한법률」에 따른 근로자의 날(5월1일)은 유급휴일.)
    @IBOutlet weak var lblholidaySeond: UILabel! //    -  1주간 소정근로일에 개근 시 일요일을 유급 주휴일로 부여, 토요일은 무급 휴무로 부여.
    
    @IBOutlet weak var ComsealImageView: UIImageView!
     @IBOutlet weak var lblworkday: UILabel! //근무일
    @IBOutlet weak var lblRestpayDay: UILabel! //휴무일 유급 요일
    @IBOutlet weak var lblRestnopayDay: UILabel! //휴무일 무급 요일
    var selInfo : LcEmpInfo = LcEmpInfo()
    
    var initialFontSize: CGFloat! // 글자 크기를 저장하기 위한 변수
    
    var viewflagType = ""
 
    override func viewDidLoad() {
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        print("\n---------- [ viewflag : \(viewflag) ] ----------\n")
        setLayoutUi()
 
     }
    
    fileprivate func setLayoutUi() {
//        mainView.layer.borderWidth = 1;
        
        tableView.layer.borderWidth = 1.5;
        
        
        //급여계산 테이블안에 모든 view를 선택할 수 없어서 각각 선택후 border 생성
        lblSortation.layer.borderWidth = 0.5
        lblBasis.layer.borderWidth = 0.5
        lblMonSalary.layer.borderWidth = 0.5
        lblBasicSalary.layer.borderWidth = 0.5
        lblPosition.layer.borderWidth = 0.5
        lblOvertime.layer.borderWidth = 0.5
        lblHoliday.layer.borderWidth = 0.5
        lblBonus.layer.borderWidth = 0.5
        lblWelfare.layer.borderWidth = 0.5
        lblOutside.layer.borderWidth = 0.5
        lblNontaxable.layer.borderWidth = 0.5
        lblEat.layer.borderWidth = 0.5
        lblResearch.layer.borderWidth = 0.5
        lblChlidCare.layer.borderWidth = 0.5
        lblCar.layer.borderWidth = 0.5
        lblBoard.layer.borderWidth = 0.5
        lblSubtotal.layer.borderWidth = 0.5
        lblTotal.layer.borderWidth = 0.5
        lblNationalHoliday.layer.borderWidth = 0.5
        lblTotalCalculation.layer.borderWidth = 0.5
        lblAccount.layer.borderWidth = 0.5
        
        
        lblBasicPay.layer.borderWidth = 0.5
        lblPositionPay.layer.borderWidth = 0.5
        lblOvertimePay.layer.borderWidth = 0.5
        lblHolidayPay.layer.borderWidth = 0.5
        lblBonusPay.layer.borderWidth = 0.5
        lblWelfarePay.layer.borderWidth = 0.5
        lblOutsidePay.layer.borderWidth = 0.5
        lblEatPay.layer.borderWidth = 0.5
        lblResearchPay.layer.borderWidth = 0.5
        lblChlidCarePay.layer.borderWidth = 0.5
        lblCarPay.layer.borderWidth = 0.5
        lblBoardPay.layer.borderWidth = 0.5
        lblSubtotalPay.layer.borderWidth = 0.5
        lblTotalPay.layer.borderWidth = 0.5
        lblNationalHolidayPay.layer.borderWidth = 0.5
        lblTotalCalculationPay.layer.borderWidth = 0.5
        
        lblBasicBasis.layer.borderWidth = 0.5
        lblPositionBasis.layer.borderWidth = 0.5
        lblOvertimeBasis.layer.borderWidth = 0.5
        lblHolidayBasis.layer.borderWidth = 0.5
        lblBonusBasis.layer.borderWidth = 0.5
        lblWelfareBasis.layer.borderWidth = 0.5
        lblOutsideBasis.layer.borderWidth = 0.5
        lblEatBasis.layer.borderWidth = 0.5
        lblResearchBasis.layer.borderWidth = 0.5
        
        lblCarBasis.layer.borderWidth = 0.5
        lblBoardBasis.layer.borderWidth = 0.5
        lblSubtotalBasis.layer.borderWidth = 0.5
        lblTotalBasis.layer.borderWidth = 0.5
        lblNationalHolidayBasis.layer.borderWidth = 0.5
        viewChlidCare.layer.borderWidth = 0.5
        
        //특정부분만 border 추가할때 사용하는 함수
        lblDepositary.layer.addBorder([.left, .top, .bottom], color: UIColor.black, width: 0.5)
        lblDepositaryName.layer.addBorder([.right, .top, .bottom], color: UIColor.black, width: 0.5)
        lblAccountNum.layer.addBorder([.left, .top, .bottom], color: UIColor.black, width: 0.5)
        lblAccountNumber.layer.addBorder([.right, .top, .bottom], color: UIColor.black, width: 0.5)
        lblBank.layer.addBorder([.left, .top, .bottom], color: UIColor.black, width: 0.5)
        lblBankName.layer.addBorder([.right, .top, .bottom], color: UIColor.black, width: 0.5)
        
        
        
        //디바이스 높이에 따라 스크롤없애주는 로직
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height //화면 높이
        print("height \(height)")
        let scrollViewHeight:CGFloat  = scrollView.frame.height;
        if height >  scrollViewHeight + 5 {
            mainHeight.constant = scrollViewHeight
        }
        
        print("\n---------- [ PrintsFileImage : \(PrintsFileImage) ] ----------\n")
    }
 
    
    fileprivate func setUi(){
        lblTitleCom.text = CompanyInfo.name
        lblWorker.text = selInfo.name
        
        lblWorkDate.text = dateformatKo(selInfo.startdt) + "부터"
        lblWorkendDate.text = dateformatKo(selInfo.enddt) + "까지"
        
        lblAnnualDate.text = dateformatKo(selInfo.paystartdt) + "부터"
        lblAnnualendDate.text = dateformatKo(selInfo.payenddt) + "까지"
        
        lblPlace.text = selInfo.place
        lblTask.text = selInfo.task
        lblWorkStartTime.text = substringTime(selInfo.starttm.timeTrim()) + "부터"
        lblWorkEndTime.text = substringTime(selInfo.endtm.timeTrim()) + "까지"
        
        var Cellworkmin = 0
        if (selInfo.starttm.timeTrim() != "" && selInfo.endtm.timeTrim() != ""){
            Cellworkmin = self.calTotalTime(selInfo.starttm.timeTrim(), selInfo.endtm.timeTrim(), selInfo.brkstarttm.timeTrim(), selInfo.brkendtm.timeTrim())
        }else{
            Cellworkmin = 0
        }
        
        lblTotalWorkTime.text = getMinTohm(Int(Cellworkmin.magnitude))
        
        lblRestStartTime.text = substringTime(selInfo.brkstarttm.timeTrim()) + "부터"
        lblRestEndTime.text = substringTime(selInfo.brkendtm.timeTrim()) + "까지"
        
        var Cellbkmin = 0
        if (selInfo.brkstarttm.timeTrim() != "" && selInfo.brkendtm.timeTrim() != ""){
            Cellbkmin = self.bkTotalTime(selInfo.brkstarttm.timeTrim(), selInfo.brkendtm.timeTrim())
        }else{
            Cellbkmin = 0
        }
        lblTotalRestTime.text = getMinTohm(Int(Cellbkmin.magnitude))
         
        lblworkday.text =  "\(workingDay(selInfo.workday))" //근무일
        lblholidayFirst.text = "-  주휴일은 매주 \(workdayStr(selInfo.workday, 2)),"
        lblRestpayDay.text = "\(workdayStr(selInfo.workday, 2))을"
        lblRestnopayDay.text = "\(workdayStr(selInfo.workday, 1))은 무급 휴무로 부여."
  
        let totalpay = selInfo.basepay + selInfo.pstnpay + selInfo.ovrtmpay + selInfo.hldypay + selInfo.bonus + selInfo.benefits + selInfo.otherpay + selInfo.meals + selInfo.rsrchsbdy + selInfo.chldexpns + selInfo.vhclmncst + selInfo.jobexpns
        //월급여
        lblBasicPay.text = "\(DecimalWon(value: selInfo.basepay))"
        lblPositionPay.text = "\(DecimalWon(value: selInfo.pstnpay))"
        lblOvertimePay.text = "\(DecimalWon(value: selInfo.ovrtmpay))"
        lblHolidayPay.text = "\(DecimalWon(value: selInfo.hldypay))"
        lblBonusPay.text = "\(DecimalWon(value: selInfo.bonus))"
        lblWelfarePay.text = "\(DecimalWon(value: selInfo.benefits))"
        lblOutsidePay.text = "\(DecimalWon(value: selInfo.otherpay))"
        lblEatPay.text = "\(DecimalWon(value: selInfo.meals))"
        lblResearchPay.text = "\(DecimalWon(value: selInfo.rsrchsbdy))"
        lblChlidCarePay.text = "\(DecimalWon(value: selInfo.chldexpns))"
        lblCarPay.text = "\(DecimalWon(value: selInfo.vhclmncst))"
        lblBoardPay.text = "\(DecimalWon(value: selInfo.jobexpns))"
        
        let subTotalPay = selInfo.meals + selInfo.rsrchsbdy + selInfo.chldexpns + selInfo.vhclmncst + selInfo.jobexpns
        lblSubtotalPay.text = "\(DecimalWon(value: subTotalPay))" //소개 (식대+연구보조비+자녀보육수당+차량유지비+일직)
        lblTotalPay.text = "\(DecimalWon(value: totalpay))" //합계
        
        lblNationalHolidayPay.text = "\(DecimalWon(value: selInfo.hldyalwnc * 2))"
        lblTotalCalculationPay.text = "\(DecimalWon(value: selInfo.yearpay))"
        
        lblDepositaryName.text =  selInfo.actholder
        lblAccountNumber.text =  selInfo.actnum
        lblBankName.text =  selInfo.actbank
        
        if selInfo.payday != "" {
            lblSalaryDate.text = selInfo.payday
        }else {
            lblSalaryDate.text = defaultPayDayText
        }
        if selInfo.delivery != "" {
            lblDelivery.text = selInfo.delivery
        }else {
            viewContractIssue.isHidden = true
        }
        
        if selInfo.socialinsrn != "" {
            var strSocial = ""
            if selInfo.socialinsrn.contains("1") {
                strSocial += "국민연금"
            }
            
            if selInfo.socialinsrn.contains("2") {
                strSocial += " 건강보험"
            }
            
            if selInfo.socialinsrn.contains("3") {
                strSocial += " 고용보험"
            }
            
            if selInfo.socialinsrn.contains("4") {
                strSocial += " 산재보험"
            }
            
            lblInsurance.text = strSocial
        }else {
            viewContractIssue.isHidden = true
        }
        
        if selInfo.anual != "" {
            lblDelivery.text = selInfo.anual
        }else {
            viewPaidVacation.isHidden = true
        }
        
        if selInfo.other != "" {
            lblDelivery.text = selInfo.other
        }else {
            viewOutside.isHidden = true
        }
        
        lblContractDate.text = dateformatKo(selInfo.lcdt)
        lblComAddr.text = CompanyInfo.addr
        lblComName.text = CompanyInfo.name
        lblComPhoneNum.text = "\(CompanyInfo.phone.pretty())"
        lblComBossName.text = CompanyInfo.ceoname
        
        lblWorkerAddr.text = selInfo.addr
        lblWorkerBirthday.text = selInfo.birth
        lblWorkerPhoneNum.text = "\(selInfo.phonenum.pretty())"
        lblWorkerName.text = selInfo.name
        
        
        if selInfo.cslimg.urlTrim() != "img_photo_default.png" {
            ComsealImageView.setImage(with: selInfo.cslimg)
        }else {
            ComsealImageView.image = UIImage(named: "logo_pre")
        }
//        ComsealImageView.bringSubviewToFront(mainView)
        PDFSealFile = self.view.exportAsPdfFromView()
        PDFnoSealFile = self.view.exportAsPdfFromView()
        print("\n---------- [ PDFtestFile : \(PDFSealFile) ] ----------\n")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLCinfo()
        
    }
    
    
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "Lc_Step7VC" {
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            
            if viewflagType == "stand_step5" {
                vc.viewflagType = "stand_step5"
                vc.standInfo = selInfo
            }else{
                vc.selInfo = selInfo
            }
            self.present(vc, animated: false, completion: nil)
        }else if viewflag == "ContractPrintMain" {
            let vc = ContractSB.instantiateViewController(withIdentifier: "ContractPrintMain") as! ContractPrintMain
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
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
    
    fileprivate func getLCinfo(){
        NetworkManager.shared().get_LCInfo(LCTSID: selInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else {
                    return
                }
                self.selInfo = serverData
                dispatchMain.async {
                    self.setUi()
                    PrintsFileImage = self.mainView.asImage()
                    PrintFileImage = self.mainView.asImage()  
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    func createPDFDataFromImage(image: UIImage) -> NSMutableData {
        let pdfData = NSMutableData()
        let imgView = UIImageView.init(image: image)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
        UIGraphicsBeginPDFPage()
        let context = UIGraphicsGetCurrentContext()
        imgView.layer.render(in: context!)
        UIGraphicsEndPDFContext()

        //try saving in doc dir to confirm:
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let path = dir?.appendingPathComponent("file.pdf")

        do {
                try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
        } catch {
            print("error catched")
        }

        return pdfData
    }
}

 
//특정부분만 border 추가할때 사용하는 함수
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}


