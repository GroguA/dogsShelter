//
//  ShelterViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.09.2023.
//

import Foundation

class ShelterViewModel {
    
    var viewStateDidChange: (ShelterState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    private var currentState: ShelterState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    func loadSavedDogs() {
        let savedDogs = DogStorageService.shared.fetchSavedDogs()
        var displayedDogs = [DogModel]()
        savedDogs.forEach({ dog in
            let dogAge = getAge(dateOfBirth: dog.dateOfBirth)
            let dog = DogModel(name: dog.name, breed: dog.breed, age: String(dogAge))
            displayedDogs.append(dog)
        })
        currentState = .success(dogs: displayedDogs)
    }
    
    func getAge(dateOfBirth: String) -> Int {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd.MM.yyyy"
       guard let dateOfBirth = dateFormatter.date(from: dateOfBirth) else {
           return 0
       }
       let calendar = Calendar.current
       let currentDate = Date()
       let currentYear = calendar.component(.year, from: currentDate)
       
       let birthYear = calendar.component(.year, from: dateOfBirth)

       let age = currentYear - birthYear
       
       return age
       
   }
}
