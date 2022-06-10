//
//  CmtLtCpopVC.swift
//  PinPle
//
//  Created by seob on 2022/01/13.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class CmtLtCpopVC: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        btnOk.backgroundColor = EnterpriseColor.btnColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func btnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
