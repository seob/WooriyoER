//
//  DashedLineView.swift
//  PinPle
//
//  Created by seob on 2020/06/10.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class DashedLineView: UIView {
    
    private let borderLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        borderLayer.strokeColor =  UIColor.init(hexString: "#707070").cgColor
        borderLayer.lineDashPattern = [3,3]
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(borderLayer)
    }
    
    override func draw(_ rect: CGRect) {
        
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
    }
}
