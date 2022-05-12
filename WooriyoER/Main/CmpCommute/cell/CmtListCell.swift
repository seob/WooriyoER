//
//  CmtOnCell.swift
//  PinPle
//
//  Created by WRY_010 on 11/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmtListCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var vwCmtEmp: UIView!
    @IBOutlet weak var vwCmtOn: UIView!
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var lblCmtEmp: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.clear.cgColor
        imgProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
