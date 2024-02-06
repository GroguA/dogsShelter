//
//  DogsListModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 06.10.2023.
//

import Foundation

class DogsListModel {
    let name: String
    let breed: String
    let age: String
    let image: Data
    let id: String
    
    init(name: String, breed: String, age: String, image: Data, id: String) {
        self.name = name
        self.breed = breed
        self.age = age
        self.image = image
        self.id = id
    }

}
