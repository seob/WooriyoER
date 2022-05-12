//
//  WeekHourPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class WeekHourPopUp: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  //근로시간 확인
    @IBAction func cmtClick(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MgrCmtVC") as! MgrCmtVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    //메세지 보내기
    @IBAction func msgClick(_ sender: UIButton) {
       
        let vc = MoreSB.instantiateViewController(withIdentifier: "WaringMsgVC") as! WaringMsgVC        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
       
    }
    @IBAction func popClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
