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
    
    
    func onAgeFilterTapped(age: String) {
        dogFilters.age = age
        if let breeds = dogFilters.breeds {
            currentState = .success(filter: dogFilters)
        } else {
            currentState = .success(filter: dogFilters)
        }
    }
    
    func onBreedFilterTapped(breeds: [String]) {
        dogFilters.breeds = breeds
        if let age = dogFilters.age {
            currentState = .success(filter: dogFilters)
        } else {
            currentState = .success(filter: dogFilters)
        }
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
