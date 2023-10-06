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
    
    func onAddDogBtnClicked(name: String?, breed: String?, dateOfBirth: String?) {
        guard let name = name?.trimmingCharacters(in: .whitespaces), !name.isEmpty, let breed = breed, !breed.isEmpty, let dateOfBirth = dateOfBirth, !dateOfBirth.isEmpty else {
            onAction(AddNewDogAction.editingError)
            return
        }
        let dog = DogCoreDataModel(name: name, breed: breed, dateOfBirth: dateOfBirth)
        if dogStorage.saveDog(dog: dog) {
            currentState = AddNewDogState.success
        } else {
            onAction(AddNewDogAction.saveError)
        }
        
    }
    
     func getAge(dateOfBirth: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let dateOfBirth = dateFormatter.date(from: dateOfBirth) else {
            return 0
        }
        let calendar = Calendar.current
        let currentDate = Date()
        let currentDays = calendar.component(.year, from: currentDate)
        
        let birthDays = calendar.component(.year, from: dateOfBirth)

        let age = currentDays - birthDays
        
        return age
        
    }
}
