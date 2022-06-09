//
//  TemAnlSet.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TemAnlSet: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var selSid = 0
    var selFlag = false
    var selName = ""
    var anuallimit = 0
    
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("<<<<<<<----------------------[TemAnlSet : 팀 연차 인원 설정]---------------------->>>>>>>>")
        EnterpriseColor.nonLblBtn(btnSave)
        selSid = prefs.value(forKey: "mt_selsid") as? Int ?? 0
        selFlag = prefs.value(forKey: "mt_selflag") as! Bool
        selName = prefs.value(forKey: "mt_name") as? String ?? ""
        anuallimit = prefs.value(forKey: "mt_anuallimit") as? Int ?? 0
        
        lblTeamName.text = selName
        txtField.text = String(anuallimit)
        addToolBar(textFields: [txtField])
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀 연차제한 설정)
         Return  - 성공:1, 실패:0
         Parameter
         TEMSID(TEMSID)        상위팀번호(팀번호)
         LIMIT        제한직원 수
         */
        
        let limit = Int(txtField.text ?? "")
        if selFlag {
            type = 1 // 상위팀 연차제한 설정
        }else {
            type = 2 // 팀 연차제한 설정
        }
        
        NetworkManager.shared().SetTtmAnualLimit(type: type, ttmsid: selSid, limit: limit ?? 0) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                     let vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlAprSetVC") as! AnlAprSetVC
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
