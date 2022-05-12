//
//  UserGroupStackedViewController.swift
//  PinPle
//
//  Created by seob on 2020/07/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class UserGroupStackedViewController: UIViewController  {
    
    var isShortFormEnabled = false
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var cntnsView: UIView!
    @IBOutlet weak var pstnView: UIView!
    @IBOutlet weak var hldyView: UIView!
    @IBOutlet weak var bonusView: UIView!
    @IBOutlet weak var benefitsView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var rsrchsbdyView: UIView!
    @IBOutlet weak var chldexpnsView: UIView!
    @IBOutlet weak var vhclmncstView: UIView!
    @IBOutlet weak var jobexpnsView: UIView!
    
    @IBOutlet weak var anualpayView: UIView! //연차
    @IBOutlet weak var nightpayView: UIView! //야간
    @IBOutlet weak var adjuView: UIView! //조정
    
    @IBOutlet weak var lblbasepay: UILabel!
    @IBOutlet weak var lblcntnspay: UILabel!
    @IBOutlet weak var lblpstnpay: UILabel!
    @IBOutlet weak var lblhldypay: UILabel!
    @IBOutlet weak var lblbonuspay: UILabel!
    @IBOutlet weak var lblbenefits: UILabel!
    @IBOutlet weak var lblotherVpay: UILabel!
    @IBOutlet weak var lblrsrchsbdypay: UILabel!
    @IBOutlet weak var lblchldexpnspay: UILabel!
    @IBOutlet weak var lblvhclmncstpay: UILabel!
    @IBOutlet weak var lbljobexpnspay: UILabel!
    
    @IBOutlet weak var lblanualpay: UILabel!
    @IBOutlet weak var lblnightpay: UILabel!
    @IBOutlet weak var lbladju: UILabel!
    
    
    @IBOutlet weak var TextViewbasepay: UITextView!
    @IBOutlet weak var TextViewcntnspay: UITextView!
    @IBOutlet weak var TextViewpstnpay: UITextView!
    @IBOutlet weak var TextViewhldypay: UITextView!
    @IBOutlet weak var TextViewbonuspay: UITextView!
    @IBOutlet weak var TextViewbenefits: UITextView!
    @IBOutlet weak var TextViewotherVpay: UITextView!
    @IBOutlet weak var TextViewrsrchsbdypay: UITextView!
    @IBOutlet weak var TextViewchldexpnspay: UITextView!
    @IBOutlet weak var TextViewvhclmncstpay: UITextView!
    @IBOutlet weak var TextViewjobexpnspay: UITextView!
    
    @IBOutlet weak var TextViewanualpay: UITextView!
    @IBOutlet weak var TextViewnightpay: UITextView!
    @IBOutlet weak var TextViewadju: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnComplete: UIButton!
    
    @IBOutlet weak var scrollContentHeight: NSLayoutConstraint!
    var basebs: String = "" //기본급
    var pstnbs: String = "" //직책수장
    var hldybs: String = "" //휴일수당
    var bonusbs: String = ""//상여금
    var benefitsbs: String = ""//복지후생
    var otherbs: String = "" //기타
    var rsrchbs: String = "" //연구보조비
    var chldbs: String = "" //자녀보육수당
    var vhclbs: String = "" //차량유지비
    var jobbs: String = "" //일직숙직비
    var cntnsbs:String = "" //장기근속수당
    
    var selInfo : LcEmpInfo = LcEmpInfo()
    let borderColor = UIColor.init(hexString: "#EDEDF2")
    var textviews: [UITextView] = []
    
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
    var anualbs:String = ""
    var adjupay: Int = 0 // 조정수당
    var adjubs:String = ""
    var nightpay: Int = 0 // 야간 수당
    var nightpaybs:String = ""
    
    
    var layoutcnt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnComplete.layer.cornerRadius = 6
        textviews = [TextViewbasepay , TextViewcntnspay , TextViewpstnpay , TextViewhldypay , TextViewbonuspay , TextViewbenefits , TextViewotherVpay , TextViewrsrchsbdypay , TextViewchldexpnspay , TextViewvhclmncstpay , TextViewjobexpnspay , TextViewanualpay ,TextViewnightpay, TextViewadju ]
        addToolBar(textViews: textviews)
        for textView in textviews {
            textView.delegate = self
            textView.layer.cornerRadius = 6
            textView.layer.borderWidth = 1
            textView.layer.borderColor = borderColor.cgColor
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        print("\n---------- [ 1 SelPinplLcEmpInfo : \(SelPinplLcEmpInfo.toJSON()) ] ----------\n")
        // getLCinfo()
        setUi()
    }
    
    
    //스크롤뷰 터치했을때도 키보드 내려가도록 해주는 코드
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.panModalSetNeedsLayoutUpdate()
    }
    
    fileprivate func setUi(){
        
        self.basepay = SelPinplLcEmpInfo.basepay > 0 ?  SelPinplLcEmpInfo.basepay : self.selInfo.basepay
        self.cntnspay = SelPinplLcEmpInfo.cntnspay > 0 ?  SelPinplLcEmpInfo.cntnspay : self.selInfo.cntnspay
        self.pstnpay = SelPinplLcEmpInfo.pstnpay > 0 ?  SelPinplLcEmpInfo.pstnpay : self.selInfo.pstnpay
        self.hldypay = SelPinplLcEmpInfo.hldypay > 0 ?  SelPinplLcEmpInfo.hldypay : self.selInfo.hldypay
        self.bonus = SelPinplLcEmpInfo.bonus > 0 ?  SelPinplLcEmpInfo.bonus : self.selInfo.bonus
        self.benefits = SelPinplLcEmpInfo.benefits > 0 ?  SelPinplLcEmpInfo.benefits : self.selInfo.benefits
        self.otherpay = SelPinplLcEmpInfo.otherpay > 0 ?  SelPinplLcEmpInfo.otherpay : self.selInfo.otherpay
        self.rsrchsbdy = SelPinplLcEmpInfo.rsrchsbdy > 0 ?  SelPinplLcEmpInfo.rsrchsbdy : self.selInfo.rsrchsbdy
        self.chldexpns = SelPinplLcEmpInfo.chldexpns > 0 ?  SelPinplLcEmpInfo.chldexpns : self.selInfo.chldexpns
        self.vhclmncst = SelPinplLcEmpInfo.vhclmncst > 0 ?  SelPinplLcEmpInfo.vhclmncst : self.selInfo.vhclmncst
        self.jobexpns = SelPinplLcEmpInfo.jobexpns > 0 ?  SelPinplLcEmpInfo.jobexpns : self.selInfo.jobexpns
        
        self.anualpay = SelPinplLcEmpInfo.anualpay > 0 ?  SelPinplLcEmpInfo.anualpay : self.selInfo.anualpay
        self.adjupay = SelPinplLcEmpInfo.adjustpay > 0 ?  SelPinplLcEmpInfo.adjustpay : self.selInfo.adjustpay
        self.nightpay = SelPinplLcEmpInfo.nightpay > 0 ?  SelPinplLcEmpInfo.nightpay : self.selInfo.nightpay
        
        
        if (basepay == 0) { self.baseView.isHidden = true } else {  self.baseView.isHidden = false;  layoutcnt += 1}
        if (cntnspay == 0) { self.cntnsView.isHidden = true } else { self.cntnsView.isHidden = false; layoutcnt += 1 }
        if (pstnpay == 0) { self.pstnView.isHidden = true } else { self.pstnView.isHidden = false; layoutcnt += 1 }
        if (hldypay == 0) { self.hldyView.isHidden = true } else { self.hldyView.isHidden = false; layoutcnt += 1 }
        if (bonus == 0) { self.bonusView.isHidden = true } else { self.bonusView.isHidden = false; layoutcnt += 1 }
        if (benefits == 0) { self.benefitsView.isHidden = true } else { self.benefitsView.isHidden = false; layoutcnt += 1 }
        if (otherpay == 0 ) { self.otherView.isHidden = true } else { self.otherView.isHidden = false; layoutcnt += 1 }
        if (rsrchsbdy == 0) { self.rsrchsbdyView.isHidden = true } else { self.rsrchsbdyView.isHidden = false; layoutcnt += 1 }
        if (chldexpns == 0) { self.chldexpnsView.isHidden = true } else { self.chldexpnsView.isHidden = false; layoutcnt += 1 }
        if (vhclmncst == 0) { self.vhclmncstView.isHidden = true } else { self.vhclmncstView.isHidden = false; layoutcnt += 1 }
        if (jobexpns == 0) { self.jobexpnsView.isHidden = true } else { self.jobexpnsView.isHidden = false; layoutcnt += 1 }
        
        if (anualpay == 0) { self.anualpayView.isHidden = true } else { self.anualpayView.isHidden = false; layoutcnt += 1 }
        if (adjupay == 0) { self.adjuView.isHidden = true } else { self.adjuView.isHidden = false; layoutcnt += 1 }
        if (nightpay == 0) { self.nightpayView.isHidden = true } else { self.nightpayView.isHidden = false; layoutcnt += 1 }
        
        
        self.TextViewbasepay.text = SelPinplLcEmpInfo.basebs != "" ? SelPinplLcEmpInfo.basebs : self.selInfo.basebs
        self.TextViewcntnspay.text = SelPinplLcEmpInfo.cntnsbs != "" ? SelPinplLcEmpInfo.cntnsbs : self.selInfo.cntnsbs
        self.TextViewpstnpay.text = SelPinplLcEmpInfo.pstnbs != "" ? SelPinplLcEmpInfo.pstnbs : self.selInfo.pstnbs
        self.TextViewhldypay.text = SelPinplLcEmpInfo.hlfybs != "" ? SelPinplLcEmpInfo.hlfybs : self.selInfo.hlfybs
        self.TextViewbonuspay.text = SelPinplLcEmpInfo.bonusbs != "" ? SelPinplLcEmpInfo.bonusbs : self.selInfo.bonusbs
        self.TextViewbenefits.text = SelPinplLcEmpInfo.benefitisbs != "" ? SelPinplLcEmpInfo.benefitisbs : self.selInfo.benefitisbs
        self.TextViewotherVpay.text = SelPinplLcEmpInfo.otherbs != "" ? SelPinplLcEmpInfo.otherbs : self.selInfo.otherbs
        self.TextViewrsrchsbdypay.text = SelPinplLcEmpInfo.rsrchbs != "" ? SelPinplLcEmpInfo.rsrchbs : self.selInfo.rsrchbs
        self.TextViewchldexpnspay.text = SelPinplLcEmpInfo.chldbs != "" ? SelPinplLcEmpInfo.chldbs : self.selInfo.chldbs
        self.TextViewvhclmncstpay.text = SelPinplLcEmpInfo.vhclbs != "" ? SelPinplLcEmpInfo.vhclbs : self.selInfo.vhclbs
        self.TextViewjobexpnspay.text = SelPinplLcEmpInfo.jobbs != "" ? SelPinplLcEmpInfo.jobbs : self.selInfo.jobbs
        
        self.TextViewanualpay.text = SelPinplLcEmpInfo.anualbs != "" ? SelPinplLcEmpInfo.anualbs : self.selInfo.anualbs
        self.TextViewadju.text = SelPinplLcEmpInfo.adjustbs != "" ? SelPinplLcEmpInfo.adjustbs : self.selInfo.adjustbs
        self.TextViewnightpay.text = SelPinplLcEmpInfo.nightbs != "" ? SelPinplLcEmpInfo.nightbs : self.selInfo.nightbs
        
        self.lblbasepay.text = "\(self.DecimalWon(value: self.basepay))원"
        self.lblcntnspay.text = "\(self.DecimalWon(value: self.cntnspay))원"
        self.lblpstnpay.text = "\(self.DecimalWon(value: self.pstnpay))원"
        self.lblhldypay.text = "\(self.DecimalWon(value: self.hldypay))원"
        self.lblbonuspay.text = "\(self.DecimalWon(value: self.bonus))원"
        self.lblbenefits.text = "\(self.DecimalWon(value: self.benefits))원"
        self.lblotherVpay.text = "\(self.DecimalWon(value: self.otherpay))원"
        self.lblrsrchsbdypay.text = "\(self.DecimalWon(value: self.rsrchsbdy))원"
        self.lblchldexpnspay.text = "\(self.DecimalWon(value: self.chldexpns))원"
        self.lblvhclmncstpay.text = "\(self.DecimalWon(value: self.vhclmncst))원"
        self.lbljobexpnspay.text = "\(self.DecimalWon(value: self.jobexpns))원"
        
        self.lblanualpay.text = "\(self.DecimalWon(value: self.anualpay))원"
        self.lbladju.text = "\(self.DecimalWon(value: self.adjupay))원"
        self.lblnightpay.text = "\(self.DecimalWon(value: self.nightpay))원"
        
        scrollContentHeight.constant = CGFloat(layoutcnt * 233 + 50)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
    }
    
    @objc func endEditing(){
        TextViewbasepay.resignFirstResponder()
    }
    
    fileprivate func getLCinfo() {
        NetworkManager.shared().get_LCInfo(LCTSID: SelPinplLcEmpInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else {
                    return
                }
                self.selInfo = serverData
                
            }else{
                self.toast("다시 시도해 주세요.")
            }
            
        }
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .reloadList, object: nil)
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        basebs = TextViewbasepay.text
        cntnsbs = TextViewcntnspay.text
        pstnbs = TextViewpstnpay.text
        hldybs = TextViewhldypay.text
        bonusbs = TextViewbonuspay.text
        benefitsbs = TextViewbenefits.text
        otherbs = TextViewotherVpay.text
        rsrchbs = TextViewrsrchsbdypay.text
        chldbs = TextViewchldexpnspay.text
        vhclbs = TextViewvhclmncstpay.text
        jobbs = TextViewjobexpnspay.text
        
        anualbs = TextViewanualpay.text
        adjubs = TextViewadju.text
        nightpaybs = TextViewnightpay.text
        
        
        NetworkManager.shared().set_step4_1(LCTSID: SelPinplLcEmpInfo.sid, BASEBS: basebs.urlEncoding(), CNTNSBS: cntnsbs.urlEncoding(), PSTNBS: pstnbs.urlEncoding(), HLDYBS: hldybs.urlEncoding(), BONUSBS: bonusbs.urlEncoding(), BENEFITSBS: benefitsbs.urlEncoding(), OTHERBS: otherbs.urlEncoding(), RSRCHBS: rsrchbs.urlEncoding(), CHLDBS: chldbs.urlEncoding(), VHCLBS: vhclbs.urlEncoding(), JOBBS: jobbs.urlEncoding(), NIGHTBS: nightpaybs.urlEncoding() ,ADJUSTBS: adjubs.urlEncoding(), ANUALBS: anualbs.urlEncoding()) { (isSuccess, resCode) in
            if(isSuccess){
                DispatchQueue.main.async {
                    if resCode == 1 {
                        SelPinplLcEmpInfo.basebs = self.basebs
                        SelPinplLcEmpInfo.cntnsbs = self.cntnsbs
                        SelPinplLcEmpInfo.pstnbs = self.pstnbs
                        SelPinplLcEmpInfo.hlfybs = self.hldybs
                        SelPinplLcEmpInfo.bonusbs = self.bonusbs
                        SelPinplLcEmpInfo.benefitisbs = self.benefitsbs
                        SelPinplLcEmpInfo.otherbs = self.otherbs
                        SelPinplLcEmpInfo.rsrchbs = self.rsrchbs
                        SelPinplLcEmpInfo.chldbs = self.chldbs
                        SelPinplLcEmpInfo.vhclbs = self.vhclbs
                        SelPinplLcEmpInfo.jobbs = self.jobbs
                        
                        
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: .reloadList, object: nil)
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }
                
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
        
    }
}


// MARK:  - PanModalPresentable
extension UserGroupStackedViewController: PanModalPresentable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
        else { return }
        
        isShortFormEnabled = false
    }
    
}

// MARK:  - UITextViewDelegate
extension UserGroupStackedViewController :  UITextViewDelegate {
    
}
