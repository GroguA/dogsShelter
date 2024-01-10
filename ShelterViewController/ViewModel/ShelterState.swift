//
//  ShelterState.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.09.2023.
//

import Foundation

enum ShelterState {
    case success(dogs: [ShelterDogModel], isFiltering: Bool)
    case empty(isFiltering: Bool)
}
