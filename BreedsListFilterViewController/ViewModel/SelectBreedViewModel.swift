//
//  SelectBreedViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 26.10.2023.
//

import Foundation

class SelectBreedViewModel {
        
    var viewStateDidChange: (SelectBreedState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    var onAction: (SelectBreedAction) -> ()  = { _ in }
    
    var isSingleSelectMode = true
    
    private var currentState: SelectBreedState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    func loadBreeds(isSingleSelect: Bool) {
        isSingleSelectMode = isSingleSelect
        currentState = .success(breeds: BreedsList.shared.breeds)
    }
    
    func onDogClicked(dogIndex: Int) {
        if isSingleSelectMode {
            let breed = BreedsList.shared.breeds[dogIndex]
            onAction(SelectBreedAction.closeWithBreed(breed: breed))
        }
    }
    func onDoneButtonClicked(indecies: [Int]) {
        let breeds = BreedsList.shared.breeds
        let selectedBreeds = indecies.map({ index in
            return breeds[index]
        })
        onAction(SelectBreedAction.closeWithBreeds(breeds: selectedBreeds))
    }
    
}
