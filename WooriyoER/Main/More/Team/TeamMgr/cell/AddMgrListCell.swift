//
//  AddMgrListCell.swift
//  PinPle
//
//  Created by WRY_010 on 30/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AddMgrListCell: UITableViewCell{
  
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblEname: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    
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
    }
   
}
