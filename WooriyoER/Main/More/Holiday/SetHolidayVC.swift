//
//  SetHolidayVC.swift
//  PinPle
//
//  Created by WRY_010 on 02/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//
import UIKit

class SetHolidayVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDay: UITextField!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var vwNo: CustomView!
    @IBOutlet weak var vwYear: CustomView!
    @IBOutlet weak var vwBtn1: UIView!
    @IBOutlet weak var vwBtn2: UIView!
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var dateFormatter = DateFormatter()
    var textDateFormatter = DateFormatter()
    var pickerDate = Date()
    
//    var holiTuple: [(String, String, Int, Int)] = []
    var holiTuple: [HolidayInfo] = []
    var showDate = ""
    var inputDate = ""
    
    var addflag = false
    var rptFlag = 1
    
    var selTitle = ""
    var selDate = ""
    var selRpt = 0
    var selSid = 0
    var holiday = 0
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n---------- [ more : \(moreCmpInfo.holiday) , holiday : \(self.holiday)] ----------\n")
        txtDay.delegate = self
        txtTitle.delegate = self
        btnModify.layer.cornerRadius = 6
        btnSave.layer.cornerRadius = 6
        btnYear.layer.cornerRadius = 6
        addToolBar(textFields: [txtTitle, txtDay])
        
        if addflag {
            vwBtn1.isHidden = false
            vwBtn2.isHidden = true
        }else {
            vwBtn1.isHidden = true
            vwBtn2.isHidden = false
        }
        
        if selTitle != "" {
            txtTitle.text = selTitle
            txtDay.text = selDate
            txtDay.textColor = .black
            let date = selDate.replacingOccurrences(of: ".", with: "-")
            inputDate = date.components(separatedBy: "(")[0]
            print(inputDate)
            switch selRpt {
            case 0:
                lblNo.textColor = UIColor.black;
                lblYear.textColor = UIColor.init(hexString: "#DADADA");
                
//                vwNo.shadowColor = UIColor.white;
//                vwYear.shadowColor = UIColor.black;
//
//                vwNo.startColor = UIColor.init(hexString: "#043956");
//                vwNo.endColor = UIColor.init(hexString: "#161D4A");
//                vwYear.startColor = UIColor.white;
//                vwYear.endColor = UIColor.white;
                
                rptFlag = 0;
                
            case 1:
                lblNo.textColor = UIColor.init(hexString: "#DADADA");
                lblYear.textColor = UIColor.black;
                
//                vwNo.shadowColor = UIColor.black;
//                vwYear.shadowColor = UIColor.white;
                
//                vwNo.startColor = UIColor.white;
//                vwNo.endColor = UIColor.white;
//                vwYear.startColor = UIColor.init(hexString: "#043956");
//                vwYear.endColor = UIColor.init(hexString: "#161D4A");
                
                rptFlag = 1;
                
            default:
                break;
            }
        }else {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            let dateString = dateFormatter.string(from: today)
            textDateFormatter.dateFormat = "yyyy-MM-dd"
            inputDate = textDateFormatter.string(from: today)
            print("today = ", today)
            txtDay.textColor = .lightGray
            txtDay.text = dateString
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "HolidayListVC") as! HolidayListVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_HolidayListVC") as! HolidayListVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "HolidayListVC") as! HolidayListVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func clickNo(_ sender: UIButton) {
        lblNo.textColor = UIColor.black;
        lblYear.textColor = UIColor.init(hexString: "#DADADA");
        btnNo.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnYear.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
        
//        vwNo.shadowColor = UIColor.white;
//        vwYear.shadowColor = UIColor.black;
        
