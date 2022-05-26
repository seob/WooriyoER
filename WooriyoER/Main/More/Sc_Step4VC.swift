//
//  Sc_Step4VC.swift
//  PinPle
//
//  Created by seob on 2021/11/11.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class Sc_Step4VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    var selInfo : ScEmpInfo = ScEmpInfo()
    var viewflagType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
      
        if selInfo.format == 0 {
            lblNavigationTitle.text = "입사 보안서약서 작성 완료"
            self.lblName.text = "\(selInfo.name)님의 입사 보안서약서"
        }else{
            self.lblName.text = "\(selInfo.name)님의 퇴사 보안서약서"
            lblNavigationTitle.text = "퇴사 보안서약서 작성 완료"
        }
         
        setUi()
    }
    
    func setUi(){
        self.lblPoint.text = "\(CompanyInfo.point)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLCinfo()
    }
     
    
    fileprivate func getLCinfo(){
        NetworkManager.shared().get_SCInfo(LCTSID: selInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                self.selInfo = serverData
 
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    //미리보기
    @IBAction func previewDidTap(_ sender: UIButton) {
        // pdf file 서버에서 생성해서 받아오기 - 2020.07.10
        let vc = SecurtSB.instantiateViewController(withIdentifier: "ScPDFViewerVC") as! ScPDFViewerVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        fileExists = ""
        vc.selInfo = self.selInfo
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_step3VC") as! Sc_step3VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_SendVC") as! Sc_SendVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = selInfo
        self.present(vc, animated: false, completion: nil)
    }

}
