//
//  MulticmtTableViewCell.swift
//  PinPle
//
//  Created by seob on 2021/02/17.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class MulticmtTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var wifiImageView: UIImageView!
    @IBOutlet weak var cmtSwitch: UIButton!
    @IBOutlet weak var btnSelected: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    } 
    
    @IBAction func changecmtStatus(_ sender: UISwitch) {
        
    }
}
