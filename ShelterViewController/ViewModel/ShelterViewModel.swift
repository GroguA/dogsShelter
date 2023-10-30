//
//  ShelterViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.09.2023.
//

import Foundation

class ShelterViewModel {
    
    var isFiltering = false
    
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
            currentState = .success(dogs: displayedDogs)
        } else {
            currentState = .empty
        }
    }
    
    func dogSearchByName(searchText: String, category: DogModel? = nil) {
        if searchText.isEmpty {
            currentState = .success(dogs: dogsBeforeSearch)
        } else {
            let filteredDogs = dogsBeforeSearch.filter({ (dog: DogModel) -> Bool in
                return dog.name.lowercased().contains(searchText.lowercased())
            })
            currentState = .success(dogs: filteredDogs)
        }
    }
    
    func disableSearch() {
        currentState = .success(dogs: dogsBeforeSearch)
    }
    
    func showFilteredDogsByBreed(breeds: [String]) {
        let dogs = dogsBeforeSearch.filter({ dog in
            return breeds.contains(where: { dogBreed in
                dog.breed == dogBreed
            })
        })
        currentState = .success(dogs: dogs)
        isFiltering = true
    }
    
    func onResetFilterTapped() {
        isFiltering = false
        currentState = .success(dogs: dogsBeforeSearch)
    }
}
