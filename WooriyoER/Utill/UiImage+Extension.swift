//
//  UiImage+Extension.swift
//  PinPle
//
//  Created by seob on 2020/06/17.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation

extension UIImageView {
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    func setImage(with urlString: String) {
        let cache = ImageCache.default
        cache.retrieveImage(forKey: urlString, options: nil) { (image, _) in // 캐시에서 키를 통해 이미지를 가져온다.
            if let image = image { // 만약 캐시에 이미지가 존재한다면
                self.image = image // 바로 이미지를 셋한다.
            } else {
                let url = URL(string: urlString) // 캐시가 없다면
                let resource = ImageResource(downloadURL: url!, cacheKey: urlString) // URL로부터 이미지를 다운받고 String 타입의 URL을 캐시키로 지정하고
                self.kf.setImage(with: resource) // 이미지를 셋한다.
            }
        }
    }
     
    func createPatternImage(blockWidth: CGFloat) -> UIImage {
        
        let patternSize = CGSize(width: blockWidth * 2, height: blockWidth * 2)
        
        let blockSize = CGSize(width: blockWidth, height: blockWidth)
        
        var blockRect = CGRect(origin: .zero, size: blockSize)
        
        let color1 = UIColor.white
        
        let color2 = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        
        UIGraphicsBeginImageContextWithOptions(patternSize, true, UIScreen.main.scale)
        color1.setFill()
        UIRectFill(blockRect)
        
        
        
        blockRect.origin.x += blockWidth
        color2.setFill()
        UIRectFill(blockRect)
        
        
        
        blockRect.origin.x -= blockWidth
        blockRect.origin.y += blockWidth
        color2.setFill()
        UIRectFill(blockRect)
        
        
        
        blockRect.origin.x += blockWidth
        color1.setFill()
        UIRectFill(blockRect)
        
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return image!
    }
}
 
extension UIImage {
    
    func Newresize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func Newscale(image: UIImage, by scale: CGFloat) -> UIImage? {
        let size = image.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIImage.resize(image: image, targetSize: scaledSize)
    }
    
    //비율에 맞게 줄이기
    func imageScalResize(with sourceImage: UIImage?, scaledResize size: Float) -> UIImage? {
        
        //size == 1080
        
        var isWidthLong = false
        
        //이미지가 가로가 더 큰 이미지
        
        if (sourceImage?.size.width ?? 0.0) > (sourceImage?.size.height ?? 0.0) {
            
            if (sourceImage?.size.width ?? 0.0) <= CGFloat(size) {
                return sourceImage //가로가 큰데 1080보다 작거나 같다면 사이즈 조절할 필요가없음.
            }
            
            isWidthLong = true
        } else {
            
            if (sourceImage?.size.height ?? 0.0) <= CGFloat(size) {
                return sourceImage //세로가 큰데 1080보다 작거나 같다면 사이즈 조절 X
            }
            
            isWidthLong = false
        }
        
        if isWidthLong {
            
            let oldWidth = Float(sourceImage?.size.width ?? 0.0)
            
            let scaleFactor = size / oldWidth
            
            
            
            let newHeight = Float((sourceImage?.size.height ?? 0.0) * CGFloat(scaleFactor))
            
            let newWidth = oldWidth * scaleFactor
            
            
            
            UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
            
            sourceImage?.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return newImage
        }
            //세로가 크다면
        else {
            
            let oldWidth = Float(sourceImage?.size.height ?? 0.0)
            
            let scaleFactor = size / oldWidth
            
            
            
            let newHeight = Float((sourceImage?.size.width ?? 0.0) * CGFloat(scaleFactor))
            
            let newWidth = oldWidth * scaleFactor
            
            
            
            UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
            
            sourceImage?.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return newImage
            
        } 
        
        return sourceImage
        
    }
    
    //pdf resize
    func PDFresize(toWidth width: CGFloat) -> UIImage? {
         let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
         return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
             _ in draw(in: CGRect(origin: .zero, size: canvas))
         }
     }
}
 
