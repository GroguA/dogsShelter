//
//  StackViewsFactory.swift
//  Shelter
//
//  Created by Александра Сергеева on 23.07.2024.
//

import UIKit

struct StackViewsFactory {
    enum StackViewAxis {
        case vertical
        case horizontal
    }
    
    static func createStackView(axis: StackViewAxis) -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        switch axis {
        case .vertical:
            view.axis = .vertical
            view.spacing = 16
            view.distribution = .equalSpacing
        case .horizontal:
            view.axis = .horizontal
            view.alignment = .leading
            view.distribution = .fillProportionally
        }
        return view
    }
}
