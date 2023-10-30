//
//  BreedsList.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import Foundation

class BreedsList {
    static let shared = BreedsList()
    
    private init() {}
    
    let breeds = ["German Shepherd","Basset Hound","Dachshund","Beagle","Akita", "Dalmatian"]

}
