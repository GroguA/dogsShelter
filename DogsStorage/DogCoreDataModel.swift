//
//  DogCoreDataModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import Foundation

class DogCoreDataModel {
    let name: String
    let breed: String
    let dateOfBirth: String
    
    init(name: String, breed: String, dateOfBirth: String) {
        self.name = name
        self.breed = breed
        self.dateOfBirth = dateOfBirth
    }
}
