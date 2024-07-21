//
//  LabelsFactory.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

final class LabelsFactory {
    static func createLabel(with text: String? = nil, isTextBold: Bool = false, textSize: CGFloat = 19) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: textSize, weight: isTextBold ? .semibold : .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }
}
