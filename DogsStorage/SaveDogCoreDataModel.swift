//
//  SaveDogCoreDataModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.10.2023.
//

import Foundation

class SaveDogCoreDataModel {
    let name: String
    let breed: String
    let dateOfBirth: String
    let image: Data
    
    init(name: String, breed: String, dateOfBirth: String, image: Data) {
        self.name = name
        self.breed = breed
        self.dateOfBirth = dateOfBirth
        self.image = image
    }
}
