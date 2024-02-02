//
//  UIViewController.swift
//  FindCoffee
//
//  Created by Anton on 02.02.24.
//

import UIKit

extension UIViewController {
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.mainTextColor
        label.text = text
        return label
    }
    
    func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeholderColor,
            .font: UIFont.systemFont(ofSize: 18)
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        textField.layer.cornerRadius = 20
        textField.layer.borderColor = UIColor.mainTextColor.cgColor
        textField.layer.borderWidth = 2

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }
}

