//
//  CmtTimeAddVC.swift
//  PinPle_ER
//
//  Created by WRY_010 on 2019/11/14.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemCmtTimeAddVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let device = DeviceInfo()
    let jsonClass = JsonClass()
    var dateFormatter = DateFormatter()
    
    var inputData = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    
    var sid = 0
    var empsid = 0
    var txtFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        txtEndDate.delegate = self
        txtStartTime.delegate = self
        txtEndTime.delegate = self
        
        addToolBar(textFields: [txtEndDate, txtStartTime, txtEndTime])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpCmtList") as! TemEmpCmtList
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func valueSetting() {
        sid = SelCmtInfo.sid
        empsid = SelEmpInfo.sid
        
        if sid == 0 {
            lblStartDate.text = SelCmtInfo.startdt
            txtEndDate.text = SelCmtInfo.enddt
            txtStartTime.text = "00:00"
            txtEndTime.text = "00:00"
        }else {
            lblStartDate.text = SelCmtInfo.startdt.components(separatedBy: " ")[0].replacingOccurrences(of: "-", with: ".")
            txtEndDate.text = SelCmtInfo.enddt.components(separatedBy: " ")[0].replacingOccurrences(of: "-", with: ".")
            txtStartTime.text = SelCmtInfo.startdt.components(separatedBy: " ")[1]
            txtEndTime.text = SelCmtInfo.enddt.components(separatedBy: " ")[1]
        }
    }
    @IBAction func btnSave(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(관리자가 직원 근무기록 직접 입력 - 정상근무로 등록됨)
         Return  - 성공:1, 실패:0, 시간중복 : -1
         Parameter
         EMPSID        직원번호
         SDT            근무 시작일자(형식 : 2019-10-10 09:10) .. URL 인코딩
         EDT            근무 종료일자.. 종료일자는 시작일자보다 큰 시간이어야 함(형식 : 2019-10-10 18:20) .. URL 인코딩
         */
        let sdt = httpRequest.urlEncode(lblStartDate.text!.replacingOccurrences(of: ".", with: "-") + " " + txtStartTime.text!.replacingOccurrences(of: ".", with: "-"))
        let edt = httpRequest.urlEncode(txtEndDate.text!.replacingOccurrences(of: ".", with: "-") + " " + txtEndTime.text!.replacingOccurrences(of: ".", with: "-"))
        
        NetworkManager.shared().InsUdtCmtmgr(cmtsid: 0, empsid: empsid, sdt: sdt, edt: edt) { (isSuccess, resultCode) in
            if (isSuccess) {
                switch resultCode {
                case -1:
                    self.customAlertView("시간이 중복 됩니다.\n 다시 확인해주세요");
                case 0:
                    self.customAlertView("다시 시도해주세요.");
                case 1:
                    self.toast("정상 처리 되었습니다.")
                    let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpCmtList") as! TemEmpCmtList
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                default:
                    break;
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    
    @IBAction func datePicker(_ sender: UITextField) {
        let goDatePickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        var loc: Locale?
        
        endDate = txtEndDate.text!
        startTime = txtStartTime.text!
        endTime = txtEndTime.text!
        
        if sender == txtEndDate {
            print("txtEndDate")
            goDatePickerView.datePickerMode = UIDatePicker.Mode.date
            dateFormatter.dateFormat = "yyyy-MM-dd"
            loc = Locale(identifier: "ko_kr")
            inputData = endDate.replacingOccurrences(of: ".", with: "-")
            txtFlag = 0
        }else if sender == txtStartTime {
            print("txtStartTime")
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            dateFormatter.dateFormat = "HH:mm"
            //            goDatePickerView.minuteInterval = 10
            loc = Locale(identifier: "en_GB")
            inputData = startTime
            txtFlag = 1
        }else if sender == txtEndTime {
            print("txtEndTime")
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            dateFormatter.dateFormat = "HH:mm"
            //            goDatePickerView.minuteInterval = 10
            loc = Locale(identifier: "en_GB")
            inputData = endTime
            txtFlag = 2
        }
        
        goDatePickerView.locale = loc
        sender.inputView = goDatePickerView
        
        print("inputData = ", inputData)
        if inputData != "" {
            let date = dateFormatter.date(from: inputData)
            goDatePickerView.date = date!
        }
        
        if txtFlag == 0 {
            let timeInterval: TimeInterval = 24*60*60
            goDatePickerView.minimumDate = dateFormatter.date(from: lblStartDate.text!)
            goDatePickerView.maximumDate = NSDate(timeInterval: timeInterval, since: dateFormatter.date(from: lblStartDate.text!)!) as Date
        }else if txtFlag == 2 && lblStartDate.text == txtEndDate.text {
            goDatePickerView.minimumDate = dateFormatter.date(from: startTime)
        }
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        switch txtFlag {
        case 0:
            self.txtEndDate.becomeFirstResponder();
        case 1:
            self.txtStartTime.becomeFirstResponder();
        case 2:
            self.txtEndTime.becomeFirstResponder();
        default:
            break;
        }
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        switch txtFlag {
        case 0:
            self.endDate = dateFormatter.string(from: sender.date)
            self.txtEndDate.text = self.endDate.replacingOccurrences(of: "-", with: ".")
            self.txtEndTime.text = "00:00"
        case 1:
            self.startTime = dateFormatter.string(from: sender.date)
            self.txtStartTime.text = self.startTime
        case 2:
            self.endTime = dateFormatter.string(from: sender.date)
            self.txtEndTime.text = self.endTime
        default:
            break;
        }
    }
}
