//
//  CustomToolBar.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/29.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation

extension UIViewController {
    
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
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
        
    }
    
    func addToolBarTextFieldEffects(textFields: [TextFieldEffects]) {
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
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
        
    } 
    
    func dateToolBar(textFields: [UITextField]) {
        for (index, textField) in textFields.enumerated() {
            var toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
            
            let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(UIView.endEditing))
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIView.endEditing))
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
            label.text = "Choose your Date"
            let labelButton = UIBarButtonItem(customView:label)
            
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            toolbar.setItems([todayButton,flexibleSpace,labelButton,flexibleSpace,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    
    
    func addToolBar(textFields: [UITextField], textView: UITextView) {
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
                nextButton.target = textView
                nextButton.action = #selector(textView.becomeFirstResponder)
                
            } else {
                nextButton.target = textFields[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
            }
            
            items.append(contentsOf: [previousButton, nextButton])
            
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var items = [UIBarButtonItem]()
        
        let previousButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_previous"), style: .plain, target: nil, action: nil)
        previousButton.width = 50
        
        previousButton.target = textFields.last
        previousButton.action = #selector(UITextField.becomeFirstResponder)
        
        
        let nextButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_next"), style: .plain, target: nil, action: nil)
        nextButton.width = 50
        nextButton.isEnabled = false
        
        items.append(contentsOf: [previousButton, nextButton])
        
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
        items.append(contentsOf: [spacer, doneButton])
        
        
        toolbar.setItems(items, animated: false)
        textView.inputAccessoryView = toolbar
        
    }
    
    func addToolBarTextFieldEffects(textFields: [TextFieldEffects], textView: UITextView) {
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
                nextButton.target = textView
                nextButton.action = #selector(textView.becomeFirstResponder)
                
            } else {
                nextButton.target = textFields[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
            }
            
            items.append(contentsOf: [previousButton, nextButton])
            
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var items = [UIBarButtonItem]()
        
        let previousButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_previous"), style: .plain, target: nil, action: nil)
        previousButton.width = 50
        
        previousButton.target = textFields.last
        previousButton.action = #selector(UITextField.becomeFirstResponder)
        
        
        let nextButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_next"), style: .plain, target: nil, action: nil)
        nextButton.width = 50
        nextButton.isEnabled = false
        
        items.append(contentsOf: [previousButton, nextButton])
        
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
        items.append(contentsOf: [spacer, doneButton])
        
        
        toolbar.setItems(items, animated: false)
        textView.inputAccessoryView = toolbar
        
    }
    
    func addToolBar(textViews: [UITextView]) {
        for (index, textView) in textViews.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            
            let previousButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_previous"), style: .plain, target: nil, action: nil)
            previousButton.width = 50
            
            if textView == textViews.first {
                previousButton.isEnabled = false
            } else {
                previousButton.target = textViews[index - 1]
                previousButton.action = #selector(UITextField.becomeFirstResponder)
            }
            
            let nextButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_next"), style: .plain, target: nil, action: nil)
            nextButton.width = 50
            
            if textView == textViews.last {
                nextButton.target = textView
                nextButton.action = #selector(textView.becomeFirstResponder)
                
            } else {
                nextButton.target = textViews[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
            }
            
            items.append(contentsOf: [previousButton, nextButton])
            
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textView.inputAccessoryView = toolbar
        }
        
    }
    
    
    
    func addToolBar(textView: UITextView) {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var items = [UIBarButtonItem]()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
        items.append(contentsOf: [spacer, doneButton])
        
        toolbar.setItems(items, animated: false)
        textView.inputAccessoryView = toolbar
    }
    
    // AwesomeTextField
    func addAwesomToolBar(textFields: [AwesomeTextField]) {
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
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
        
    }
}

extension UITableViewCell {
    func addToolBar(textView: UITextView) {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var items = [UIBarButtonItem]()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIView.endEditing))
        items.append(contentsOf: [spacer, doneButton])
        
        toolbar.setItems(items, animated: false)
        textView.inputAccessoryView = toolbar
    }
}
