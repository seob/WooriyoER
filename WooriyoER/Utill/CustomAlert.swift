//
//  CustomAlert.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/20.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation

extension UIViewController {
    func alertView(_ value: String) {
        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    //알림창
    func alertView(_ value: String, _ textField: UITextField) {
        let alert = UIAlertController(title: "알림", message: "\(value)", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in textField.becomeFirstResponder()})
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    // 커스텀 알림창 (확인버튼만 있는경우)
    func customAlertView(_ value:String){
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomPopUp") as! CustomPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.contents = value
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // 커스텀 알림창 (포커스 이동)
    func customAlertView(_ value:String , _ textField: UITextField){
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomPopUp") as! CustomPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.contents = value
        vc.focusTextField = textField
        self.present(vc, animated: true, completion: nil)
    }
    
    // 커스텀 알림창 (확인버튼,취소버트)
    func customActionAlertView(_ value:String){
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomActionPopUp") as! CustomActionPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.contents = value
        self.present(vc, animated: true, completion: nil)
    }
    
    func customActionAlertView(_ value:String, _ textField: UITextField){
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomActionPopUp") as! CustomActionPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.contents = value
        vc.focusTextField = textField
        self.present(vc, animated: true, completion: nil)
    }
    
    func customSMSAlertView(){
        let vc = ContractSB.instantiateViewController(withIdentifier: "ContractSMSPopup") as! ContractSMSPopup
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
//MARK: - End
}
