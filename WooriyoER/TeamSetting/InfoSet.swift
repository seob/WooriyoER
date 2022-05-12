//
//  InfoSet.swift
//  PinPle_EE
//
//  Created by WRY_010 on 2019/12/06.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class InfoSet: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblJoinDt: UILabel!
    @IBOutlet weak var textJoinDt: UITextField!
    @IBOutlet weak var textAnl: UITextField!
    
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var textSpot: UITextField!
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var btnSav: UIButton!
    
    var dateFormatter = DateFormatter()     // "yyyy-MM-dd"
    
    var inputDate: String = ""              // datepicker 들어가는 날짜
    
    var name: String = ""                   // 유저 이름
    var profimg: String = ""                //유저 프로필 url
    var joindt: String = ""                 // 유저 가입 날짜
    
    // MARK: - IndicatorSetting
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    fileprivate func IndicatorSetting() {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs.setValue(15, forKey: "stage")
        btnSav.layer.cornerRadius = 6
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        imgProfile.makeRounded()
        
        textJoinDt.delegate = self
        textSpot.delegate = self
        
        textSpot.returnKeyType = .done
        
        lblJoinDt.isHidden = true
        lblSpot.isHidden = true
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        addToolBar(textFields: [textJoinDt, textSpot])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.name = userInfo.name
        self.profimg = userInfo.profimg
        self.joindt = userInfo.joindt
        
        lblName.text = name
        
        if profimg.urlTrim() != "img_photo_default.png" {
            imgProfile.setImage(with: profimg)
        }else {
            imgProfile.image = defaultImg
        }
        
        if joindt == "1900-01-01" {
            textJoinDt.text = ""
        }else {
            textJoinDt.text = joindt
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollview.contentInset
        //        contentInset.bottom = keyboardFrame.size.height
        contentInset.bottom = UIScreen.main.bounds.size.height / 2
        self.scrollview.contentInset = contentInset
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollview.contentInset = contentInset
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = TmCrtSB.instantiateViewController(withIdentifier: "ExcldWorkVC") as! ExcldWorkVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        action()
    }
    func action() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 추가정보 입력)
         Return  - 성공:1, 실패:0
         Parameter
         EMPSID        직원번호
         SPOT        직급(직책).. URL 인코딩
         JNDT        입사일(형식 : 2018-05-05).. URL 인코딩
         USE            사용한 연차(분환산 - 1일 8시간) 2일 4시간 = (2*8*60) + (4*60) = 1200
         ADD            추가된 연차(분환산 - 1일 8시간) 2일 4시간 = (2*8*60) + (4*60) = 1200
         set_emp_addinfo
         */
        let spot = textSpot.text!
        let joindt = textJoinDt.text!.replacingOccurrences(of: ".", with: "-")
        
        if textJoinDt.text != "" {
            IndicatorSetting()
            NetworkManager.shared().SetEmpAddinfo(empsid: userInfo.empsid, spot: spot.urlEncoding(), joindt: joindt.urlEncoding(), usemin: 0, addmin: 0) { (isSuccess, error, result) in
                if (isSuccess) {
                    if error == 1 {
                        if result == 1 {
                            userInfo.spot = spot
                            userInfo.joindt = joindt
                            
                            var vc = UIViewController()
                            if prefs.value(forKey: "intro") != nil {
                                if SE_flag {
                                    vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC")
                                }else {
                                    vc = MainSB.instantiateViewController(withIdentifier: "MainVC")
                                }
                            }else {
                                if SE_flag {
                                    vc = IntroSB.instantiateViewController(withIdentifier: "SE_IntroVC1")
                                }else {
                                    vc = IntroSB.instantiateViewController(withIdentifier: "IntroVC1")
                                }
                            }
                            prefs.removeObject(forKey: "stage")
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false, completion: nil)
                        }else {
                            self.toast("잠시 후, 다시 시도해 주세요.")
                        }
                    }else {
                        self.toast("다시 시도해 주세요.")
                    }
                }else {
                    self.customAlertView("네트워크 상태를 확인해 주세요.")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }else {
            self.customAlertView("입사일은 필수 입력입니다.")
        }
    }
    
    // MARK: 입사일 데이트픽커
    @IBAction func datePicker(_ sender: UITextField) {
        let goDatePickerView = UIDatePicker()
        goDatePickerView.locale = Locale(identifier: "ko_kr")
        goDatePickerView.datePickerMode = UIDatePicker.Mode.date
        goDatePickerView.maximumDate = Date()
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        if textJoinDt.text! == "" {
            goDatePickerView.date = Date()
        }else {
            inputDate = textJoinDt.text!.replacingOccurrences(of: ".", with: "-")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: inputDate)
            goDatePickerView.date = date!
        }
        
        sender.inputView = goDatePickerView
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        textJoinDt.becomeFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        inputDate = dateFormatter.string(from: sender.date)
        textJoinDt.text = inputDate.replacingOccurrences(of: "-", with: ".")
        countAnl()
        //        textAnl.text = "\(getAnualDay(strJoinDt: inputDate))"
    }
    func countAnl() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(입사일기준 연차계산 - 분단위 환산)
         Return  - 연차(분단위환산 - 하루 8시간)
         Parameter
         JOINDT        입사일자(형식 : 2018-05-05).. URL 인코딩
         get_anualmin
         */
        let joindt = textJoinDt.text!.replacingOccurrences(of: ".", with: "-").urlEncoding()
        NetworkManager.shared().GetAnualmin(joindt: joindt) { (isSuccess, resultCode) in
            if (isSuccess) {
                if resultCode >= 0 {
                    self.textAnl.text = String(resultCode / (8*60))
                }else {
                    self.toast("잠시 후, 다시 시도해 주세요.")
                }
            }else {
                self.toast("다시 시도해 주세요.")
            }
        }
    }
}
// MARK: - extension UITextFieldDelegate
extension InfoSet: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textSpot.resignFirstResponder()        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textJoinDt {
            lblJoinDt.isHidden = false
            vwLine1.layer.backgroundColor = customBlue
        }else {
            lblSpot.isHidden = false
            vwLine2.layer.backgroundColor = customBlue
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textJoinDt {
            if textField.text == "" {
                lblJoinDt.isHidden = true
            }
            vwLine1.layer.backgroundColor = customGray
        }else {
            if textField.text == "" {
                lblSpot.isHidden = true
            }
            vwLine2.layer.backgroundColor = customGray
        }
    }
}


