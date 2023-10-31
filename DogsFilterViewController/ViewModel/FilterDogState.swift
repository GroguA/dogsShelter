//
//  FilterDogState.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.10.2023.
//

import Foundation

enum FilterDogState {
    case breedFilter(breeds: [String])
    case ageFilter(age: String)
}
