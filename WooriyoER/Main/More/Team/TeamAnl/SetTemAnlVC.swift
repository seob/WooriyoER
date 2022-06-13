//
//  SetTemAnlVC.swift
//  PinPle
//
//  Created by WRY_010 on 30/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class SetTemAnlVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    
    var anuallimit = 0
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnSave)
        txtField.delegate = self
        addToolBar(textFields: [txtField])
        
        
        anuallimit = SelTemInfo.anuallimit
        
        lblTeamName.text = SelTemInfo.name
        txtField.text = "\(anuallimit)"
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
//        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false, completion: nil)
        NotificationCenter.default.post(name: .reloadTem, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀 연차제한 설정)
         Return  - 성공:1, 실패:0
         Parameter
         TEMSID(TEMSID)        상위팀번호(팀번호)
         LIMIT        제한직원 수
         */
        let limit = Int(txtField.text ?? "0")
        NetworkManager.shared().SetTemAnualLimit(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid, limit: limit ?? 0) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
//                    self.toast("정상 처리 되었습니다.")
//                    let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.modalPresentationStyle = .overFullScreen
//                    self.present(vc, animated: false, completion: nil)
                    NotificationCenter.default.post(name: .reloadTem, object: nil)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
}
