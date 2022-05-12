//
//  Spinner.swift
//  alpha_admin
//
//  Created by WRY_010 on 19/08/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//  개발자 : 오대산
//  로딩 인디케이터
//

import UIKit


open class Spinner {
    
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .whiteLarge
    public static var baseBackColor = UIColor.gray
    public static var baseColor = UIColor.white
    
    public static func start() {
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let style: UIActivityIndicatorView.Style = .whiteLarge
            let backColor: UIColor = .init(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
            let baseColor: UIColor = .white
            let frame = UIScreen.main.bounds
            
            
            
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = backColor
            spinner!.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            window.bringSubviewToFront(spinner!)
            spinner!.startAnimating()
        }
    }
    
    public static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
    
    @objc public static func update() {
        if spinner != nil {
            stop()
            start()
        }
    }
}

