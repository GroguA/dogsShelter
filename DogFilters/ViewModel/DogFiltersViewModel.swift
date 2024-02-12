//
//  DogFiltersViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.10.2023.
//

import Foundation

class DogFiltersViewModel {
    
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
