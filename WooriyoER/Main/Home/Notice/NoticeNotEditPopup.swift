//
//  NoticeNotEditPopup.swift
//  PinPle
//
//  Created by seob on 2022/02/15.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class NoticeNotEditPopup: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.backgroundColor = EnterpriseColor.btnColor
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
