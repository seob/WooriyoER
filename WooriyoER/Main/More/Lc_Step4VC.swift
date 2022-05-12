//
//  Lc_Step4VC.swift
//  PinPle
//
//  Created by seob on 2020/06/04.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_Step4VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    @IBOutlet weak var Textyearpay: UITextField!
    @IBOutlet weak var Textbasepay: UITextField!
    @IBOutlet weak var Textpstnpay: UITextField!
    @IBOutlet weak var Textovrtmpay: UITextField!
    @IBOutlet weak var Texthldypay: UITextField!
    @IBOutlet weak var Textbonus: UITextField!
    @IBOutlet weak var Textbenefits: UITextField!
    @IBOutlet weak var Texthldyalwnc: UITextField!
    @IBOutlet weak var Textotherpay: UITextField!
    @IBOutlet weak var Textmeals: UITextField!
    @IBOutlet weak var Textrsrchsbdy: UITextField!
    @IBOutlet weak var Textchldexpns: UITextField!
    @IBOutlet weak var Textvhclmncst: UITextField!
    @IBOutlet weak var Textjobexpns: UITextField!
    @IBOutlet weak var Texthrwage: UITextField! //시급
    
    @IBOutlet weak var TextNightpay: UITextField!
    @IBOutlet weak var Textanualpay: UITextField!
    @IBOutlet weak var Textadhy: UITextField!
    
    @IBOutlet weak var lblSummonthpay: UILabel!
    @IBOutlet weak var lblYearpay: UILabel!
    @IBOutlet weak var lblCalTime: UILabel! //근로시간
    
    @IBOutlet weak var YearpayView: UIView! //연봉뷰 정규직일때만 노출
    
    @IBOutlet weak var lblTitle: UILabel! //월급 , 연봉 , 시급
    @IBOutlet weak var baseViewHeight: NSLayoutConstraint! //정규직일땐 71 아니면 21
    @IBOutlet weak var YearViewHeight: NSLayoutConstraint! //정규직일땐 40 아니면 12
    @IBOutlet weak var ViewHeight: NSLayoutConstraint! //정규직일땐 1300 아니면 1000
    @IBOutlet weak var SumPayView: UIView! //계산된 월급 뷰
    @IBOutlet weak var SumYearView: UIView! //계산된 연봉 뷰 , 정규직일땐 hidden
    
    @IBOutlet weak var hrwageView: UIView! //시급뷰
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var chkImgYear: UIImageView! //시작 error
    @IBOutlet weak var chkImgBase: UIImageView! //종료 error
    @IBOutlet weak var chkImghrwage: UIImageView! //종료 error
    
    @IBOutlet weak var BsView: UIButton! //산출근거 입력 버튼
    
    @IBOutlet weak var Textcntnspay: UITextField! //장기근속수당
    
    
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    @IBOutlet weak var stepDot6: UIImageView!
    
    @IBOutlet weak var btnNext: UIButton!
    var slytype: Int = 0 //급여선택 0.월급 1.연봉 2.시급
    var yearpay: Int = 0 //연봉
    var basepay: Int = 0 //기본급
    var pstnpay: Int = 0 //직책수장
    var ovrtmpay: Int = 0 //연장수당
    var hldypay: Int = 0 //휴일수당
    var bonus: Int = 0//상여금
    var benefits: Int = 0//복지후생
    var otherpay: Int = 0 //기타
    var meals: Int = 0 //식대
    var rsrchsbdy: Int = 0 //연구보조비
    var chldexpns: Int = 0 //자녀보육수당
    var vhclmncst: Int = 0 //차량유지비
    var jobexpns: Int = 0 //일직숙직비
    var hldyalwnc: Int = 0//명절수당
    var hourpay: Int = 0//시급
    var shourpay: Int = 0//서버 저장시급
    var summonthpay: Int = 0 //계산된 월급
    var sumyearpay: Int = 0 //계산된 연봉
    var worktime: Int = 0 //근로시간
    var basedayPay:Int = 0 //최저임금
    var cntnspay:Int = 0 //장기근속수당
    var anualpay:Int = 0 //연차수당
    var adjupay: Int = 0 // 조정수당
    var nightpay: Int = 0 // 야간 수당
    var selInfo : LcEmpInfo = LcEmpInfo()
    var textFields : [UITextField] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setUi()
        BsView.addTarget(self, action: #selector(bsTextDidTap(_:)), for: .touchUpInside)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    @objc func reloadTableData(_ notification: Notification) {
        selInfo = SelPinplLcEmpInfo
        
        print("\n---------- [ selInfo : \(selInfo.toJSON()) ] ----------\n")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var titleStr = ""
        switch selInfo.form {
        case 0:
            titleStr = "정규직"
            if selInfo.slytype == 0 {
                titleStr += " 월급정보"
            }else if selInfo.slytype == 1 {
                titleStr += " 연봉정보"
            }else if selInfo.slytype == 2 {
                titleStr += " 수습정보"
            }
        case 1:
            titleStr = "계약직"
            if selInfo.slytype == 0 {
                titleStr += " 월급정보"
            }else if selInfo.slytype == 1 {
                titleStr += " 연봉정보"
            }else if selInfo.slytype == 2 {
                titleStr += " 수습정보"
            }
        case 2:
            titleStr = "수습"
            if selInfo.slytype == 0 {
                titleStr += " 월급정보"
            }else if selInfo.slytype == 1 {
                titleStr += " 연봉정보"
            }else if selInfo.slytype == 2 {
                titleStr += " 수습정보"
            }
        default:
            break
        }
        lblNavigationTitle.text = titleStr
         
        print("\n---------- [ slytype : \(selInfo.slytype) ] ----------\n")
        getLCinfo {}
    }
    
    
    fileprivate func getLCinfo(finished : @escaping ()-> Void) {
        NetworkManager.shared().get_LCInfo(LCTSID: selInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else {
                    return
                }
                self.selInfo = serverData
            }else{
                self.toast("다시 시도해 주세요.")
            }
            
            finished()
        }
    }
    
    
    func setUi(){
        print("\n---------- [ 1 setUi ] ----------\n")
        textFields = [Textyearpay , Textbasepay,Textcntnspay , Textpstnpay, Textovrtmpay , TextNightpay , Texthldypay ,  Textanualpay , Textbonus , Texthldyalwnc, Textbenefits , Textadhy,  Textotherpay, Textmeals ,Textrsrchsbdy ,Textchldexpns , Textvhclmncst, Textjobexpns  ,Texthrwage]
        
        addToolBar(textFields: textFields)
        for textField in textFields {
            textField.delegate = self
        }
        
        
        
        
        Textyearpay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textbasepay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textpstnpay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textovrtmpay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Texthldypay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textbonus.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textbenefits.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Texthldyalwnc.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textotherpay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textmeals.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textrsrchsbdy.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textchldexpns.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textjobexpns.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Texthrwage.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textvhclmncst.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textcntnspay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        
        TextNightpay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textanualpay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textadhy.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        //        CalPay()
        
        slytype = selInfo.slytype
        
        yearpay = selInfo.yearpay //연봉
        basepay = selInfo.basepay //기본급
        pstnpay = selInfo.pstnpay //직책수장
        ovrtmpay = selInfo.ovrtmpay //연장수당
        hldypay = selInfo.hldypay //휴일수당
        bonus = selInfo.bonus//상여금
        benefits = selInfo.benefits//복지후생
        otherpay = selInfo.otherpay //기타
        meals = selInfo.meals //식대
        rsrchsbdy = selInfo.rsrchsbdy //연구보조비
        chldexpns = selInfo.chldexpns //자녀보육수당
        vhclmncst = selInfo.vhclmncst //차량유지비
        jobexpns = selInfo.jobexpns//일직숙직비
        hldyalwnc = selInfo.hldyalwnc//명절수당
        shourpay = selInfo.hourpay//시급
        cntnspay = selInfo.cntnspay //장기근속
        
        anualpay = selInfo.anualpay // 연차수당
        adjupay = selInfo.adjustpay // 조정수당
        nightpay = selInfo.nightpay //야간수당
        
        self.summonthpay = selInfo.monthpay
        self.sumyearpay = selInfo.yearpay
        self.worktime = selInfo.monthovrtm
         
         
        self.Textyearpay.text = "\(self.DecimalWon(value: self.selInfo.yearpay))"
        if(self.slytype == 1) {
            self.Textbasepay.isUserInteractionEnabled = false
            self.Textbasepay.textColor = .red
        }else{
            self.Textbasepay.isUserInteractionEnabled = true
        }
        self.Textbasepay.text = "\(self.DecimalWon(value: self.selInfo.basepay))"
        self.Textpstnpay.text = "\(self.DecimalWon(value: self.selInfo.pstnpay))"
        self.Textovrtmpay.text = "\(self.DecimalWon(value: self.selInfo.ovrtmpay))"
        self.Texthldypay.text = "\(self.DecimalWon(value: self.selInfo.hldypay))"
        self.Textbonus.text = "\(self.DecimalWon(value: self.selInfo.bonus))"
        self.Textbenefits.text = "\(self.DecimalWon(value: self.selInfo.benefits))"
        self.Texthldyalwnc.text = "\(self.DecimalWon(value: self.selInfo.hldyalwnc))"
        self.Textotherpay.text = "\(self.DecimalWon(value: self.selInfo.otherpay))"
        self.Textmeals.text = "\(self.DecimalWon(value: self.selInfo.meals))"
        self.Textrsrchsbdy.text = "\(self.DecimalWon(value: self.selInfo.rsrchsbdy))"
        self.Textchldexpns.text = "\(self.DecimalWon(value: self.selInfo.chldexpns))"
        self.Textvhclmncst.text = "\(self.DecimalWon(value: self.selInfo.vhclmncst))"
        self.Textjobexpns.text = "\(self.DecimalWon(value: self.selInfo.jobexpns))"
        
        
        self.Textanualpay.text = "\(self.DecimalWon(value: self.selInfo.anualpay))"
        self.Textadhy.text = "\(self.DecimalWon(value: self.selInfo.adjustpay))"
        self.TextNightpay.text = "\(self.DecimalWon(value: self.selInfo.nightpay))"
        
        self.lblSummonthpay.text = "\(self.DecimalWon(value: summonthpay))원"
        self.lblYearpay.text = "\(self.DecimalWon(value: sumyearpay))원"
        
        self.lblCalTime.text = "월 연장근로시간 \(self.worktime) 시간" //근로시간
        
        self.Textcntnspay.text = "\(self.DecimalWon(value: self.selInfo.cntnspay))"
        
        if self.slytype == 2 {
            //시급
            self.Texthrwage.text = "\(self.DecimalWon(value: self.selInfo.hourpay))"
        }
        
        switch selInfo.slytype {
        case 0:
            self.YearpayView.isHidden = true
            self.YearViewHeight.constant = 50.0
            self.ViewHeight.constant = 1400.0
            self.baseViewHeight.constant = 21.0
            self.SumYearView.isHidden = false
            self.SumPayView.isHidden = false
            self.hrwageView.isHidden = true
            break
        case 1:
            self.chkImgBase.isHidden = true
            self.YearpayView.isHidden = false
            self.YearViewHeight.constant = 50.0
            self.ViewHeight.constant = 1400.0
            self.baseViewHeight.constant = 71.0
            self.SumYearView.isHidden = true
            self.SumPayView.isHidden = false
            self.hrwageView.isHidden = true
            break
        default:
            self.chkImgBase.isHidden = true
            self.YearpayView.isHidden = false
            self.YearViewHeight.constant = 50.0
            self.ViewHeight.constant = 1400.0
            self.baseViewHeight.constant = 71.0
            self.SumYearView.isHidden = true
            self.SumPayView.isHidden = false
            self.hrwageView.isHidden = true
            break
        }
        
    }
    
    // 수식 작업
    fileprivate func CalPay() {
        print("\n---------- [ 1 CalPay : \(self.slytype) ] ----------\n")
        var tmpyearpay = 0 // 연봉일때 바뀔때마다
        switch self.slytype {
        case 1: //연봉
            
            tmpyearpay = ((yearpay - (hldyalwnc * 2)) / 12) - pstnpay - ovrtmpay - hldypay - bonus - benefits - otherpay - meals - rsrchsbdy - chldexpns - vhclmncst - jobexpns - cntnspay
            summonthpay = basepay + cntnspay + pstnpay + ovrtmpay + hldypay + bonus + benefits + otherpay + meals + rsrchsbdy + chldexpns + vhclmncst + jobexpns + anualpay + adjupay + nightpay
            
            
            basepay = ((yearpay - (hldyalwnc * 2)) / 12) - pstnpay - ovrtmpay - hldypay - bonus - benefits - otherpay - meals - rsrchsbdy - chldexpns - vhclmncst - jobexpns - cntnspay - anualpay - adjupay - nightpay
            //계산된 연봉 =  (기본급 + (명정수당 *2) * 12)
            sumyearpay =  tmpyearpay
            
        case 0: //월급
            
            summonthpay = basepay + pstnpay + ovrtmpay + hldypay + bonus + benefits + otherpay + meals + rsrchsbdy + chldexpns + vhclmncst + jobexpns + cntnspay + anualpay + adjupay + nightpay
            
            //계산된 연봉 =  (기본급 + (명정수당 *2) * 12)
            sumyearpay =  (summonthpay * 12 ) + (hldyalwnc * 2)
            tmpyearpay = (summonthpay * 12 ) + (hldyalwnc * 2)
        default:
            break
        }
        
        // 시급  = 연봉 이거나 월급일때만 계산 그외는 입력된 값 그대로 전달
        if (slytype == 1 || slytype == 0) {
            //기본시급 = 기본급 / 209 (소수점 이하 반올림)
            if basepay > 0 {
                hourpay = basepay / 209
                if (hourpay < 1 && ovrtmpay < 1) {
                    worktime = 0
                }else{
                    worktime = Int(Double(ovrtmpay / hourpay) / 1.5) //월 연장근로시간: 연장수당 / 기본시급 / 1.5
                }
            }
        }else{
            hourpay = 0
        }
        
        
        Textyearpay.text = "\(DecimalWon(value: yearpay))"
        if(slytype == 1) {
            Textbasepay.isUserInteractionEnabled = false
            Textbasepay.textColor = .red
        }else{
            Textbasepay.isUserInteractionEnabled = true
        }
        Textbasepay.text = "\(DecimalWon(value: basepay))"
        Textpstnpay.text = "\(DecimalWon(value: pstnpay))"
        Textovrtmpay.text = "\(DecimalWon(value: ovrtmpay))"
        Texthldypay.text = "\(DecimalWon(value: hldypay))"
        Textbonus.text = "\(DecimalWon(value: bonus))"
        Textbenefits.text = "\(DecimalWon(value: benefits))"
        Texthldyalwnc.text = "\(DecimalWon(value: hldyalwnc))"
        Textotherpay.text = "\(DecimalWon(value: otherpay))"
        Textmeals.text = "\(DecimalWon(value: meals))"
        Textrsrchsbdy.text = "\(DecimalWon(value: rsrchsbdy))"
        Textchldexpns.text = "\(DecimalWon(value: chldexpns))"
        Textvhclmncst.text = "\(DecimalWon(value: vhclmncst))"
        Textjobexpns.text = "\(DecimalWon(value: jobexpns))"
        
        lblSummonthpay.text = "\(DecimalWon(value: summonthpay))원"
        lblYearpay.text = "\(DecimalWon(value: sumyearpay))원"
        Textcntnspay.text = "\(self.DecimalWon(value: cntnspay))"
        lblCalTime.text = "월 연장근로시간 \(worktime) 시간" //근로시간
        
        self.Textanualpay.text = "\(self.DecimalWon(value: anualpay))"
        self.Textadhy.text = "\(self.DecimalWon(value: adjupay))"
        self.TextNightpay.text = "\(self.DecimalWon(value: nightpay))"
        
        
        //        if worktime > 52 {
        //            self.customAlertView("52시간 근로제 위반입니다.")
        //        }
        
        
        if slytype == 2 {
            //시급
            Texthrwage.text = "\(DecimalWon(value: shourpay))"
        }
        
        tmpSaveData()
    }
    
    fileprivate func tmpSaveData(){
        print("\n---------- [ 1 tmpSaveData : \(selInfo.toJSON()) ] ----------\n")
        self.selInfo.basepay = basepay
        self.selInfo.pstnpay = pstnpay
        self.selInfo.ovrtmpay = ovrtmpay
        self.selInfo.hldypay = hldypay
        self.selInfo.bonus = bonus
        self.selInfo.benefits = benefits
        self.selInfo.otherpay = otherpay
        self.selInfo.meals = meals
        self.selInfo.rsrchsbdy = rsrchsbdy
        self.selInfo.chldexpns = chldexpns
        self.selInfo.vhclmncst = vhclmncst
        self.selInfo.jobexpns = jobexpns
        self.selInfo.hldyalwnc = hldyalwnc
        self.selInfo.hourpay = shourpay
        self.selInfo.monthpay = summonthpay
        
        self.selInfo.anualpay = anualpay //연차
        self.selInfo.adjustpay = adjupay //조정
        self.selInfo.nightpay = nightpay //야간
        
        
        switch selInfo.slytype {
        case 0: //월급
            self.selInfo.yearpay = sumyearpay
        case 1: //연봉
            self.selInfo.yearpay = yearpay
        default:
            break
        }
        
        self.selInfo.monthovrtm = worktime
        self.selInfo.cntnspay = cntnspay
        //SelPinplLcEmpInfo = selInfo
    }
    
    
