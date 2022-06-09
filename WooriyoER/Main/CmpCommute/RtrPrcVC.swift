//
//  RtrPrcVC.swift
//  PinPle
//
//  Created by WRY_010 on 17/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class RtrPrcVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var txtJoinDt: UITextField!
    @IBOutlet weak var txtRtrDt: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var lblCmtYear: UILabel!
    @IBOutlet weak var lblCmtMonth: UILabel!
    @IBOutlet weak var lblCmtDay: UILabel!
    @IBOutlet weak var lblAnlDay: UILabel!
    @IBOutlet weak var lblAnlHour: UILabel!
    @IBOutlet weak var btnOut: UIButton!
    @IBOutlet weak var lblAnlMin: UILabel!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    
    var showDate = ""
    var inputDate = ""
    var ori_birth = ""
    
    var joindt = ""
    var temname = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnOut)
        txtRtrDt.delegate = self
        addToolBar(textFields: [txtRtrDt])
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.clear.cgColor
        imgProfile.clipsToBounds = true
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblName.text = selname
//        imgProfile.image = selprofimg
        let defaultProfimg = UIImage(named: "logo_pre")
        if selprofimg.urlTrim() != "img_photo_default.png" {
            imgProfile.setImage(with: selprofimg)
         }else{
            imgProfile.image = defaultProfimg
         }
//        imgProfile.sd_setImage(with: URL(string: defaultProfimg), placeholderImage: UIImage(named: "no_picture"))
        lblTname.text = temname
        txtJoinDt.text = setDateDefault(timeStamp: joindt)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
//        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoVC") as! EmpInfoVC
//        vc.selname = self.selname
//        vc.joindt  = self.joindt
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false, completion: nil)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func popShow(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpInfoPopUpInfo3") as! EmpInfoPopUpInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    // FIXME : 팝업창
    @IBAction func rtrClick(_ sender: UIButton) {
        if txtRtrDt.text != "" {
            DispatchQueue.main.async {
                if let vc = UIStoryboard(name: "CmpCmt", bundle: nil).instantiateViewController(withIdentifier: "RtrPrcPopUP") as? RtrPrcPopUP {
                    vc.temname = self.temname
                    vc.inputDate = self.inputDate
                    vc.selauthor = self.selauthor
                    vc.selempsid = self.selempsid
                    vc.selenddt = self.selenddt
                    vc.selenname = self.selenname
                    vc.selmbrsid = self.selmbrsid
                    vc.selmemo = self.selmemo
                    vc.selname = self.selname
                    vc.selphone = self.selphone
                    vc.selphonenum = self.selphonenum
                    vc.selprofimg = self.selprofimg
                    vc.selspot = self.selspot
                    vc.selstartdt = self.selstartdt
                    vc.seltype = self.seltype
                    vc.selworkmin = self.selworkmin
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: false, completion: nil)
                }                
            }
        }else {
            self.customAlertView("퇴직일을 입력해 주세요.", txtRtrDt)
        }
        
    }
    
    
    @IBAction func getInfo(_ sender: UITextField) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(퇴직처리를 위한 근로기간, 미사용연차 조회)
         Return  - 근로기간 + 미사용연차
         Parameter
         EMPSID        직원번호
         LEAVEDT        퇴직일자(형식 2019-11-30)
         */
        if txtRtrDt.text != "" {
            let url = urlClass.get_leaveinfo(empsid: selempsid, leavedt: inputDate)
            httpRequest.get(urlStr: url) {(success, jsonData) in
                if success {
                    print(url)
                    print(jsonData)
                    
                    let unused = jsonData["unused"] as! Int
                    let workday = jsonData["workday"] as! Int
                    let workmonth = jsonData["workmonth"] as! Int
                    let workyear = jsonData["workyear"] as! Int
                    
//                    self.lblCmtMonth.text = String(workyear * 12 + workmonth)
//                    self.lblCmtDay.text = String(workday)
                    
                    self.lblCmtYear.text = "\(workyear)"
                    self.lblCmtMonth.text = "\(workmonth)"
                    self.lblCmtDay.text = "\(workday)"
                    
                    let day = unused/(8*60)
                    let hour = (unused%(8*60))/60
                    let min = (unused%(8*60))%60
                    
                    self.lblAnlDay.text = String(day)
                    self.lblAnlHour.text = String(hour)
                    self.lblAnlMin.text = String(min)
                }
            }
        }else {
            self.customAlertView("퇴사일을 입력하세요.")
            
        }
        
    }
    
    @IBAction func datePicker(_ sender: UITextField) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let goDatePickerView = UIDatePicker()
        goDatePickerView.datePickerMode = UIDatePicker.Mode.date
        goDatePickerView.locale = Locale(identifier: "ko_kr")
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        sender.inputView = goDatePickerView
        var date: Date!
        if txtRtrDt.text != "" {
            inputDate = txtRtrDt.text!
            showDate = txtRtrDt.text!
            date = dateFormatter.date(from: inputDate)
        }else {
            date = Date()
            txtRtrDt.text = (dateFormatter.string(from: date)).replacingOccurrences(of: "-", with: ".")
            inputDate = dateFormatter.string(from: date)
        }
        
        let mindate = dateFormatter.date(from: txtJoinDt.text!)
        goDatePickerView.date = date!
        goDatePickerView.minimumDate = mindate
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        txtRtrDt.becomeFirstResponder()
    }
    //MARK: @objc
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        textDateFormatter.dateFormat = "yyyy.MM.dd"
        inputDate = dateFormatter.string(from: sender.date)
        showDate = textDateFormatter.string(from: sender.date)
        txtRtrDt.text = showDate
    }
    
}
