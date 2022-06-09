//
//  AddAnnualAddVC.swift
//  PinPle
//
//  Created by seob on 2020/07/23.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AddAnnualAddVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var textUseAnlDay: UITextField!
    @IBOutlet weak var textUseAnlHour: UITextField!
    @IBOutlet weak var textUseAnlMin: UITextField!
     
    @IBOutlet weak var textMemo: UITextView!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var lbltextlimit: UILabel!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    var EmpInfo = EmplyInfo()
    var tempMbrInfo = getMbrInfo()
    var pickerDay: [String] = []
    var pickerHour: [String] = []
    var pickerMin: [String] = []
    let useAnlPicker = UIPickerView()
    var dayTemp1 = 0
    var hourTmep1 = 0
    var minTemp1 = 0
    var joindt = ""
    var usemin = 0
    var anmsid = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        setUi()
    }
    
    fileprivate func setUi(){
        addToolBar(textFields: [textUseAnlDay , textUseAnlHour , textUseAnlMin], textView: textMemo)
        textUseAnlDay.inputView = useAnlPicker
        textUseAnlHour.inputView = useAnlPicker
        textUseAnlMin.inputView = useAnlPicker
        textUseAnlDay.delegate = self
        textUseAnlHour.delegate = self
        textUseAnlMin.delegate = self
        useAnlPicker.delegate = self
        pickerLabel(useAnlPicker)
        textMemo.delegate = self
        textMemo.layer.cornerRadius = 6
        textMemo.layer.borderWidth = 1
        textMemo.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
        for i in 0...99 {
            if i < 10 {
                pickerDay.append("0" + String(i))
            }else {
                pickerDay.append(String(i))
            }
        }
        for j in 0...7 {
            pickerHour.append("0" + String(j))
        }
        
        for m in 0...59 {
            if m < 10 {
                pickerMin.append("0" + String(m))
            }else {
                pickerMin.append(String(m))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblDate.text = "기록일 : \(todayDatetocomma())"
        let textLength = textMemo.text.count
        lbltextlimit.text = "(\(textLength)/40)"
    }
    
    func pickerLabel(_ picker: UIPickerView) {
        var x: CGFloat!
        let device = deviceHeight()
        switch device {
        case 2, 4:
            x = picker.bounds.width - 10 //x 375
        case 3, 5:
            x = picker.bounds.width + 20 //max 414
        default:
            x = picker.bounds.width - 10 // 그외 기종에서 앱 종료 현상이 발생하여 추가
        }
        let lblDay = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
        lblDay.font = UIFont(name: "Helvetica Neue", size: 23)
        lblDay.text = "일"
        lblDay.sizeToFit()
        lblDay.frame = CGRect(x: picker.bounds.width / 3 - lblDay.bounds.width,
                              y: picker.bounds.height / 2 - (lblDay.bounds.height / 2),
                              width: lblDay.bounds.width,
                              height: lblDay.bounds.height)
        picker.addSubview(lblDay)
        
        let lblHour = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
        lblHour.font = UIFont(name: "Helvetica Neue", size: 23)
        lblHour.text = "시간"
        lblHour.sizeToFit()
        switch device {
        case 2, 4 :
            lblHour.frame = CGRect(x: picker.bounds.width / 2 + lblDay.bounds.width + 40,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblHour)
            
            let lblMin = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
            lblMin.font = UIFont(name: "Helvetica Neue", size: 23)
            lblMin.text = "분"
            lblMin.sizeToFit()
            lblMin.frame = CGRect(x: picker.bounds.width + 20,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblMin)
            
        case 3,5:
            lblHour.frame = CGRect(x: picker.bounds.width / 2 + lblDay.bounds.width + 60,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblHour)
            
            let lblMin = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
            lblMin.font = UIFont(name: "Helvetica Neue", size: 23)
            lblMin.text = "분"
            lblMin.sizeToFit()
            lblMin.frame = CGRect(x: picker.bounds.width + 50,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblMin)
        default :
            lblHour.frame = CGRect(x: picker.bounds.width / 2 + lblDay.bounds.width + 40,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblHour)
            
            let lblMin = UILabel(frame: CGRect(x: 0,y: 0, width: 10,height: 10))
            lblMin.font = UIFont(name: "Helvetica Neue", size: 23)
            lblMin.text = "분"
            lblMin.sizeToFit()
            lblMin.frame = CGRect(x: picker.bounds.width + 20,
                                   y: picker.bounds.height / 2 - (lblHour.bounds.height / 2),
                                   width: lblHour.bounds.width,
                                   height: lblHour.bounds.height)
            picker.addSubview(lblMin)
        } 
  
    }
    
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "AnnualListVC") as! AnnualListVC
        vc.EmpInfo = EmpInfo
        vc.tempMbrInfo = tempMbrInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func saveDidTap(_ sender: UIButton) {
        let memoText = textMemo.text ?? ""
        let use = strTime(dayTemp1, hourTmep1, minTemp1)
        NetworkManager.shared().ins_Anual(empsid: tempMbrInfo.empsid, type: 1, setmin: use, memo: memoText.urlEncoding()) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode == 1 {
                    self.toast("등록 되었습니다.")
                     SelEmpInfo.addmin += use
                    let vc = CmpCmtSB.instantiateViewController(withIdentifier: "AnnualListVC") as! AnnualListVC
                    vc.EmpInfo = self.EmpInfo
                    vc.tempMbrInfo = self.tempMbrInfo
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }else{
                if resCode == 99 {
                    self.toast("추가할 연차의 시간을 등록해 주세요.")
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        }
        
    }
}


// MARK:  - UITextFieldDelegate
extension AddAnnualAddVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textUseAnlHour, textUseAnlDay , textUseAnlMin:
            vwLine.backgroundColor = UIColor.init(hexString: "#043856");
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case textUseAnlHour, textUseAnlHour , textUseAnlMin:
            vwLine.backgroundColor = UIColor.init(hexString: "#DADADA");
        default:
            break;
        }
    }
}

// MARK: - UIPickerViewDelegate
extension AddAnnualAddVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerDay.count
        }else if component == 1 {
            return pickerHour.count
        }else{
            return pickerMin.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerDay[row]
        }else if component == 1 {
            return pickerHour[row]
        }else{
            return pickerMin[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            dayTemp1 = row
            textUseAnlDay.text = pickerDay[row]
        }else if component == 1 {
            hourTmep1 = row
            textUseAnlHour.text = pickerHour[row]
        }else {
            minTemp1 = row
            textUseAnlMin.text = pickerMin[row]
        }
        
    }
}


// MARK: - UITextViewDelegate
extension AddAnnualAddVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblMemo.isHidden = true
        textView.layer.borderColor = UIColor.init(hexString: "#043856").cgColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            lblMemo.isHidden = false
        }
        textView.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textLength = textView.text.count
        lbltextlimit.text = "(\(textLength)/40)"
        if textView.text.count > 39 {
            textView.text.removeLast()
            let alert = UIAlertController(title: "알림", message: "메모는 40자 이내로 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
        if(text == "\n") {
            view.endEditing(true)
            return false
        }else {
            return true
        }
    }
    
}