//    override func setNeedsFocusUpdate() {
//        super.setNeedsFocusUpdate()
//        tmpSaveData()
//    }
     
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step3VC") as! Lc_Step3VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        switch selInfo.slytype {
        case 0: //월급
            if basepay == 0 {
                self.customAlertView("기본급은 필수입력입니다.")
            }else if worktime > 52 {
                self.customAlertView("52시간 근로제 위반입니다.")
            }else if basepay < 0 {
                self.customAlertView("항목의 총합은 월급을 초과할 수 없습니다.")
            } else{
                self.selInfo.basepay = basepay
                self.selInfo.pstnpay = pstnpay
                self.selInfo.ovrtmpay = ovrtmpay
                self.selInfo.hldypay = hldypay
                self.selInfo.bonus = bonus
                self.selInfo.benefits = benefits
                self.selInfo.otherpay = otherpay
                self.selInfo.meals = meals
                self.selInfo.rsrchsbdy = rsrchsbdy
                self.selInfo.chldexpns = chldexpns
                self.selInfo.vhclmncst = vhclmncst
                self.selInfo.jobexpns = jobexpns
                self.selInfo.hldyalwnc = hldyalwnc
                self.selInfo.hourpay = shourpay
                self.selInfo.monthpay = summonthpay
                //            self.selInfo.yearpay = sumyearpay
                if selInfo.slytype == 1 {
                    self.selInfo.yearpay = yearpay
                    
                }else if selInfo.slytype == 0 {
                    self.selInfo.yearpay = sumyearpay
                }else {
                    self.selInfo.yearpay = yearpay
                }
                self.selInfo.monthovrtm = worktime
                self.selInfo.cntnspay = cntnspay
                
                self.selInfo.anualpay = anualpay //연차
                self.selInfo.adjustpay = adjupay //조정
                self.selInfo.nightpay = nightpay //야간
                
                NetworkManager.shared().set_step4(LCTSID: selInfo.sid, BASEPAY: basepay, PSTNPAY: pstnpay, OVRTMPAY: ovrtmpay, HLDYPAY: hldypay, BONUS: bonus, BENEFITS: benefits, OTHERPAY: otherpay, MEALS: meals, RSRCHSBDY: rsrchsbdy, CHLDEXPNS: chldexpns, VHCLMNCST: vhclmncst, JOBEXPNS: jobexpns, HLDYALWNC: hldyalwnc, HOURPAY: hourpay, MONTHPAY: summonthpay, YEARPAY: sumyearpay, MONTHOVRTM: worktime , CNTNSPAY: cntnspay , NIGHTPAY: nightpay , ADJUSTPAY: adjupay, ANUALPAY: anualpay) { (isSuccess, resCode) in
                    
                    if(isSuccess){
                        if(resCode == 1){
                            
                            var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step5VC") as! Lc_Step5VC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step5VC") as! Lc_Step5VC
                            }else{
                                vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step5VC") as! Lc_Step5VC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            self.present(vc, animated: false, completion: nil)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
            }
        case 1: // 연봉
            if yearpay == 0 {
                self.customAlertView("연봉은 필수입력입니다.")
            }else if worktime > 52 {
                self.customAlertView("52시간 근로제 위반입니다.")
            }else if basepay < 0 {
                self.customAlertView("항목의 총합은 월급을 초과할 수 없습니다.")
            }else if basepay <= ovrtmpay {
                self.customAlertView("연장수당은 기본급 이하로 설정해주세요.")
            }else{
                self.selInfo.basepay = basepay
                self.selInfo.pstnpay = pstnpay
                self.selInfo.ovrtmpay = ovrtmpay
                self.selInfo.hldypay = hldypay
                self.selInfo.bonus = bonus
                self.selInfo.benefits = benefits
                self.selInfo.otherpay = otherpay
                self.selInfo.meals = meals
                self.selInfo.rsrchsbdy = rsrchsbdy
                self.selInfo.chldexpns = chldexpns
                self.selInfo.vhclmncst = vhclmncst
                self.selInfo.jobexpns = jobexpns
                self.selInfo.hldyalwnc = hldyalwnc
                self.selInfo.hourpay = shourpay
                self.selInfo.monthpay = summonthpay
                //            self.selInfo.yearpay = sumyearpay
                self.selInfo.yearpay = yearpay
                self.selInfo.monthovrtm = worktime
                self.selInfo.cntnspay = cntnspay
                
                self.selInfo.anualpay = anualpay// 연차수당
                self.selInfo.adjustpay = adjupay // 조정수당
                self.selInfo.nightpay = nightpay //야간수당
                
                NetworkManager.shared().set_step4(LCTSID: selInfo.sid, BASEPAY: basepay, PSTNPAY: pstnpay, OVRTMPAY: ovrtmpay, HLDYPAY: hldypay, BONUS: bonus, BENEFITS: benefits, OTHERPAY: otherpay, MEALS: meals, RSRCHSBDY: rsrchsbdy, CHLDEXPNS: chldexpns, VHCLMNCST: vhclmncst, JOBEXPNS: jobexpns, HLDYALWNC: hldyalwnc, HOURPAY: hourpay, MONTHPAY: summonthpay, YEARPAY: yearpay, MONTHOVRTM: worktime , CNTNSPAY: cntnspay, NIGHTPAY: nightpay , ADJUSTPAY: adjupay , ANUALPAY: anualpay) { (isSuccess, resCode) in
                    
                    if(isSuccess){
                        if(resCode == 1){
                            
                            var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step5VC") as! Lc_Step5VC
                            if SE_flag {
                                vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Step5VC") as! Lc_Step5VC
                            }else{
                                vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step5VC") as! Lc_Step5VC
                            }
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.selInfo = self.selInfo
                            self.present(vc, animated: false, completion: nil)
                        }else{
                            self.toast("다시 시도해 주세요.")
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
            }
        default :
            break
        }
        
        
        
    }
    
    //MARK: - pop버튼
    @IBAction func moreBtn(_ sender: UIButton) {
        SelPinplLcEmpInfo = selInfo
        SelPinplLcEmpInfo.viewpage = "step4"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
    
    //산출근거 버튼
    @objc func bsTextDidTap(_ sender: UIButton){
        switch selInfo.slytype {
        case 0: //월급
            if (Textbasepay.text != "" || Textpstnpay.text != "" || Textovrtmpay.text != "" || Texthldypay.text != "" || Textbonus.text != "" || Textbenefits.text != "" || Texthldyalwnc.text != "" || Textotherpay.text != "" || Textmeals.text != "" || Textrsrchsbdy.text != "" || Textchldexpns.text != "" || Texthrwage.text != "" || Textjobexpns.text != "" || Textvhclmncst.text != "" || Textcntnspay.text != ""){
                
                SelPinplLcEmpInfo = selInfo
                let bsvc = ContractSB.instantiateViewController(withIdentifier: "UserGroupStackedViewController") as! UserGroupStackedViewController
                presentPanModal(bsvc)
            }else{
                self.toast("산출근거를 입력할 항목이 없습니다.")
            }
        case 1 :
            if (Textyearpay.text != "" || Textbasepay.text != "" || Textpstnpay.text != "" || Textovrtmpay.text != "" || Texthldypay.text != "" || Textbonus.text != "" || Textbenefits.text != "" || Texthldyalwnc.text != "" || Textotherpay.text != "" || Textmeals.text != "" || Textrsrchsbdy.text != "" || Textchldexpns.text != "" || Texthrwage.text != "" || Textjobexpns.text != "" || Textvhclmncst.text != "" || Textcntnspay.text != ""){
                
                SelPinplLcEmpInfo = selInfo
                let bsvc = ContractSB.instantiateViewController(withIdentifier: "UserGroupStackedViewController") as! UserGroupStackedViewController
                presentPanModal(bsvc)
            }else{
                self.toast("산출근거를 입력할 항목이 없습니다.")
            }
        default:
            break
        }
        
    }
    
    // MARK: - textFieldEditingDidChange
    @objc func textFieldEditingDidChange(_ sender: UITextField) {
        print("textField: \(sender.text!)")
        var str = ""
        str = sender.text  ?? ""
        str =  str.replacingOccurrences(of: ",", with: "")
        if sender == Textyearpay {
            yearpay = Int(str) ?? 0
        }else if sender == Textbasepay {
            basepay = Int(str) ?? 0
        }else if sender == Textcntnspay {
            cntnspay = Int(str) ?? 0
            
        }else if sender == Textpstnpay {
            pstnpay = Int(str) ?? 0
        }else if sender == Textovrtmpay {
            ovrtmpay = Int(str) ?? 0
            
        }else if sender == Textbonus {
            bonus = Int(str) ?? 0
            
        }else if sender == Textbenefits {
            benefits = Int(str) ?? 0
        }else if sender == Texthldyalwnc {
            hldyalwnc = Int(str) ?? 0
        }else if sender == Textotherpay {
            otherpay = Int(str) ?? 0
        }else if sender == Textmeals {
            meals = Int(str) ?? 0
        }else if sender == Textrsrchsbdy {
            rsrchsbdy = Int(str) ?? 0
        }else if sender == Textchldexpns {
            chldexpns = Int(str) ?? 0
            
        }else if sender == Textvhclmncst {
            vhclmncst = Int(str) ?? 0
        }else if sender == Textjobexpns {
            jobexpns = Int(str) ?? 0
        }else if sender == Texthldypay {
            hldypay = Int(str) ?? 0
        }else if sender == Texthrwage {
            shourpay = Int(str) ?? 0
        }else if sender == TextNightpay {
            nightpay = Int(str) ?? 0
        }else if sender == Textanualpay {
            anualpay = Int(str) ?? 0
        }else if sender == Textadhy {
            adjupay = Int(str) ?? 0
        }
        
        CalPay()
    }
}


private extension Lc_Step4VC {
    enum RowType: Int, CaseIterable {
        case basic
        case stacked
        case sebasic
        
        var presentable: RowPresentable {
            switch self {
            case .basic: return Basic()
            case .stacked: return Stacked()
            case .sebasic: return SEBsic()
            }
        }
        
        struct Basic: RowPresentable {
            var viewpage: String = "step4"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPinplPopup()
        }
        
        struct Stacked: RowPresentable {
            let viewpage: String = "산출근거"
            let rowVC: PanModalPresentable.LayoutType = UserGroupStackedViewController()
        }
        
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPinplPopup()
            
        }
    }
}


// MARK: - UITextFieldDelegate
extension Lc_Step4VC :  UITextFieldDelegate {
     
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        
        tmpSaveData()
        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){ // ---- 1
            var beforeForemattedString = removeAllSeprator + string // --- 2
            if formatter.number(from: string) != nil { // --- 3
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){ // --- 4
                    textField.text = formattedString // --- 5
                    return false
                }
            }else{ // --- 6
                if string == "" { // --- 7
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{ // --- 8
                    return false
                }
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { 
        CalPay()
    }
}
