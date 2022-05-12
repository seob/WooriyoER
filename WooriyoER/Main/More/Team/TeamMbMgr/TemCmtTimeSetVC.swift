//
//  CmtTimeSetVC.swift
//  PinPle
//
//  Created by WRY_010 on 16/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemCmtTimeSetVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var vwAdd: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblLeave: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let device = DeviceInfo()
    let jsonClass = JsonClass()
    var dateFormatter = DateFormatter()
    
    var EmplyInfoDetail: EmplyInfoDetail!
    
    var inputData: String = ""
    var endDate: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var seldt: String = ""
    
    var sid: Int = 0
    var empsid: Int = 0
    var txtFlag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAdd.isHidden = true
        btnAdd.layer.cornerRadius = 6
        btnSave.layer.cornerRadius = 6
        txtEndDate.delegate = self
        txtStartTime.delegate = self
        txtEndTime.delegate = self
        
        addToolBar(textFields: [txtEndDate, txtStartTime, txtEndTime])
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
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
        let type = SelCmtInfo.type
        sid = SelCmtInfo.sid
        empsid = SelEmpInfo.sid
        //근무타입(0.데이터 없음 1.정상출근 2.지각 3.조퇴 4.야근 5.휴일근로 6.출장 7.외출 8.연차 9.결근)
        var titleStr = ""
        switch type {
        case 0:
            titleStr = "근로시간 추가";
            self.vwAdd.isHidden = true;
            self.btnAdd.isHidden = false;
            self.btnView.isHidden = true;
        case 1:
            titleStr = "근로시간 수정";
            self.btnView.isHidden = false;
            self.vwAdd.isHidden = true;
        case 2:
            titleStr = "지각시간 수정";
            self.btnView.isHidden = false;
            self.vwAdd.isHidden = true;
        case 3:
            titleStr = "근로시간 수정";
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.vwAdd.isHidden = true;
            self.btnView.isHidden = false;
        case 4:
            titleStr = "근로시간 수정";
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.vwAdd.isHidden = false;
            self.btnView.isHidden = false;
        case 5:
            titleStr = "근로시간 수정";
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.vwAdd.isHidden = false;
            self.btnView.isHidden = false;
        case 6:
            titleStr = "근로시간 수정";
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.vwAdd.isHidden = false;
            self.btnView.isHidden = false;
        case 7:
            titleStr = "외출시간 수정";
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.vwAdd.isHidden = false;
            self.btnView.isHidden = false;
        case 8:
            titleStr = "연차시간 수정";
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.vwAdd.isHidden = false;
            self.btnView.isHidden = false;
        case 9:
            titleStr = "근로시간 수정";
            self.lblWork.text = "시작"
            self.lblLeave.text = "종료"
            self.vwAdd.isHidden = true;
            self.btnView.isHidden = false;
        default:
            break;
        }
        
        if sid == 0 {
            lblStartDate.text = seldt
            txtEndDate.text = seldt
            txtStartTime.text = "00:00"
            txtEndTime.text = "00:00"
        }else {
            lblStartDate.text = SelCmtInfo.startdt.components(separatedBy: " ")[0].replacingOccurrences(of: "-", with: ".")
            txtEndDate.text = SelCmtInfo.enddt.components(separatedBy: " ")[0].replacingOccurrences(of: "-", with: ".")
            txtStartTime.text = SelCmtInfo.startdt.components(separatedBy: " ")[1]
            txtEndTime.text = SelCmtInfo.enddt.components(separatedBy: " ")[1]
        }
        
        lblNavigationTitle.text = titleStr
    }
    @IBAction func btnSave(_ sender: UIButton) {
        let sdt = httpRequest.urlEncode(lblStartDate.text!.replacingOccurrences(of: ".", with: "-") + " " + txtStartTime.text!.replacingOccurrences(of: ".", with: "-"))
        let edt = httpRequest.urlEncode(txtEndDate.text!.replacingOccurrences(of: ".", with: "-") + " " + txtEndTime.text!.replacingOccurrences(of: ".", with: "-"))
        
        NetworkManager.shared().InsUdtCmtmgr(cmtsid: sid, empsid: empsid, sdt: sdt, edt: edt) { (isSuccess, resultCode) in
            if (isSuccess) {
                
                switch resultCode {
                case -1:
                    self.customAlertView("시간이 중복 됩니다.\n 다시 확인해주세요");
                case 0:
                    self.customAlertView("다시 시도해주세요.");
                case 1:
                    self.toast("정상적으로 처리 되었습니다.")
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
    
    @IBAction func btnCmtAdd(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemCmtTimeAddVC") as! TemCmtTimeAddVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func btnDelete(_ sender: UIButton) {
        
        if SelCmtInfo.type == 9 {
            self.customAlertView("결근은 삭제할 수 없습니다.")
        }else {
            /*
             Pinpl Android SmartPhone APP으로부터 요청받은 데이터 처리(관리자가 직원 근무기록 직접 삭제.. Type 9.결근은 삭제불가..앱에서 막아야됨)
             Return  - 성공:1, 실패:0
             Parameter
             CMTSID        근무기록 번호
             EMPSID        직원번호
             */
            NetworkManager.shared().DelCmtmgr(cmtsid: sid, empsid: empsid) { (isSuccess, resultCode) in
                if (isSuccess) {
                    if resultCode == 1 {
                        self.toast("정상적으로 처리 되었습니다.")
                        let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpCmtList") as! TemEmpCmtList
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }else {
                        self.customAlertView("잠시 후, 다시 시도해 주세요.")
                    }
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
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
            //            let startTimeArr = startTime.components(separatedBy: ":")
            //            let endTimeArr = endTime.components(separatedBy: ":")
            self.txtEndTime.text = self.endTime
        default:
            break;
        }
    }
    
}
