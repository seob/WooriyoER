//
//  AprMgrListCell.swift
//  PinPle
//
//  Created by WRY_010 on 01/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpAprMgrListCell: UITableViewCell{
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var imgMgr: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.makeRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
