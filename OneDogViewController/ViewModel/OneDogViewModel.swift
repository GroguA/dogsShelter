//
//  OneDogViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.10.2023.
//

import Foundation

class OneDogViewModel {
    
    private func getAge(dateOfBirth: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let dateOfBirth = dateFormatter.date(from: dateOfBirth) else {
            return "0"
        }
        let calendar = Calendar.current
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        
        let birthYear = calendar.component(.year, from: dateOfBirth)
        
        let age = currentYear - birthYear
        
        return String(age)
        
    }
    
    func getOneDog(id: String) -> DogModel? {
        let dogs = DogStorageService.shared.fetchSavedDogs()
        let oneCoreDataDog = dogs.first(where: {dog in
            dog.id == id})
        if let nonOptDog = oneCoreDataDog {
            return DogModel(name: nonOptDog.name, breed: nonOptDog.breed, age: getAge(dateOfBirth: nonOptDog.dateOfBirth), image: nonOptDog.image, id: id)
        } else {
            return nil
        }
    }
}
