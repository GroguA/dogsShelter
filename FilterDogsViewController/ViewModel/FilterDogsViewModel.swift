//
//  FilterDogsViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 23.10.2023.
//

import Foundation

class FilterDogsViewModel {
    
    var viewStateDidChange: (FilterDogsState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    private var currentState: FilterDogsState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    func dogAgeFilter(active: Bool) {
        if active {
            currentState = .ageFilter(active: true)
        } else {
            currentState = .ageFilter(active: false)
        }
    }
    
    func dogBreedFilter(active: Bool) {
        if active {
            currentState = .breedFilter(active: true)
        } else {
            currentState = .breedFilter(active: false)
        }
    }
    
}
