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
    
    
    func breedsSelected(breeds: [String]) {
        currentState = .breedFilter(breeds: breeds)
    }
    
    func onApplyButtonTapped() {
        switch currentState {
        case .breedFilter(let breeds):
            onAction(FilterDogAction.applyFilter(value: breeds))
        case nil:
            return
        }
    }
    
}
