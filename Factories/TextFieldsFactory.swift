//
//  TextFieldsFactory.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

final class TextFieldsFactory {
    static func createTextField(with placeholder: String?) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = .default
        textField.autocapitalizationType = .words
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
