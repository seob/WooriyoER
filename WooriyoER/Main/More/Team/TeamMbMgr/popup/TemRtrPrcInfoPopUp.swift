//
//  TemRtrPrcInfoPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TemRtrPrcInfoPopUp: UIViewController {
    
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.backgroundColor = EnterpriseColor.btnColor
        btnSave.setTitleColor(EnterpriseColor.lblColor, for: .normal)
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
