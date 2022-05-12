//
//  WatermarkePage.swift
//  PinPle
//
//  Created by seob on 2020/06/27.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import PDFKit

class WatermarkePage: PDFPage {
    override func draw(with box: PDFDisplayBox, to context: CGContext) {
//        let maskImage = CGImage?.self
        // Draw original content
        super.draw(with: box, to: context)

        // Draw rotated overlay string
        UIGraphicsPushContext(context)
        context.saveGState()
//
        let pageBounds = self.bounds(for: box)
        context.translateBy(x: 0.0, y: pageBounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.rotate(by: CGFloat.pi / 4.0)

        let string: NSString = "P R E V I E W"
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.rgbalpha(r: 22, g: 29, b: 74, alpha: 0.3) ,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 64)
        ]

        string.draw(at: CGPoint(x: 350, y: 40), withAttributes: attributes)

        context.restoreGState()
        UIGraphicsPopContext()
        
//        let image = UIImage(named: "img_lc_preview")
//        guard let cgImage = image?.cgImage else { return }
//        context.draw(cgImage, in: pageBounds)
//        context.restoreGState()
//        UIGraphicsPopContext()
    }
}
