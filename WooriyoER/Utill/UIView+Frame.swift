//
//  UIView+Frame.swift
//  PinPle
//
//  Created by seob on 2020/02/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

extension UIView
{
    /// 해당 UIView의 frame size중 width를 리턴한다
    ///
    /// - returns: frame.size.width value
    func widthSizeOfFrame() -> CGFloat
    {
        return self.frame.size.width
    }
    
    /// 해당 UIView의 frame size중 height를 리턴한다
    ///
    /// - returns: frame.size.height value
    func heightSizeOfFrame() -> CGFloat
    {
        return self.frame.size.height
    }
    
    /// 해당 UIView의 frame position중 y를 리턴한다
    ///
    /// - returns: frame.origin.y value
    func yPositionOfFrame() -> CGFloat
    {
        return self.frame.origin.y
    }
    
    /// 해당 UIView의 frame position중 x를 리턴한다
    ///
    /// - returns: frame.origin.x value
    func xPositionOfFrame() -> CGFloat
    {
        return self.frame.origin.x
    }
    
    /// 해당 UIView의 frame의 x,y값을 변경한다
    ///
    /// - parameter x: 변경할 x좌표
    /// - parameter y: 변경할 y좌표
    func resetXYPositionOfFrame(_ x: CGFloat, y: CGFloat)
    {
        self.frame = CGRect(x: x, y: y, width: self.widthSizeOfFrame(), height: self.heightSizeOfFrame())
    }
    
    /// 해당 UIView의 frame의 x값을 변경한다
    ///
    /// - parameter x: 변경할 x좌표
    func resetXPositionOfFrame(_ x: CGFloat)
    {
        self.frame = CGRect(x: x, y: self.yPositionOfFrame(), width: self.widthSizeOfFrame(), height: self.heightSizeOfFrame())
    }
    
    /// 해당 UIView의 frame의 y값을 변경한다
    ///
    /// - parameter y: 변경할 y좌표
    func resetYPositionOfFrame(_ y: CGFloat)
    {
        self.frame = CGRect(x: self.xPositionOfFrame(), y: y, width: self.widthSizeOfFrame(), height: self.heightSizeOfFrame())
    }
    
    /// 해당 UIView의 frame의 width, height값을 변경한다
    ///
    /// - parameter width: 변경할 width
    /// - parameter height: 변경할 height
    func resizeOfFrame(_ width:CGFloat, height:CGFloat)
    {
        self.frame = CGRect(x: self.xPositionOfFrame(), y: self.yPositionOfFrame(), width: width, height: height)
    }
    
    /// 해당 UIView의 frame의 width값을 변경한다
    ///
    /// - parameter width: 변경할 width
    func resizeWidthOfFrame(_ width:CGFloat)
    {
        self.frame = CGRect(x: self.xPositionOfFrame(), y: self.yPositionOfFrame(), width: width, height: self.heightSizeOfFrame())
    }
    
    /// 해당 UIView의 frame의 height값을 변경한다
    ///
    /// - parameter height: 변경할 height
    func resizeHeightOfFrame(_ height:CGFloat)
    {
        self.frame = CGRect(x: self.xPositionOfFrame(), y: self.yPositionOfFrame(), width: self.widthSizeOfFrame(), height: height)
    }
}

// MARK: convert view to pdf
/**
 사용예제 : let pdfFilePath = self.view.exportAsPdfFromView()
 */
extension UIView {
    
    // Export pdf from Save pdf in drectory and return pdf file path
    func exportAsPdfFromView() -> Data {

        let pdfPageFrame = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return Data() }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return pdfData as Data

    }
     
    
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
    
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
    
    /// Create image snapshot of view.
    func snapshot(of rect: CGRect? = nil) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
    
    //view to image convert
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
    
    
    func setGestureRecognizer<Gesture: UIGestureRecognizer>(of type: Gesture.Type, target: Any, actionSelector: Selector, swipeDirection: UISwipeGestureRecognizer.Direction? = nil, numOfTaps: Int = 1) {
        let getRecognizer = type.init(target: target, action: actionSelector)
        
        switch getRecognizer {
        case let swipeGesture as UISwipeGestureRecognizer:
            guard let direction = swipeDirection else { return }
            swipeGesture.direction = direction
            self.addGestureRecognizer(swipeGesture)
        case let tapGesture as UITapGestureRecognizer:
            tapGesture.numberOfTapsRequired = numOfTaps
            self.addGestureRecognizer(tapGesture)
        default:
            self.addGestureRecognizer(getRecognizer)
        }
    }
    
    //점선 뷰
    func addDashedBorder() {
          //Create a CAShapeLayer
          let shapeLayer = CAShapeLayer()
          shapeLayer.strokeColor = UIColor.red.cgColor
          shapeLayer.lineWidth = 2
          // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
          shapeLayer.lineDashPattern = [2,3]

          let path = CGMutablePath()
          path.addLines(between: [CGPoint(x: 0, y: 0),
                                  CGPoint(x: self.frame.width, y: 0)])
          shapeLayer.path = path
          layer.addSublayer(shapeLayer)
      }
}

extension UIView {
    func loadView(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    var mainView: UIView? {
        return subviews.first
    }
}
