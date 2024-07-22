//
//  DogFiltersViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.10.2023.
//

import Foundation

protocol IDogFiltersViewModel {
    var viewStateDidChange: (DogFiltersState) -> () { get set }
    var onAction: (DogFiltersAction) -> () { get set }
    func onApplyButtonTapped()
    func onAgeFilterChanged(age: String)
    func onBreedFilterChanged(breeds: [String])
    func deselectAgeFilterTapped()
    func deselectBreedFilterTapped()
}

protocol IDogFiltersNavigation {
    func showSelectBreedScreen(doOnMultiSelect: @escaping ([String]) -> Void)
    func popDogFiltersScreen()
}

final class DogFiltersViewModel {
    var viewStateDidChange: (DogFiltersState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    var onAction: (DogFiltersAction) -> ()  = { _ in }
    
    private var dogFilters: DogFiltersModel = DogFiltersModel(breeds: nil, age: nil)
    
    private var currentState: DogFiltersState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    private let router: IDogFilterRouters
    
    init(router: IDogFilterRouters) {
        self.router = router
    }
}

extension DogFiltersViewModel: IDogFiltersViewModel {
    func onApplyButtonTapped() {
        if dogFilters.breeds != nil || dogFilters.age != nil {
            onAction(DogFiltersAction.applyFilter(filter: dogFilters))
        } else {
            return
        }
    }
    
    func onAgeFilterChanged(age: String) {
        dogFilters.age = age
        currentState = .success(filter: dogFilters)
    }
    
    func onBreedFilterChanged(breeds: [String]) {
        dogFilters.breeds = breeds
        currentState = .success(filter: dogFilters)
    }
    
    func deselectAgeFilterTapped() {
        dogFilters.age = nil
        currentState = .success(filter: dogFilters)
    }
    
    func deselectBreedFilterTapped() {
        dogFilters.breeds = nil
        currentState = .success(filter: dogFilters)
    }
    
}

extension DogFiltersViewModel: IDogFiltersNavigation {
    func showSelectBreedScreen(doOnMultiSelect: @escaping ([String]) -> Void) {
        router.showSelectBreedScreen(doOnMultiSelect: doOnMultiSelect)
    }
    
    func popDogFiltersScreen() {
        router.popViewController()
    }
}
