//
//  BreedsDataSource.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import Foundation

class BreedsDataSource {
    static let shared = BreedsDataSource()
    
    private var breeds: [String]? = nil
    
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
        guard let breeds else {
            guard let dogs = loadJson(fileName: "breeds") else { return [] }
            let nonOptBreeds = dogs.breeds.map { String($0) }
            self.breeds = nonOptBreeds
            return nonOptBreeds
        }
        return breeds
    }
}
