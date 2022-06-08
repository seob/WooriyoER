//
//  CmpVC.swift
//  PinPle
//
//  Created by WRY_010 on 03/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textEName: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEName: UILabel!
    @IBOutlet weak var vwLine1: UIView!
    @IBOutlet weak var vwLine2: UIView!
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    
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
    
    //MARK: - view override
    override func viewDidLoad() {
        print("\n-----------------[UIViewController : \(self) ]---------------------\n")
        print("\n-----------------[ func : \(#function) ]---------------------\n")
        super.viewDidLoad()
        EnterpriseColor.eachLblBtn(btnNext, lblNext)
        // intro stage
        prefs.setValue(3, forKey: "stage")
        
        //delegate
        textName.delegate = self
        textEName.delegate = self
        
        //isHidden
        lblName.isHidden = true
        lblEName.isHidden = true
        
        //etc
        addToolBar(textFields: [textName, textEName])
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = LoginSignSB.instantiateViewController(withIdentifier: "AddInfo") as! AddInfo
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //MARK: - @IBAction
    @IBAction func bthNext(_ sender: UIButton) {
        print(valueCheck())
        let mbrsid = userInfo.mbrsid
        let name = textName.text!.urlEncoding()
        let ename = textEName.text!.urlEncoding()
        
        if valueCheck() {
            IndicatorSetting()
            NetworkManager.shared().regCmpny(mbrsid: mbrsid, name: name, ename: ename) { (isSuccess, resCode, resEmpsid) in
                if(isSuccess){
                    switch resCode{//0.실패, -1.이미합류 default.성공,
                    case 0:
                        print("생성 실패");
                    case -1:
                        self.customAlertView("이미 등록된 회사명입니다.\n 다시 입력해주세요", self.textName);
                    default:
                        userInfo.empsid = resEmpsid
                        CompanyInfo.sid = resCode
                        CompanyInfo.name = self.textName.text!
                        CompanyInfo.enname = self.textEName.text!
                        
                        let vc = CmpCrtSB.instantiateViewController(withIdentifier: "CmpInfoVC") as! CmpInfoVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
        
    }
    //MARK: func
    func valueCheck() -> Bool{
        let name = textName.text!
        let enname = textEName.text!
        
        if name == "" {
            print("name = ", name)
            self.customAlertView("회사명을 입력하세요.", textName)
            return false
        }
        return true
    }    
    
}

extension CmpVC: UITextFieldDelegate {
    //키보드 자동 포커스 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {        
        if textField == textName {
            textField.resignFirstResponder()
            textEName.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textName {
            lblName.isHidden = false
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }else {
            lblEName.isHidden = false
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#043856").cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textName {
            if textField.text == "" {
                lblName.isHidden = true
            }
            vwLine1.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }else {
            if textField.text == "" {
                lblEName.isHidden = true
            }
            vwLine2.layer.backgroundColor = UIColor.init(hexString: "#DADADA").cgColor
        }
    }
}
