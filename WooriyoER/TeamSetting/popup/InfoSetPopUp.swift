//
//  InfoSetPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/09.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class InfoSetPopUp: UIViewController {
    
    @IBOutlet weak var btnOk: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.backgroundColor = EnterpriseColor.btnColor
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
