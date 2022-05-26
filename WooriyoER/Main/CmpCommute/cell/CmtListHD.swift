//
//  CmtListHD.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/29.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmtListHD: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var lblTname: UILabel!
    @IBOutlet weak var lblTotalCnt: UILabel!
    @IBOutlet weak var lblAnlCnt: UILabel!
    @IBOutlet weak var lblAprCnt: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnNotWork: UIButton!
    @IBOutlet weak var lblNotWork: UILabel!
    
    @IBOutlet weak var btnNotLeaveWork: UIButton!
    @IBOutlet weak var lblNotLeaveWork: UILabel!
    @IBOutlet weak var searchNameTextField: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
     
    var delegate: TextFieldInTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        btnWork.setImage(UIImage(named: "er_btn_square"), for: .selected)
//         btnWork.setImage(UIImage(named: "gray_square"), for: .normal)
//        btnNotWork.setImage(UIImage(named: "er_btn_square"), for: .selected)
//        btnNotWork.setImage(UIImage(named: "gray_square"), for: .normal)
//        btnNotLeaveWork.setImage(UIImage(named: "er_btn_square"), for: .selected)
//        btnNotLeaveWork.setImage(UIImage(named: "gray_square"), for: .normal)
         
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        btnNotLeaveWork.isSelected = false
        
        lblWork.textColor = .init(hexString: "#000000")
        lblNotWork.textColor = .init(hexString: "#CBCBD3")
        lblNotLeaveWork.textColor = .init(hexString: "#CBCBD3")
         
        searchNameTextField.delegate = self
        searchNameTextField.setLeftPaddingPoints(10)
        addToolBar(textFields: [searchNameTextField])
    }
   
    
    func addToolBar(textFields: [UITextField]) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            
            let previousButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_previous"), style: .plain, target: nil, action: nil)
            previousButton.width = 50
            
            if textField == textFields.first {
                previousButton.isEnabled = false
            } else {
                previousButton.target = textFields[index - 1]
                previousButton.action = #selector(UITextField.becomeFirstResponder)
            }
            
            let nextButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_next"), style: .plain, target: nil, action: nil)
            nextButton.width = 50
            if textField == textFields.last {
                nextButton.isEnabled = false
            } else {
                nextButton.target = textFields[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
            }
            items.append(contentsOf: [previousButton, nextButton])
            
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onShow(_ sender: UIButton) {
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        btnNotLeaveWork.isSelected = false
        
        btnWork.backgroundColor = UIColor.init(hexString: "#FCCA00")
        btnNotWork.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        btnNotLeaveWork.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        
        lblWork.textColor = .init(hexString: "#000000")
        lblNotWork.textColor = .init(hexString: "#CBCBD3")
        lblNotLeaveWork.textColor = .init(hexString: "#CBCBD3")
    }
    @IBAction func offShow(_ sender: UIButton) {
        btnWork.isSelected = false
        btnNotWork.isSelected = true
        btnNotLeaveWork.isSelected = false
        
        btnWork.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        btnNotWork.backgroundColor = UIColor.init(hexString: "#FCCA00")
        btnNotLeaveWork.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        
        lblWork.textColor = .init(hexString: "#CBCBD3")
        lblNotWork.textColor = .init(hexString: "#000000")
        lblNotLeaveWork.textColor = .init(hexString: "#CBCBD3")
    }
    
    @IBAction func leaveShow(_ sender: UIButton) {
        btnWork.isSelected = false
        btnNotWork.isSelected = false
        btnNotLeaveWork.isSelected = true
        
        btnWork.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        btnNotWork.backgroundColor = UIColor.init(hexString: "#F7F7FA")
        btnNotLeaveWork.backgroundColor = UIColor.init(hexString: "#FCCA00")
        
        lblWork.textColor = .init(hexString: "#CBCBD3")
        lblNotWork.textColor = .init(hexString: "#CBCBD3")
        lblNotLeaveWork.textColor = .init(hexString: "#000000")
    }
     
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\n---------- [ textFieldDidBeginEditing ] ----------\n")
        if let text = textField.text {
            delegate?.textFieldInTableViewCell(cell: self, editingChangedInTextField: text)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
     
}
 

extension CmtListHD {
    func didSelectCell() {
        searchNameTextField.becomeFirstResponder()
        delegate?.textFieldInTableViewCell(didSelect: self)
    }

    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text {
            delegate?.textFieldInTableViewCell(cell: self, editingChangedInTextField: text)
        }
    }
}
