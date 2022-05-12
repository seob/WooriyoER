//
//  CustomView.swift
//  PinPle
//
//  Created by WRY_010 on 14/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//  개발자 : 오대산
//  view 라운드 처리

import UIKit

@IBDesignable
class CustomView: UIView {
       
        var shadowLayer: CAShapeLayer!
        //    var cornerRadiusValue : CGFloat = 0
        //    var corners : UIRectCorner = []
        
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
        
        //   // MARK: 부분 라운드 처리
        //    @IBInspectable public var topLeft : Bool {
        //        get {
        //            return corners.contains(.topLeft)
        //        }
        //        set {
        //            setCorner(newValue: newValue, for: .topLeft)
        //        }
        //    }
        //
        //    @IBInspectable public var topRight : Bool {
        //        get {
        //            return corners.contains(.topRight)
        //        }
        //        set {
        //            setCorner(newValue: newValue, for: .topRight)
        //        }
        //    }
        //
        //    @IBInspectable public var bottomLeft : Bool {
        //        get {
        //            return corners.contains(.bottomLeft)
        //        }
        //        set {
        //            setCorner(newValue: newValue, for: .bottomLeft)
        //        }
        //    }
        //
        //    @IBInspectable public var bottomRight : Bool {
        //        get {
        //            return corners.contains(.bottomRight)
        //        }
        //        set {
        //            setCorner(newValue: newValue, for: .bottomRight)
        //        }
        //    }
        //
        //    func setCorner(newValue: Bool, for corner: UIRectCorner) {
        //        if newValue {
        //            addRectCorner(corner: corner)
        //        } else {
        //            removeRectCorner(corner: corner)
        //        }
        //    }
        //
        //    func addRectCorner(corner: UIRectCorner) {
        //        corners.insert(corner)
        //        updateCorners()
        //    }
        //
        //    func removeRectCorner(corner: UIRectCorner) {
        //        if corners.contains(corner) {
        //            corners.remove(corner)
        //            updateCorners()
        //        }
        //    }
        //
        //    func updateCorners() {
        //        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadiusValue, height: cornerRadiusValue))
        //        let mask = CAShapeLayer()
        //        mask.path = path.cgPath
        //        self.layer.mask = mask
        //    }
        //MARK: 그라데이션
        @IBInspectable var startColor:   UIColor = .white { didSet { updateColors() }}
        //    @IBInspectable var centerColor:   UIColor = .white { didSet { updateColors() }}
        @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
        @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
        //    @IBInspectable var centerLocation:   Double =   0.5 { didSet { updateLocations() }}
        @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
        @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
        @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
        
        override public class var layerClass: AnyClass { return CAGradientLayer.self }
        
        var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
        
        func updatePoints() {
            if horizontalMode {
                gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
                gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
            } else {
                gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
                gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
            }
        }
        func updateLocations() {
            //        gradientLayer.locations = [startLocation as NSNumber, centerLocation as NSNumber, endLocation as NSNumber]
            gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
        }
        func updateColors() {
            //        gradientLayer.colors    = [startColor.cgColor, centerColor.cgColor, endColor.cgColor]
            gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
            
        }
        
        //MARK: 그림자
        @IBInspectable var shadowColor:   UIColor = .white { didSet { shadow() }}
        @IBInspectable var shadowWidth:   Double = 0.0 { didSet { shadow() }}
        @IBInspectable var shadowHeight:   Double = 0.0 { didSet { shadow() }}
        @IBInspectable var shadowOpacity:   Float = 0 { didSet { shadow() }}
        @IBInspectable var shadowRadius:   CGFloat = 0.0 { didSet { shadow() }}
        
        func shadow() {
            layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            updatePoints()
            updateLocations()
            updateColors()
            shadow()
        }
        
    }
