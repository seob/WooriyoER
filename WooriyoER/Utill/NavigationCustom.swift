//
//  NavigationCustom.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func navigationCustom() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false 
    }
}
 
