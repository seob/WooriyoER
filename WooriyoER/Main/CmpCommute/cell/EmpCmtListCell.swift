//
//  EmpCmtListCell.swift
//  PinPle
//
//  Created by WRY_010 on 14/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class EmpCmtListCell: UITableViewCell {

    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var lblWorkMin: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblend: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var vwTime: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    } 
}
