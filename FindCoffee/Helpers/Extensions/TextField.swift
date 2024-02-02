//
//  TextFieldEmailCheck.swift
//  FindCoffee
//
//  Created by Anton on 02.02.24.
//

import Foundation
import UIKit

extension UITextField {
    var isEmailValid: Bool {
        guard let text = self.text else { return false }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: text)
    }
}
