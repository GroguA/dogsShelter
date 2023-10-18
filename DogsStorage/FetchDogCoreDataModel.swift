//
//  DogCoreDataModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import Foundation

class FetchDogCoreDataModel {
    let name: String
    let breed: String
    let dateOfBirth: String
    let image: Data
    let id: String
    
    init(name: String, breed: String, dateOfBirth: String, image: Data, id: String) {
        self.name = name
        self.breed = breed
        self.dateOfBirth = dateOfBirth
        self.image = image
        self.id = id
    }
}
