//
//  AnlAprSubTypeCell.swift
//  PinPle
//
//  Created by seob on 2020/04/01.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AnlAprSubTypeCell: UITableViewCell {
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDdctn: UILabel!
    @IBOutlet weak var ddctnButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
