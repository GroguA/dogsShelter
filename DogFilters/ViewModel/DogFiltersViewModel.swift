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
    
    private var currentState: DogFiltersState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    func onApplyButtonTapped() {
        switch currentState {
        case .success(let filter):
            if filter.breeds != nil || filter.age != nil {
                onAction(DogFiltersAction.applyFilter(filter: filter))
            } else {
                return
            }
        case nil:
            return
        }
    }
    
    func onAgeFilterTapped(age: String) {
        switch currentState {
        case .success(let filter):
            currentState = .success(filter: FilterForDogs(breeds: filter.breeds, age: age))
        case nil:
            currentState = .success(filter: FilterForDogs(breeds: nil, age: age))
        }
    }
    
    func onBreedFilterTapped(breeds: [String]) {
        switch currentState {
        case .success(let filter):
            currentState = .success(filter: FilterForDogs(breeds: breeds, age: filter.age))
        case nil:
            currentState = .success(filter: FilterForDogs(breeds: breeds, age: nil))
        }
    }
    
    func deselectAgeFilterTapped() {
        switch currentState {
        case .success(let filter):
            currentState = .success(filter: FilterForDogs(breeds: filter.breeds, age: nil))
        case nil:
            return
        }
        
    }
    
    func deselectBreedFilterTapped() {
        switch currentState {
        case .success(let filter):
            currentState = .success(filter: FilterForDogs(breeds: nil, age: filter.age))
        case nil:
            return
        }
        
    }
    
}
