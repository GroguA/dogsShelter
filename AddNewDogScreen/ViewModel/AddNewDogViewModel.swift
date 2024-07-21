//
//  AddNewDogViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 29.09.2023.
//

import Foundation

class AddNewDogViewModel {
    
    var onAction: (AddNewDogAction) -> ()  = { _ in }
    
    private let dogStorage = DogStorageService.shared
    
    func onAddDogBtnClicked(name: String?, breed: String?, dateOfBirth: String?, image: Data?) {
        guard let name = name?.trimmingCharacters(in: .whitespaces), !name.isEmpty, let breed = breed, !breed.isEmpty, let dateOfBirth = dateOfBirth, !dateOfBirth.isEmpty, let image = image, !image.isEmpty else {
            onAction(AddNewDogAction.showError(text: "Please fill all text fields"))
            return
        }
        let dog = SaveDogCoreDataModel(name: name, breed: breed, dateOfBirth: dateOfBirth, image: image)
        if dogStorage.saveDog(dog: dog) {
            onAction(AddNewDogAction.closeScreen)
        } else {
            onAction(AddNewDogAction.showError(text: "Can't save this dog"))
        }
        
    }
    
}
