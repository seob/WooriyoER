//
//  TotalEmpListCell.swift
//  PinPle
//
//  Created by seob on 2020/02/18.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TotalEmpListCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemName: UILabel!
    @IBOutlet weak var btnApr: UIButton!
    @IBOutlet weak var lblBtnType: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgBtn: UIImageView!
    @IBOutlet weak var lblremain: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.makeRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
