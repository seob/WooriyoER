//
//  CustomTextView.swift
//  PinPle_ER
//
//  Created by WRY_010 on 2019/11/15.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextView: UITextView {
    
    //MARK: 테두리
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    //MARK: 전체 라운드 처리
    @IBInspectable public var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
