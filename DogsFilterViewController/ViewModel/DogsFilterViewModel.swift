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
    
    
    func onBreedFilterTapped(breeds: [String]) {
        currentState = .breedFilter(breeds: breeds)
    }
    
    func onApplyButtonTapped() {
        switch currentState {
        case .breedFilter(let breeds):
            onAction(FilterDogAction.applyBreedFilter(breeds: breeds))
        case .ageFilter(let age):
            onAction(FilterDogAction.applyAgeFilter(age: age))
        case nil:
            return
        }
    }
    
    func onAgeFilterTapped(age: String) {
        currentState = .ageFilter(age: age)
    }
    
}
