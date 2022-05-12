//
//  TemEmpListCell.swift
//  PinPle
//
//  Created by WRY_010 on 11/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemEmpListCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEname: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var imgAuth: UIImageView!
    @IBOutlet weak var vwNoEmp: UIView!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.makeRounded()
        vwNoEmp.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