//        vwNo.startColor = UIColor.init(hexString: "#043956");
//        vwNo.endColor = UIColor.init(hexString: "#161D4A");
//        vwYear.startColor = UIColor.white;
//        vwYear.endColor = UIColor.white;
        
        rptFlag = 0;
    }
    
    
    @IBAction func clickYear(_ sender: UIButton) {
        lblNo.textColor = UIColor.init(hexString: "#DADADA");
        lblYear.textColor = UIColor.black;
        btnYear.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnNo.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
        
//        vwNo.shadowColor = UIColor.black;
//        vwYear.shadowColor = UIColor.white;
        
//        vwNo.startColor = UIColor.white;
//        vwNo.endColor = UIColor.white;
//        vwYear.startColor = UIColor.init(hexString: "#043956");
//        vwYear.endColor = UIColor.init(hexString: "#161D4A");
        
        rptFlag = 1;
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        if inputDate != "" {
            let date = dateFormatter.date(from: inputDate)
            goDatePickerView.date = date!
        }
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        txtDay.becomeFirstResponder()
    }
    @objc func datePickerValueChanged(_ sender:UIDatePicker)
    {
        print("sender.date = ", sender.date)
        pickerDate = sender.date
        textDateFormatter.dateFormat = "yyyy.MM.dd"
        
        inputDate = dateFormatter.string(from: sender.date)
        showDate = textDateFormatter.string(from: sender.date)
                
        txtDay.text = showDate
    }
    
    @IBAction func save(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사 특별휴무일 설정)
         Return  - 성공:1, 실패:0, 이미등록:-1
         Parameter
         CMPSID        회사번호
         DT            날짜(형식 : 2019-05-05) .. URL 인코딩
         NM            휴뮤일제목.. URL 인코딩
         RPT            반복설정 0.반복안함 1.매년 2.매월
         */
        
        let dt = httpRequest.urlEncode(inputDate)
        let nm = httpRequest.urlEncode(txtTitle.text!)
        let rpt = rptFlag
        if nm != "" {
            NetworkManager.shared().setCmpHolidayRx(cmpsid: userInfo.cmpsid, dt: dt, nm: nm, rpt: rpt)
                .subscribe(onNext: { (arg0) in
                    let (isSuccess, resCode) = arg0
                    if isSuccess {
                        switch resCode {
                        case -1:
                            self.customAlertView("이미 등록된 날짜입니다.\n 다시 입력해주세요");
                        case 0:
                            self.customAlertView("잠시후 다시 시도해 주세요");
                        default:
                            let vc = MoreSB.instantiateViewController(withIdentifier: "HolidayListVC") as! HolidayListVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.holiday = moreCmpInfo.holiday
                            self.present(vc, animated: false, completion: nil)
                        }
                    }
                }, onError: { (error) in
                    self.customAlertView("다시 시도해 주세요.")
                }).disposed(by: disposeBag)
        }else{
            self.toast("제목을 입력하세요.")
        }
    }
    
    @IBAction func update(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사 특별휴무일 변경)
         Return  - 성공:1, 실패:0, 기존등록:-1
         Parameter
         CMPSID        회사번호
         HLDSID        휴무일번호
         DT            날짜(형식 : 2019-05-05) .. URL 인코딩
         NM            휴뮤일제목.. URL 인코딩
         RPT            반복설정 0.반복안함 1.매년 2.매월
         */
//        let cmpsid = prefs.value(forKey: "cmpsid") as! Int
        
        let hldsid = selSid
        let dt = httpRequest.urlEncode(inputDate)
        let nm = httpRequest.urlEncode(txtTitle.text!)
        let rpt = rptFlag
        
        print("inputDate = ", inputDate)
        NetworkManager.shared().UdtCmpholiday(cmpsid: userInfo.cmpsid, hldsid: hldsid, dt: dt, nm: nm, rpt: rpt) { (isSuccess, resCode) in
            if(isSuccess){
                switch resCode {
                case 1:
                    let vc = MoreSB.instantiateViewController(withIdentifier: "HolidayListVC") as! HolidayListVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.holiday = moreCmpInfo.holiday
                    self.present(vc, animated: false, completion: nil)
                case 0:
                    self.customAlertView("다시 시도해 주세요.")
                case -1:
                    self.customAlertView("이미 등록되어 있습니다.")
                default:
                    break
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    @IBAction func deleteHoliday(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사 특별휴무일 삭제)
         Return  - 성공:1, 실패:0
         Parameter
         HLDSID        휴일번호
         CMPSID        회사번호
         */
//        let cmpsid = prefs.value(forKey: "cmpsid") as! Int
//        let cmpsid = userInfo.cmpsid
        let hldsid = selSid 
        NetworkManager.shared().DelCmpholiday(cmpsid: userInfo.cmpsid, hldsid: hldsid) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    let vc = MoreSB.instantiateViewController(withIdentifier: "HolidayListVC") as! HolidayListVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
}
