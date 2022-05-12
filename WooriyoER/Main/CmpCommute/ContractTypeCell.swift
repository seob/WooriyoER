//
//  ContractTypeCell.swift
//  PinPle
//
//  Created by seob on 2020/06/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ContractTypeCell: UITableViewCell {

    @IBOutlet weak var chkImg: UIImageView!
    @IBOutlet weak var checkedBtn: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var subscribeButtonAction : (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    } 
}
