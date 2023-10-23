//
//  Breeds.swift
//  Shelter
//
//  Created by Александра Сергеева on 23.10.2023.
//

import Foundation

class Breeds {
    static let shared = Breeds()
    
    private init() {}
    
    let breeds = ["German Shepherd","Basset Hound","Dachshund","Beagle","Akita", "Dalmatian"]
}
