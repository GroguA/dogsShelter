//
//  OneDogViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.10.2023.
//

import Foundation

class OneDogViewModel {
    
    var viewStateDidChange: (OneDogState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    var onAction: (OneDogAction) -> ()  = { _ in }
    
    private var currentState: OneDogState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    private var dogBeforeWash: OneDogModel? = nil
    
    func getOneDogByID(id: String) {
        if let dog = DogStorageService.shared.getOneDogById(id: id) {
            let dogModel = OneDogModel(name: dog.name, breed: dog.breed, age: CalculateDates.shared.getDogAge(dateOfBirth: dog.dateOfBirth), image: dog.image, id: dog.id, dateOfWash: dog.dateOfWash)
            if  dogModel.dateOfWash == nil {
                currentState = .success(dog: dogModel, isDogWashClicked: false)
                dogBeforeWash = dogModel
            } else {
                currentState = .success(dog: dogModel, isDogWashClicked: true)
                dogBeforeWash = dogModel
            }
        } else {
            onAction(OneDogAction.error)
        }
        
    }
    
    func deleteDogClicked(id: String) {
        if !DogStorageService.shared.deleteDog(id: id) {
            onAction(OneDogAction.error)
        } else {
            onAction(OneDogAction.deleteDog)
        }
    }
    
    func updateDogWashClicked(id: String) {
        let date = CalculateDates.shared.getCurrentDate()
        if !DogStorageService.shared.saveDogsDateOfWash(id: id, date: date) {
            onAction(OneDogAction.error)
        } else {
            if let dogBeforeWash = dogBeforeWash {
                let dogAfterWash = OneDogModel(name: dogBeforeWash.name,
                                         breed: dogBeforeWash.breed,
                                         age: dogBeforeWash.age,
                                         image: dogBeforeWash.image,
                                         id: dogBeforeWash.id,
                                         dateOfWash: date)
                currentState = .success(dog: dogAfterWash, isDogWashClicked: true)
            }
        }
    }
}
