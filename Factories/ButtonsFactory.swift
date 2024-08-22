//
//  ButtonsFactory.swift
//  Shelter
//
//  Created by Александра Сергеева on 24.07.2024.
//

import UIKit

struct ButtonsFactory {
    static func createButton(with text: String?, isTitleBold: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle(text, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: isTitleBold ? .semibold : .regular)
        return button
    }
}
