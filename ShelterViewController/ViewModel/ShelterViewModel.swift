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
    
    private var dogsBeforeSearch: [DogModel] = []
    
    func loadSavedDogs() {
        let savedDogs = DogStorageService.shared.fetchSavedDogs()
        if !savedDogs.isEmpty {
            let displayedDogs = savedDogs.map({ dogCoreData in
                let dogAge = CalculateDogAge.shared.getAge(dateOfBirth: dogCoreData.dateOfBirth)
                let dog = DogModel(name: dogCoreData.name, breed: dogCoreData.breed, age: dogAge, image: dogCoreData.image, id: dogCoreData.id)
                return dog
            })
            dogsBeforeSearch = displayedDogs
            currentState = .success(dogs: displayedDogs, isFiltering: false)
        } else {
            currentState = .empty(isFiltering: false)
        }
    }
    
    func dogSearchByName(searchText: String) {
        if searchText.isEmpty {
            currentState = .empty(isFiltering: false)
        } else {
            let filteredDogs = dogsBeforeSearch.filter({ (dog: DogModel) -> Bool in
                return dog.name.lowercased().contains(searchText.lowercased())
            })
            currentState = .success(dogs: filteredDogs, isFiltering: false)
        }
    }
    
    func disableSearch() {
        if !dogsBeforeSearch.isEmpty {
            currentState = .success(dogs: dogsBeforeSearch, isFiltering: false)
        } else {
            currentState = .empty(isFiltering: false)
        }
    }
    
    func onFilterSelected(filter: FilterForDogs) {
        let filteredDogs = dogsBeforeSearch.filter { dog in
            if let age = filter.age, let breeds = filter.breeds {
                return Int(age) == Int(dog.age) && breeds.contains(where: { breed in
                    breed == dog.breed
                })
            } else if let age = filter.age {
                return Int(age) == Int(dog.age)
            } else if let breeds = filter.breeds {
                return breeds.contains(where: { breed in
                    breed == dog.breed
                })
            }
            return false
        }
        if !filteredDogs.isEmpty {
            currentState = .success(dogs: filteredDogs, isFiltering: true)
        } else {
            currentState = .empty(isFiltering: true)
        }
    }
    
    
    func onResetFilterTapped() {
        currentState = .success(dogs: dogsBeforeSearch, isFiltering: false)
    }
}
