//
//  Lc_Default_Step3VC.swift
//  PinPle
//
//  Created by seob on 2020/06/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_Default_Step3VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblsubTitle: UILabel!
    @IBOutlet weak var Textbasepay: UITextField!
    @IBOutlet weak var Textbonus: UITextField!
    @IBOutlet weak var Textotherpay: UITextField!
    @IBOutlet weak var Textaddrate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    
    
    @IBOutlet weak var lblBaseTitle: UILabel!
    var standInfo : LcEmpInfo = LcEmpInfo()
    var slytype: Int = 0 //급여선택 0.월급 1.연봉 2.시급
    var basepay: Int = 0 //월급
    var bonuspay: Int = 0 //상여금
    var otherpay: Int = 0 //기타급여
    var addrate: Int = 0 //임금률
    var hrwage:Int = 0
    
    var textFields : [UITextField] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnNext)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        setUi()
        getLCinfo()
    }
    
    func setUi(){
        var strTitle = ""
        switch standInfo.form {
        case 0,1:
            strTitle = "월급"
            basepay = standInfo.basepay // 월급
        case 2,3:
            strTitle = "시급"
            basepay = standInfo.hourpay // 시급
        case 4,5:
            strTitle = "일급"
            basepay = standInfo.daypay // 일급
        default:
            break
        }
        lblBaseTitle.text = strTitle
        lblsubTitle.text = "임금(\(strTitle))정보를 입력하세요"
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textFields = [Textbasepay, Textbonus,  Textotherpay, Textaddrate]
        
        
        for textField in textFields {
            textField.delegate = self
        }
        
        addToolBar(textFields: textFields)
        
        Textbasepay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textbonus.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textotherpay.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        Textaddrate.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingDidEnd)
        
        var formTitle = ""
        switch standInfo.form  {
        case 0:
            formTitle = "표준 정규직 임금"
        case 1:
            formTitle = "표준 계약직 임금"
        case 2:
            formTitle = "표준 시급/소정 임금"
        case 3:
            formTitle = "표준 시급/일별 임금"
        case 4:
            formTitle = "표준 일급/소정 임금"
        case 5:
            formTitle = "표준 일급/일별 임금"
        default:
            break
        }
        
        
        lblNavigationTitle.text = formTitle
        
        
        bonuspay = standInfo.bonus // 상여금
        otherpay = standInfo.otherpay // 기타급여
        addrate = standInfo.addrate //초관근로 가산입금률
        CalPay()
    }
    
    
    fileprivate func getLCinfo(){
        NetworkManager.shared().get_LCInfo(LCTSID: standInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                self.standInfo = serverData
                self.setUi()
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        switch standInfo.form {
        case 0,1:
            standInfo.basepay = basepay // 월급
        case 2,3:
            standInfo.hourpay = basepay // 시급
        case 4,5:
            standInfo.daypay = basepay // 일급
        default:
            break
        }
        standInfo.bonus = bonuspay
        standInfo.otherpay = otherpay
        standInfo.addrate = addrate
        
        print("\n---------- [ base : \(standInfo.basepay) , hour : \(standInfo.hourpay) , daypay : \(standInfo.daypay) ] ----------\n")
        
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
    
    fileprivate func CalPay() {
        var tmpyearpay = 0
        if basepay > 0 {
            tmpyearpay = basepay
        }
        hrwage = tmpyearpay / 209
        print("\n---------- [ hrwage : \(hrwage) ] ----------\n")
        Textbasepay.text = "\(DecimalWon(value: basepay))"
        Textbonus.text = "\(DecimalWon(value: bonuspay))"
        Textotherpay.text = "\(DecimalWon(value: otherpay))"
        Textaddrate.text = "\(addrate)"
    }
    
    
    // MARK: - textFieldEditingDidChange
    @objc func textFieldEditingDidChange(_ sender: UITextField) {
        print("\n---------- [ sender : \(sender) ] ----------\n")
        var str = ""
        str = sender.text  ?? ""
        str =  str.replacingOccurrences(of: ",", with: "")
        if sender == Textbasepay {
            basepay = Int(str) ?? 0
        }else if sender == Textbonus {
            bonuspay = Int(str) ?? 0
        }else if sender == Textotherpay {
            otherpay = Int(str) ?? 0
        }else if sender == Textaddrate {
            addrate = Int(str) ?? 0
        }
        
        CalPay()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if(self.standInfo.format == 1 && (standInfo.form == 3 || standInfo.form == 5)) {
            let vc = ContractSB.instantiateViewController(withIdentifier: "StepdayVC") as! StepdayVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.standInfo = standInfo
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step2_1VC") as! Lc_Default_Step2_1VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.standInfo = standInfo
            self.present(vc, animated: false, completion: nil)
        }
 
        
    }
    @IBAction func NextDidTap(_ sender: Any) {
        if basepay > 0 {
            switch standInfo.form {
            case 0,1:
                standInfo.basepay = basepay // 월급
            case 2,3:
                standInfo.hourpay = basepay // 시급
            case 4,5:
                standInfo.daypay = basepay // 일급
            default:
                break
            }
            
            standInfo.bonus = bonuspay
            standInfo.otherpay = otherpay
            standInfo.addrate = addrate
            NetworkManager.shared().lc_std_step3(LCTSID: standInfo.sid, BASEPAY: basepay, BONUS: bonuspay, OTHERPAY: otherpay, ADDRATE: addrate , HOURPAY: standInfo.hourpay , DAYPAY: standInfo.daypay) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step4VC") as! Lc_Default_Step4VC
                        if SE_flag {
                            vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_Default_Step4VC") as! Lc_Default_Step4VC
                        }else{
                            vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step4VC") as! Lc_Default_Step4VC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.standInfo = self.standInfo
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        }else{
            self.toast("필수 입력사항 입니다.")
            Textbasepay.becomeFirstResponder()
        }
        
        
    }
    
    //MARK: - pop버튼
    @IBAction func moreBtn(_ sender: UIButton) {
        SelLcEmpInfo = standInfo
        SelLcEmpInfo.viewpage = "std_step3"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension Lc_Default_Step3VC {
    enum RowType: Int, CaseIterable {
        case basic
        case sebasic
        
        var presentable: RowPresentable {
            switch self {
            case .basic: return Basic()
            case .sebasic: return SEBsic()
            }
        }
        
        struct Basic: RowPresentable {
            var viewpage: String = "std_step3"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPopup()
        }
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPopup()
            
        }
    }
}

// MARK: - UITextFieldDelegate
extension Lc_Default_Step3VC :  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        
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
