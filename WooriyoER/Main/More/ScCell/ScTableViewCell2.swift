//
//  ScTableViewCell2.swift
//  PinPle
//
//  Created by seob on 2021/11/16.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate2:class {
    func updateTextViewHeight2(_ cell:ScTableViewCell2,_ textView:UITextView)
}

class ScTableViewCell2: UITableViewCell {
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    weak var delegate: TableViewCellDelegate2?
    private var placeholderLabel1 = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextView.layer.cornerRadius = 6
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.init(hexString: "#EDEDF2").cgColor
        addToolBar(textView: contentTextView)
        setTextView()
    }
    
    func setTextView() {
        contentTextView.delegate = self
        contentTextView.isScrollEnabled = false
        contentTextView.sizeToFit()
        placeholderSetting()
    }
    
    func placeholderSetting() {
        placeholderLabel1.text = "조항 내용을 입력하세요."
        placeholderLabel1.font = UIFont.systemFont(ofSize: contentTextView.font!.pointSize)
        placeholderLabel1.sizeToFit()
        placeholderLabel1.frame.origin = CGPoint(x: 5, y: contentTextView.font!.pointSize / 2)
        placeholderLabel1.textColor = UIColor.lightGray
        placeholderLabel1.isHidden = !contentTextView.text.isEmpty
        contentTextView.addSubview(placeholderLabel1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}


extension ScTableViewCell2:UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            delegate.updateTextViewHeight2(self, textView)
        }
    }
     
}
