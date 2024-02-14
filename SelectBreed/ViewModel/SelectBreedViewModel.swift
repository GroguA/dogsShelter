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
    
    private var breedsBeforeSearch = [SelectBreedModel]()
    
    private var currentState: SelectBreedState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    private var currentBreeds = [SelectBreedModel]()
    
    private let breedsDataSource = BreedsDataSource.shared
    
    func loadBreeds(isSingleSelect: Bool) {
        isSingleSelectMode = isSingleSelect
        breedsBeforeSearch = breedsDataSource.getBreeds().map({ breed in
            return SelectBreedModel(breed: breed, isSelected: false)
        })
        currentBreeds = breedsBeforeSearch
        currentState = .success(breeds: breedsBeforeSearch)
    }
    
    func onBreedClicked(breedIndex: Int) {
        if isSingleSelectMode {
            let breed = currentBreeds[breedIndex].breed
            onAction(SelectBreedAction.closeWithBreed(breed: breed))
        } else {
            let currentBreedName = currentBreeds[breedIndex].breed
            let breedIndex = breedsBeforeSearch.firstIndex(where: { breedBeforeSearch in
                breedBeforeSearch.breed == currentBreedName
            })
            if let breedIndex = breedIndex {
                breedsBeforeSearch[breedIndex].isSelected = !breedsBeforeSearch[breedIndex].isSelected
            }
        }
    }
    
    func onDoneButtonClicked() {
        let selectedBreeds = currentBreeds.filter({ $0.isSelected })
        if !selectedBreeds.isEmpty {
            onAction(SelectBreedAction.closeWithBreeds(breeds: selectedBreeds.map({ $0.breed })))
        }
    }
    
    func onSearchTextChanged(searchText: String) {
        if searchText.isEmpty {
            currentState = .success(breeds: breedsBeforeSearch)
        } else {
            let filteredBreeds = breedsBeforeSearch.filter({ breed in
                return breed.breed.lowercased().contains(searchText.lowercased())
            })
            currentBreeds = filteredBreeds
            currentState = .success(breeds: filteredBreeds)
        }
    }
    
    func disableSearch() {
        currentBreeds = breedsBeforeSearch
        currentState = .success(breeds: breedsBeforeSearch)
    }
    
}
