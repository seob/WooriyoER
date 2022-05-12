//
//  CeEmpListCell.swift
//  PinPle
//
//  Created by seob on 2020/08/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class CeEmpListCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemName: UILabel!
    @IBOutlet weak var btnApr: UIButton!
    @IBOutlet weak var imgBtn: UIImageView!
    @IBOutlet weak var statusView: CustomView!
    
    @IBOutlet weak var lblleave: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.makeRounded()
        self.lblleave.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
