//
//  RtrPrcVC.swift
//  PinPle
//
//  Created by WRY_010 on 17/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemRtrPrcVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var txtJoinDt: UITextField!
    @IBOutlet weak var txtRtrDt: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var lblCmtMonth: UILabel!
    @IBOutlet weak var lblCmtDay: UILabel!
    @IBOutlet weak var lblAnlDay: UILabel!
    @IBOutlet weak var lblAnlHour: UILabel!
    @IBOutlet weak var lblAnlMin: UILabel!
    @IBOutlet weak var btnOut: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    
    var showDate = ""
    var inputDate = ""
    var ori_birth = ""
   
    var empsid = 0
    var joindt = ""
    var temname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnOut)
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.clear.cgColor
        imgProfile.clipsToBounds = true
        
        txtRtrDt.delegate = self
        addToolBar(textFields: [txtRtrDt])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblName.text = SelEmpInfo.name
        let profimg = UIImage(named: "logo_pre")
        if SelEmpInfo.profimg.urlTrim() != "img_photo_default.png" {
            imgProfile.setImage(with: SelEmpInfo.profimg)
        }else{
            imgProfile.image = profimg
        }
        lblTname.text = temname
        txtJoinDt.text = joindt.replacingOccurrences(of: "-", with: ".")
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpInfoVC") as! TemEmpInfoVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func popShow(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemRtrPrcInfoPopUp") as! TemRtrPrcInfoPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func rtrClick(_ sender: UIButton) {
        if txtRtrDt.text != "" {
            let vc = MoreSB.instantiateViewController(withIdentifier: "TemRtrPrcPopUp") as! TemRtrPrcPopUp
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.name = SelEmpInfo.name
            vc.tname = temname
            vc.empsid = empsid
            vc.inputDate = inputDate.replacingOccurrences(of: "-", with: ".")
            self.present(vc, animated: true, completion: nil)
        }else {
            self.customAlertView("퇴사일을 입력하세요.", txtRtrDt)
        }
        
    }
    
    func getInfo() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(퇴직처리를 위한 근로기간, 미사용연차 조회)
         Return  - 근로기간 + 미사용연차
         Parameter
         EMPSID        직원번호
         LEAVEDT        퇴직일자(형식 2019-11-30)
         */
        NetworkManager.shared().GetLeaveinfo(empsid: empsid, leavedt: inputDate) { (isSuccess, unused, workday, workmonth, workyear) in
            if (isSuccess) {
                self.lblCmtMonth.text = "\(workyear * 12 + workmonth)"
                self.lblCmtDay.text = "\(workday)"
                
                let day = unused/(8*60)
                let hour = (unused%(8*60))/60
                let min = (unused%(8*60))%60
                
                self.lblAnlDay.text = "\(day)"
                self.lblAnlHour.text = "\(hour)"
                self.lblAnlMin.text = "\(min)"
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
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
        
        sender.inputView = goDatePickerView
        let mindate = dateFormatter.date(from: txtJoinDt.text!)
        goDatePickerView.minimumDate = mindate
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        txtRtrDt.becomeFirstResponder()
        getInfo()
    }
    //MARK: @objc
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        textDateFormatter.dateFormat = "yyyy.MM.dd"
        inputDate = dateFormatter.string(from: sender.date)
        showDate = textDateFormatter.string(from: sender.date)
        txtRtrDt.text = showDate
        getInfo()
        
    }
    
    
}

