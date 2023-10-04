//
//  AddNewDogViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 29.09.2023.
//

import Foundation

class AddNewDogViewModel {
    
    var viewStateDidChange: (AddNewDogState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    var onAction: (AddNewDogAction) -> ()  = { _ in }
    
    private var currentState: AddNewDogState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    private let dogStorage = DogStorageService.shared
    
    func onAddDogBtnClicked(name: String?, breed: String?) {
        guard let name = name?.trimmingCharacters(in: .whitespaces), !name.isEmpty, let breed = breed?.trimmingCharacters(in: .whitespaces), !breed.isEmpty else {
            onAction(AddNewDogAction.editingError)
            return
        }
        let dog = DogCoreDataModel(name: name, breed: breed)
        guard dogStorage.saveDog(dog: dog) else {
            onAction(AddNewDogAction.saveError)
            return
        }
        currentState = AddNewDogState.success
    }
    
}
