//
//  StackViewsFactory.swift
//  Shelter
//
//  Created by Александра Сергеева on 23.07.2024.
//

import UIKit

final class StackViewsFactory {
    static func createStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
