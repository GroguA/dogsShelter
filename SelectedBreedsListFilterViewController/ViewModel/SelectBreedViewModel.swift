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
    
    private var isSingleSelectMode = true
    
    private var breedsBeforeSearch: [SelectableBreed] = BreedsList.shared.getBreeds().map({ breed in
        return SelectableBreed(breed: breed, isSelected: false)
    })
    
    private var currentState: SelectBreedState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    func loadBreeds(isSingleSelect: Bool) {
        isSingleSelectMode = isSingleSelect
        currentState = .success(breeds: breedsBeforeSearch)
    }
    
    func onDogClicked(dogIndex: Int) {
        if isSingleSelectMode {
            if case .success(let breeds) = currentState {
                let breed = breeds[dogIndex].breed
                onAction(SelectBreedAction.closeWithBreed(breed: breed))
            }
        } else {
            if case .success(let breeds) = currentState {
                let currentBreedName = breeds[dogIndex].breed
                let breedIndex = breedsBeforeSearch.firstIndex(where: { selectableBreed in
                    selectableBreed.breed == currentBreedName
                })
                if let breedIndex = breedIndex {
                    if !breedsBeforeSearch[breedIndex].isSelected == true {
                        breedsBeforeSearch[breedIndex].isSelected = true
                    } else {
                        breedsBeforeSearch[breedIndex].isSelected = false
                    }
                }
            }
        }
    }
    
    
    func onDoneButtonClicked() {
        if case .success(let breeds) = currentState {
            let selectedBreeds = breeds.filter({$0.isSelected})
            onAction(SelectBreedAction.closeWithBreeds(breeds: selectedBreeds.map({ $0.breed
            })))
        }
    }
    
    func onSearchBarTapped(searchText: String) {
        if searchText.isEmpty {
            currentState = .success(breeds: breedsBeforeSearch)
        } else {
            let filteredBreeds = breedsBeforeSearch.filter({ breed in
                return breed.breed.lowercased().contains(searchText.lowercased())
            })
            currentState = .success(breeds: filteredBreeds)
        }
    }
    
    func disableSearch() {
        currentState = .success(breeds: breedsBeforeSearch)
    }
    
//    func backToFilterButtonTapped() {
//        onAction(SelectBreedAction.close)
//    }
    
}
