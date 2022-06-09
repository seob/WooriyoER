//
//  EmpInfoVC.swift
//  PinPle
//
//  Created by WRY_010 on 15/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class EmpInfoVC: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var textEName: UITextField!
    @IBOutlet weak var textJoinDt: UITextField!
    @IBOutlet weak var textSpot: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var textExtNember: UITextField!
    @IBOutlet weak var textTem: UITextField!
    @IBOutlet weak var btnExt: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var vwLine5: UIView!
    @IBOutlet weak var vwLine7: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let device = DeviceInfo()
    let jsonClass = JsonClass()
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    let useAnlPicker = UIPickerView()
    let addAnlPicker = UIPickerView()
    var inputDate = ""
    var showDate = ""
    
    var joindt = ""
    var usemin = 0
    var addmin = 0
    var temname = ""
    var textFlag = 0
    
    var dayTemp1 = 0
    var dayTemp2 = 0
    var hourTmep1 = 0
    var hourTmep2 = 0
    var minTemp1 = 0
    var minTemp2 = 0
    
    var pickerDay: [String] = []
    var pickerHour: [String] = []
    
    var btnFlag = false
    
    //2020.01.22 뷰 이동 변수 넘김 수정
    var selauthor = 0
    var selempsid = 0
    var selenddt = ""
    var selenname = ""
    var selmbrsid = 0
    var selmemo = ""
    var selname = ""
    var selphone = ""
    var selphonenum = ""
    var selprofimg = ""
    var selspot = ""
    var selstartdt = ""
    var seltype = 0
    var selworkmin = 0
    
    var tempMbrInfo = getMbrInfo()
    var tmpEmpInfo = EmpInfoList()
    
    var viewflag2: String = ""
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadList, object: nil)
 
        
        textEName.delegate = self
   
        textSpot.delegate = self
        textPhone.delegate = self
        textExtNember.delegate = self
        textTem.delegate = self
        

        addToolBar(textFields: [textSpot, textExtNember], textView: textView)
        addToolBar(textFields: [textSpot], textView: textView)

        textEName.isEnabled = false
        textTem.isEnabled = false
        textPhone.isEnabled = false
        
        textPhone.textColor = .black // text color 수정
        textTem.textColor = .black // text color 수정
        textEName.textColor = .black // text color 수정
        
        textView.delegate = self
        textView.layer.cornerRadius = 6
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.init(hexString: "#DADADA").cgColor
         
        
        var titleStr = selname
        if selspot != "" {
            titleStr += "(" + selspot + ")"
        }
        lblNavigationTitle.text = titleStr
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        print("\n---------- [ empsid : \(SelEmpInfo.sid) , mbrsid : \(SelEmpInfo.mbrsid)] ----------\n")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if btnFlag {
            temname = ""
            btnExt.isHidden = true
        }
        valueSetting()
        getEmpinfo()
    }
    
    // MARK: reloadTableData
    @objc func reloadTableData(_ notification: Notification) {
        getEmpinfo()
        valueSetting()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
 
    }
  
    func getEmpinfo(){
        NetworkManager.shared().GetEmpInfo(empsid: SelEmpInfo.sid) { (isSuccess, resData) in
            if (isSuccess){
                guard let serverData = resData else { return }
                self.tmpEmpInfo = serverData
                self.addmin = serverData.addmin
                self.usemin = serverData.usemin
                self.selphone = serverData.phone
                self.selphonenum = serverData.phonenum
                self.joindt = serverData.joindt
                self.selempsid = serverData.empsid
                
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    func valueSetting() {
        print("\n---------- [ valueSetting mbrsid : \(SelEmpInfo.mbrsid) ] ----------\n")
        NetworkManager.shared().GetMbrInfo(mbrsid: SelEmpInfo.mbrsid) { (isSuccess, resData) in
            
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tempMbrInfo = serverData
                self.selmemo = serverData.memo
                self.joindt = serverData.joindt
                self.selspot = serverData.spot
                
                self.temname = serverData.temname != "" ? serverData.temname : serverData.ttmname
                self.FormLayout() 
                 
            }else{
                self.customAlertView("다시 시도해 주세요.")
                 
            }
        }
        
    }
    
    // 레이아웃
    func FormLayout(){
        if tempMbrInfo.enname == "" {
            textEName.text = "없음"
        }else {
            textEName.text = tempMbrInfo.enname
        }
        textSpot.text = tempMbrInfo.spot
        textPhone.text = tempMbrInfo.phonenum.pretty()       
        textExtNember.text = selphone
        textTem.text = temname
        
        if tempMbrInfo.ttmsid == 0 && tempMbrInfo.temsid == 0 {
            btnExt.isHidden = true
            textTem.text = "무소속"
        }
        
        if self.selmemo == "" {
            self.lblMemo.isHidden = false
        }else {
            self.lblMemo.isHidden = true
            self.textView.text = self.selmemo
        }
        
        var titleStr = selname
        if selspot != "" {
            titleStr += "(" + selspot + ")"
        }
        lblNavigationTitle.text = titleStr
        
        //        Spinner.stop()
        
 
    } 
}
   
// MARK: IBAction
extension EmpInfoVC  {
    // 저장
    @IBAction func save(_ sender: UIButton) {
        let spot = httpRequest.urlEncode(textSpot.text!)
        let pn = httpRequest.urlEncode(textExtNember.text!)
        let mm = httpRequest.urlEncode(textView.text!)
         
        NetworkManager.shared().UpdateMyInfo(empsid: SelEmpInfo.sid, spot: spot, pn: pn, mm: mm) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    self.toast("직원정보가 수정되었습니다.")
                    
                    if self.viewflag2 == "TotalEmpLits" {
                        let vc = MainSB.instantiateViewController(withIdentifier: "TotalEmpLits") as! TotalEmpLits
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        NotificationCenter.default.post(name: .reloadList, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
        
    }
    
    @IBAction func exceptEmp(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoPopUpCancel") as! EmpInfoPopUpCancel
        vc.modalTransitionStyle = .crossDissolve
        print("temname = ", tempMbrInfo.temname , "ttmsid : \(tempMbrInfo.ttmsid) temsid :\(tempMbrInfo.temsid)")
        vc.modalPresentationStyle = .overCurrentContext
        vc.temname = temname
        vc.ttmsid = tempMbrInfo.ttmsid
        vc.temsid = tempMbrInfo.temsid
        vc.selauthor = selauthor
        vc.selempsid = selempsid
        vc.selenddt = selenddt
        vc.selenname = selenname
        vc.selmbrsid = selmbrsid
        vc.selmemo = selmemo
        vc.selname = selname
        vc.selphone = selphone
        vc.selphonenum = selphonenum
        vc.selprofimg = selprofimg
        vc.selspot = selspot
        vc.selstartdt = selstartdt
        vc.seltype = seltype
        vc.selworkmin = selworkmin
        self.present(vc, animated: true, completion: nil)
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
    
    // 퇴사일 선택
    @IBAction func rtrPrc(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "RtrPrcVC") as! RtrPrcVC
        
        vc.selauthor = tempMbrInfo.author
        vc.selempsid = tempMbrInfo.empsid
        vc.selenddt = selenddt
        vc.selenname = tempMbrInfo.enname
        vc.selmbrsid = tempMbrInfo.mbrsid
        vc.selmemo = tempMbrInfo.memo
        vc.selname = tempMbrInfo.name
        vc.selphone = selphone
        vc.selphonenum = tempMbrInfo.phonenum.pretty()
        vc.selprofimg = tempMbrInfo.profimg
        vc.selspot = tempMbrInfo.spot
        vc.selstartdt = selstartdt
        vc.seltype = seltype
        vc.selworkmin = selworkmin
        vc.joindt = tempMbrInfo.joindt
        if tempMbrInfo.ttmsid == 0 && tempMbrInfo.temsid == 0 {
            vc.temname = "무소속"
        }else{
            vc.temname = temname
        }
        
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}
// MARK:  - UITextFieldDelegate
extension EmpInfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textSpot:
            vwLine5.backgroundColor = UIColor.init(hexString: "#043856");
        case textExtNember:
            vwLine7.backgroundColor = UIColor.init(hexString: "#043856");
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case textSpot:
            vwLine5.backgroundColor = UIColor.init(hexString: "#DADADA");
        case textExtNember:
            vwLine7.backgroundColor = UIColor.init(hexString: "#DADADA");
        default:
            break;
        }
    }
}

// MARK: - UITextViewDelegate
extension EmpInfoVC: UITextViewDelegate {
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
        print("textView.text.count = ", textView.text.count)
        if textView.text.count > 100 {
            textView.text.removeLast()
            let alert = UIAlertController(title: "알림", message: "팀(부서)에 대한 설명은 100자 이내로 입력하세요.", preferredStyle: UIAlertController.Style.alert)
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
