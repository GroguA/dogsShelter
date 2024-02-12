//
//  DogsListViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.09.2023.
//

import Foundation

class DogsListViewModel {
    
    var viewStateDidChange: (DogsListState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    private var currentState: DogsListState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    private var dogsBeforeSearch: [DogsListDogModel] = []
    
    private var isFiltering: Bool = false
    
    private let dogStorageService = DogStorageService.shared
    
    func loadSavedDogs() {
        if isFiltering {
            return
        }
        
        let savedDogs = dogStorageService.fetchSavedDogs()
        
        if !savedDogs.isEmpty {
            let displayedDogs = savedDogs.map({ dogCoreData in
                let dogAge = DateUtils.shared.getDogAgeInYears(dateOfBirth: dogCoreData.dateOfBirth)
                let dog = DogsListDogModel(name: dogCoreData.name, breed: dogCoreData.breed, age: dogAge, image: dogCoreData.image, id: dogCoreData.id)
                return dog
            })
            dogsBeforeSearch = displayedDogs
            currentState = .success(dogs: displayedDogs, isFiltering: isFiltering)
        } else {
            currentState = .empty(isFiltering: isFiltering)
        }
    }
    
    func searchDogByName(searchText: String) {
        isFiltering = false
        if searchText.isEmpty {
            currentState = .empty(isFiltering: isFiltering)
        } else {
            isFiltering = true
            let filteredDogs = dogsBeforeSearch.filter({ (dog: DogsListDogModel) -> Bool in
                return dog.name.lowercased().contains(searchText.lowercased())
            })
            currentState = .success(dogs: filteredDogs, isFiltering: isFiltering)
        }
    }
    
    func disableSearch() {
        isFiltering = false
        if !dogsBeforeSearch.isEmpty {
            currentState = .success(dogs: dogsBeforeSearch, isFiltering: isFiltering)
        } else {
            currentState = .empty(isFiltering: isFiltering)
        }
    }
    
    func onFilterSelected(filter: DogFiltersModel) {
        isFiltering = true
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
            currentState = .success(dogs: filteredDogs, isFiltering: isFiltering)
        } else {
            currentState = .empty(isFiltering: isFiltering)
        }
    }
    
    
    func onResetFilterTapped() {
        isFiltering = false
        currentState = .success(dogs: dogsBeforeSearch, isFiltering: isFiltering)
    }
}
