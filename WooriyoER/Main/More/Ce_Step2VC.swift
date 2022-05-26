//
//  Ce_Step2VC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Ce_Step2VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var TextName: TextFieldEffects!
    @IBOutlet weak var TextSpot: TextFieldEffects!
    @IBOutlet weak var chkimgName: UIImageView!
    @IBOutlet weak var chkimgSpot: UIImageView!
    @IBOutlet weak var btnSign: UIButton!
    
    var selInfo : Ce_empInfo = Ce_empInfo()
    var textFields : [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSign.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        setUi()
    }
    
    
    func setUi(){
        TextName.isEnabled = false
        TextSpot.isEnabled = false
        chkimgName.isHidden = true
        chkimgSpot.isHidden = true
        
        textFields = [TextName , TextSpot]
        for textfield in textFields {
            textfield.delegate = self
        }
        addToolBar(textFields: textFields)
        TextName.text = userInfo.name
        TextSpot.text = userInfo.spot
        
        if TextName.text != "" {
            chkimgName.image = chkstatusAlertpass
        }
        
        if TextSpot.text != "" {
            chkimgSpot.image = chkstatusAlertpass
        }
        print("\n---------- [ selinfo : \(selInfo.toJSON()) ] ----------\n")
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if selInfo.format == 1 { //경력
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Career_Step1VC") as! Career_Step1VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.selInfo = self.selInfo
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step1VC") as! Ce_Step1VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.selInfo = self.selInfo
            self.present(vc, animated: false, completion: nil)
        }
        
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        Sel_CeEmpInfo = selInfo
        let sid = "\(selInfo.sid)"
        if selInfo.format == 0 {
            //재직증명서
            if let url = URL(string: "\(API.WEBbaseURL)m_ce/m_certEmplyWooriyo.jsp?CEYSID=\(sid.base64Encoding())") {
                UIApplication.shared.open(url, options: [:])
            }
        }else{
            //경력증명서
            if let url = URL(string: "\(API.WEBbaseURL)m_cc/m_certCareerWooriyo.jsp?CCTSID=\(sid.base64Encoding())") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
    }
    
}


// MARK: - UITextFieldDelegate
extension Ce_Step2VC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextName.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == TextName {
            if str != "" {
                chkimgName.image = chkstatusAlertpass
            }else{
                chkimgName.image = chkstatusAlert
            }
        }else if textField == TextSpot {
            if str != "" {
                chkimgSpot.image = chkstatusAlertpass
            }else{
                chkimgSpot.image = chkstatusAlert
            }
        } 
    }
}
