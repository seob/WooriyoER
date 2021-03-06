//
//  Ce_Step3VC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Ce_Step3VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    var selInfo : Ce_empInfo = Ce_empInfo()
    var viewflagType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnNext)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        setUi()
    }
    
    func setUi(){
        selInfo = Sel_CeEmpInfo
        if selInfo.format == 0  {
            lblName.text = "\(self.selInfo.name)님의 재직증명서"
            
        }else{
            lblName.text = "\(selInfo.name)님의 경력증명서"
        }
        lblPoint.text = "\(CompanyInfo.point)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
      
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_Step2VC") as! Ce_Step2VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = Sel_CeEmpInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_SendVC") as! Ce_SendVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = Sel_CeEmpInfo
        self.present(vc, animated: false, completion: nil)
    }

}
