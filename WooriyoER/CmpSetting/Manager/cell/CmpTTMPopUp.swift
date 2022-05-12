//
//  CmpTTMPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 11/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//
import UIKit

class CmpTTMPopUp: UITableViewCell{
 

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var txtInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profile.layer.cornerRadius = profile.frame.height/2
        profile.layer.borderWidth = 1
        profile.layer.borderColor = UIColor.clear.cgColor
        profile.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
