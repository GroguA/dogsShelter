//
//  SelectBreedAction.swift
//  Shelter
//
//  Created by Александра Сергеева on 26.10.2023.
//

import Foundation

enum SelectBreedAction {
    case closeWhileSingleSelectMode(breed: String)
    case closeWhileMultiSelectMode(breeds: [String])
}
