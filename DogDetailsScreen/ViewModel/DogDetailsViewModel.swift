//
//  DogDetailsViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.10.2023.
//

import Foundation

protocol IDogDetailsViewModel {
    var viewStateDidChange: (DogDetailsState) -> () { get set }
    var onAction: (DogDetailsAction) -> () { get set }
    func getOneDogBy(_ id: String)
    func deleteDogClicked()
    func updateDogWashClicked()
}

protocol IDogDetailsNavigation {
    func popDogDetailsScreen()
    func navigateToScheduleReminderScreen()
}

final class DogDetailsViewModel {
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
    
    private let router: IDogDetailsRouter
    
    private var dogId: String
    
    init(router: IDogDetailsRouter, dogId: String) {
        self.router = router
        self.dogId = dogId
        getOneDogBy(dogId)
    }
    
}

extension DogDetailsViewModel: IDogDetailsViewModel {
    func getOneDogBy(_ id: String) {
        if let dog = DogStorageService.shared.getOneDogBy(id: id) {
            let dogWashInfoText = dog.dateOfWash ?? "None"
            let dogModel = DogDetailsModel(
                name: dog.name,
                breed: dog.breed,
                age: DateUtils.shared.getDogAgeInYears(dateOfBirth: dog.dateOfBirth),
                image: dog.image,
                id: dog.id,
                dateOfWash: dogWashInfoText
            )
            currentState = .success(dog: dogModel)
            currentDog = dogModel
        } else {
            onAction(DogDetailsAction.showError)
        }
        
    }
    
    func deleteDogClicked() {
        if !DogStorageService.shared.deleteDogBy(id: dogId) {
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

extension DogDetailsViewModel: IDogDetailsNavigation {
    func popDogDetailsScreen() {
        router.popViewController()
    }
    
    func navigateToScheduleReminderScreen() {
        router.navigateToScheduleReminderScreen(dogId)
    }
}
