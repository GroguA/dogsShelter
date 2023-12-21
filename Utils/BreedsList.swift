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
    
    private func loadJson(fileName: String) -> BreedDataModel? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(BreedDataModel.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
        
    func getBreeds() -> [String] {
        guard let dogs = loadJson(fileName: "breeds") else { return [] }
        return dogs.breeds.map { String($0) }
    }
}
