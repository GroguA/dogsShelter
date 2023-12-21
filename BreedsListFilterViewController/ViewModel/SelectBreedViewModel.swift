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
    
    private var breedsBeforeSearch = BreedsList.shared.getBreeds()
    
    private var currentState: SelectBreedState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    func loadBreeds(isSingleSelect: Bool) {
        isSingleSelectMode = isSingleSelect
        currentState = .success(breeds: BreedsList.shared.getBreeds())
    }
    
    func onDogClicked(dogIndex: Int) {
        if isSingleSelectMode {
            let breed = BreedsList.shared.getBreeds()[dogIndex]
            onAction(SelectBreedAction.closeWithBreed(breed: breed))
        }
    }
    func onDoneButtonClicked(indecies: [Int]) {
        let breeds = BreedsList.shared.getBreeds()
        let selectedBreeds = indecies.map({ index in
            return breeds[index]
        })
        onAction(SelectBreedAction.closeWithBreeds(breeds: selectedBreeds))
    }
    
    func onSearchBarTapped(searchText: String) {
        if searchText.isEmpty {
            currentState = .success(breeds: breedsBeforeSearch)
        } else {
            let filteredBreeds = breedsBeforeSearch.filter({ breed in
                return breed.lowercased().contains(searchText.lowercased())
            })
            currentState = .success(breeds: filteredBreeds)
        }
    }
    
    func disableSearch() {
        currentState = .success(breeds: breedsBeforeSearch)
    }
    
}
