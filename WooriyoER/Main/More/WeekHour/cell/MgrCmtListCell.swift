//
//  MgrCmtListCell.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/08.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class MgrCmtListCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWorkMin: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblDate.adjustsFontSizeToFitWidth = true
        lblWorkMin.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
