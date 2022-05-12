//
//  CmtListHD.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/29.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmtListHD: UITableViewCell {
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var lblTotalCnt: UILabel!
    @IBOutlet weak var lblAnlCnt: UILabel!
    @IBOutlet weak var lblAprCnt: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnNotWork: UIButton!
    @IBOutlet weak var lblNotWork: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        btnWork.setImage(UIImage(named: "er_btn_square"), for: .selected)
//        btnWork.setImage(UIImage(named: "gray_square"), for: .normal)
//        btnNotWork.setImage(UIImage(named: "er_btn_square"), for: .selected)
//        btnNotWork.setImage(UIImage(named: "gray_square"), for: .normal)
        
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        
        lblWork.textColor = .init(hexString: "#000000")
        lblNotWork.textColor = .init(hexString: "#CBCBD3")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onShow(_ sender: UIButton) {
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        
        lblWork.textColor = .init(hexString: "#000000")
        lblNotWork.textColor = .init(hexString: "#CBCBD3")
        btnWork.backgroundColor = .init(hexString: "#FCCA00")
        btnNotWork.backgroundColor = .init(hexString: "#F7F7FA")
    }
    @IBAction func offShow(_ sender: UIButton) {
        btnWork.isSelected = false
        btnNotWork.isSelected = true
        
        lblWork.textColor = .init(hexString: "#CBCBD3")
        lblNotWork.textColor = .init(hexString: "#000000")
        btnWork.backgroundColor = .init(hexString: "#F7F7FA")
        btnNotWork.backgroundColor = .init(hexString: "#FCCA00")
    }
    
}
