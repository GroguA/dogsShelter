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
    let dateOfWash: String?
    
    init(name: String, breed: String, dateOfBirth: String, image: Data, id: String, dateOfWash: String?) {
        self.name = name
        self.breed = breed
        self.dateOfBirth = dateOfBirth
        self.image = image
        self.id = id
        self.dateOfWash = dateOfWash
    }
}
