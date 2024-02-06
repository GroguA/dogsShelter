//
//  BreedsDataModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 07.11.2023.
//

import Foundation

struct BreedDataModel: Codable {
    let breeds: [String]
    
    enum CodingKeys: String, CodingKey {
        case breeds = "dogs"
    }
}

