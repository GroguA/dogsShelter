//
//  DogsFilterViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 27.10.2023.
//

import Foundation

class DogsFilterViewModel {
    
    var viewStateDidChange: (FilterDogState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    var onAction: (FilterDogAction) -> ()  = { _ in }
        
    private var currentState: FilterDogState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    

    
    func onApplyButtonTapped() {
        switch currentState {
        case .success(let filter):
            onAction(FilterDogAction.applyFilter(filter: filter))
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
    
}
