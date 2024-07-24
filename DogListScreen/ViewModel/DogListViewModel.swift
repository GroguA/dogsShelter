//
//  DogListViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.09.2023.
//

import Foundation

protocol IDogListViewModel {
    var viewStateDidChange: (DogListState) -> () { get set }
    func loadSavedDogs()
    func searchDogByName(_ name: String)
    func disableSearch()
    func onFilterSelected(_ filter: DogFiltersModel)
    func onResetFilterTapped()
}

protocol IDogListNavigation {
    func navigateToAddNewDogScreen()
    func navigateToDogFiltersScreen(onDogFiltersSelected: @escaping ((_ filter: DogFiltersModel) -> Void))
    func navigateToDogDetailsScreen(with dogId: String)
    func navigateToNotificationListScreen()
}

final class DogListViewModel {
    var viewStateDidChange: (DogListState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    private var currentState: DogListState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    private let router: DogListRouter
    
    private var dogsBeforeSearch: [DogListDogModel] = []
    private var isFiltering: Bool = false
    private let dogStorageService = DogStorageService.shared
    
    init(router: DogListRouter) {
        self.router = router
    }
}

extension DogListViewModel: IDogListViewModel {
    func loadSavedDogs() {
        if isFiltering {
            return
        }
        
        let savedDogs = dogStorageService.fetchSavedDogs()
        
        if !savedDogs.isEmpty {
            let displayedDogs = savedDogs.map({ dogCoreData in
                let dogAge = DateUtils.shared.getDogAgeInYears(dateOfBirth: dogCoreData.dateOfBirth)
                let dog = DogListDogModel(
                    name: dogCoreData.name,
                    breed: dogCoreData.breed,
                    age: dogAge,
                    image: dogCoreData.image,
                    id: dogCoreData.id
                )
                return dog
            })
            dogsBeforeSearch = displayedDogs
            currentState = .success(dogs: displayedDogs, isFiltering: isFiltering)
        } else {
            currentState = .empty(isFiltering: isFiltering)
        }
    }
    
    func searchDogByName(_ name: String) {
        isFiltering = false
        if name.isEmpty {
            currentState = .empty(isFiltering: isFiltering)
        } else {
            isFiltering = true
            let filteredDogs = dogsBeforeSearch.filter({ (dog: DogListDogModel) -> Bool in
                return dog.name.lowercased().contains(name.lowercased())
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
    
    func onFilterSelected(_ filter: DogFiltersModel) {
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

extension DogListViewModel: IDogListNavigation {
    func navigateToAddNewDogScreen() {
        router.showAddNewDogScreen()
    }
    
    func navigateToDogFiltersScreen(onDogFiltersSelected: @escaping ((_ filter: DogFiltersModel) -> Void)) {
        router.showDogFiltersScreen(onDogFiltersSelected: onDogFiltersSelected)
    }
    
    func navigateToDogDetailsScreen(with dogId: String) {
        router.showDogDetailsScreen(with: dogId)
    }
    
    func navigateToNotificationListScreen() {
        router.showNotificationListScreen()
    }
}
