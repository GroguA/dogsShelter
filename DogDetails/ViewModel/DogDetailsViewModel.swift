//
//  DogDetailsViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.10.2023.
//

import Foundation

class DogDetailsViewModel {
    
    var viewStateDidChange: (DogDetailsState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    var onAction: (DogDetailsAction) -> ()  = { _ in }
    
    private var currentState: DogDetailsState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    private var currentDog: DogDetailsModel? = nil
    
    func getOneDogByID(id: String) {
        if let dog = DogStorageService.shared.getOneDogById(id: id) {
            let dogModel = DogDetailsModel(name: dog.name, breed: dog.breed, age: DateUtils.shared.getDogAgeInYears(dateOfBirth: dog.dateOfBirth), image: dog.image, id: dog.id, dateOfWash: dog.dateOfWash)
            currentState = .success(dog: dogModel)
            currentDog = dogModel
        } else {
            onAction(DogDetailsAction.showError)
        }
        
    }
    
    func deleteDogClicked(id: String) {
        if !DogStorageService.shared.deleteDog(id: id) {
            onAction(DogDetailsAction.showError)
        } else {
            onAction(DogDetailsAction.closeScreen)
        }
    }
    
    func updateDogWashClicked() {
        let date = DateUtils.shared.getCurrentDate()
        guard let dogBeforeWash = currentDog else { return }
        if !DogStorageService.shared.saveDogsDateOfWash(id: dogBeforeWash.id, date: date) {
            onAction(DogDetailsAction.showError)
        } else {
            let dogAfterWash = DogDetailsModel(name: dogBeforeWash.name,
                                               breed: dogBeforeWash.breed,
                                               age: dogBeforeWash.age,
                                               image: dogBeforeWash.image,
                                               id: dogBeforeWash.id,
                                               dateOfWash: date)
            currentState = .success(dog: dogAfterWash)
            currentDog = dogAfterWash
        }
    }
    
}
