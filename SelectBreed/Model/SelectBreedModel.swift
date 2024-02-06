//
//  SelectBreed.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.12.2023.
//

import Foundation

class SelectBreedModel {
    let breed: String
    var isSelected: Bool
    
    init(breed: String, isSelected: Bool) {
        self.breed = breed
        self.isSelected = isSelected
    }
}
