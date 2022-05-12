//
//  CodeListCell.swift
//  PinPle
//
//  Created by WRY_010 on 26/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//


import UIKit

class CodeListCell: UITableViewCell{
    
    @IBOutlet weak var lblCmpNM: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // se 때 다시 적용
//        lblCmpNM.adjustsFontSizeToFitWidth = true
//        lblCode.adjustsFontSizeToFitWidth = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
