//
//  SubTemSetCell.swift
//  PinPle
//
//  Created by WRY_010 on 2020/02/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SubTemSetCell: UITableViewCell {

    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnCell.setImage(UIImage.init(named: "er_checkbox"), for: .selected)
        btnCell.setImage(UIImage.init(named: "icon_nonecheck"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
