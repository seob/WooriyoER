//
//  WaringListCell.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/08.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class WaringListCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTem: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblMaxCmt: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    @IBOutlet weak var lblMin: UILabel!    
    
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
