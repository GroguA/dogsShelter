//
//  SelectBreedViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 26.10.2023.
//

import Foundation

protocol ISelectBreedViewModel {
    var viewStateDidChange: (SelectBreedState) -> () { get set }
    var onAction: (SelectBreedAction) -> () { get set }
    func loadBreeds(isSingleSelect: Bool)
    func onBreedClicked(breedIndex: Int)
    func onDoneButtonClicked()
    func onSearchTextChanged(searchText: String)
    func disableSearch()
}

protocol ISelectBreedNavigation {
    func popSelectBreedScreen()
}

final class SelectBreedViewModel {
    var viewStateDidChange: (SelectBreedState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    var onAction: (SelectBreedAction) -> ()  = { _ in }
    
    let router: ISelectBreedRouter
    
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
    
    private var isSearching = false
    
    init(router: ISelectBreedRouter) {
        self.router = router
    }
    
}

extension SelectBreedViewModel: ISelectBreedViewModel {
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
            currentBreeds[breedIndex].isSelected = !currentBreeds[breedIndex].isSelected

            let currentBreedName = currentBreeds[breedIndex].breed
            let breedIndex = breedsBeforeSearch.firstIndex(where: { breedList in
                breedList.breed == currentBreedName
            })
            
            if let breedIndex {
                breedsBeforeSearch[breedIndex].isSelected = !breedsBeforeSearch[breedIndex].isSelected
                currentState = isSearching ? .success(breeds: currentBreeds) : .success(breeds: breedsBeforeSearch)
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
        isSearching = true
        if searchText.isEmpty {
            currentState = .success(breeds: breedsBeforeSearch)
        } else {
            let filteredBreeds = breedsBeforeSearch.filter({ breedList in
                return breedList.breed.lowercased().contains(searchText.lowercased())
            })
            currentBreeds = filteredBreeds
            currentState = .success(breeds: filteredBreeds)
        }
    }
    
    func disableSearch() {
        isSearching = false
        currentBreeds = breedsBeforeSearch
        currentState = .success(breeds: breedsBeforeSearch)
    }
    
}

extension SelectBreedViewModel: ISelectBreedNavigation {
    func popSelectBreedScreen() {
        router.popViewController()
    }
}
