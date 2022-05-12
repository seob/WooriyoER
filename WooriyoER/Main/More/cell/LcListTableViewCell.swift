//
//  LcListTableViewCell.swift
//  PinPle
//
//  Created by seob on 2020/06/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class LcListTableViewCell: UITableViewCell {
    @IBOutlet weak var btnSel: UIButton!
    @IBOutlet weak var SealimageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
