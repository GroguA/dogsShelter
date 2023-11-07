//
//  FilterForDogs.swift
//  Shelter
//
//  Created by Александра Сергеева on 31.10.2023.
//

import Foundation

class FilterForDogs {
    let breeds: [String]?
    let age: String?
    
    init(breeds: [String]?, age: String?) {
        self.breeds = breeds
        self.age = age
    }
}
