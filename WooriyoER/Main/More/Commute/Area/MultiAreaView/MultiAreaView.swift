//
//  MultiAreaView.swift
//  PinPle
//
//  Created by seob on 2021/02/17.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class MultiAreaView: UIView {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var areaImageView: UIImageView!
    @IBOutlet weak var areaSwitch: UISwitch!
    @IBOutlet var contView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    
    private func initFromXIB(){
        let bundle = Bundle(for: type(of: self))
        
        let nib = UINib(nibName: "MultiAreaView", bundle: bundle)
        
        contView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        contView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (bounds.width), height: bounds.height))
        
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        
        self.addSubview(contView)
        
        self.backgroundColor = UIColor.clear
        
        contView.layer.masksToBounds = false
    }
    
    
    
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        setup()
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        super.init(coder: coder)
    //        setup()
    //    }
    //
//        private func setupUI() {
//            backgroundColor = .clear
//            guard let view = loadView(nibName: "MultiAreaView") else { return }
//            view.frame = self.bounds
//            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            self.addSubview(view)
//        }
}
