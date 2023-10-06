//
//  DogStorageService.swift
//  Shelter
//
//  Created by Александра Сергеева on 03.10.2023.
//

import UIKit
import CoreData


class DogStorageService  {
    
    static let shared = DogStorageService()
    
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    func saveDog(dog: DogCoreDataModel) -> Bool {
        
        guard let appDelegate = appDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Dog", in: managedContext) else {
            return false
        }
        
        let dogsNSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        dogsNSManagedObject.setValue(dog.name, forKey: "name")
        dogsNSManagedObject.setValue(dog.breed, forKey: "breed")
        dogsNSManagedObject.setValue(dog.dateOfBirth, forKey: "dateOfBirth")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func fetchSavedDogs() -> Array<DogCoreDataModel> {
        
        var dogsArr = [DogCoreDataModel]()
        
        guard let appDelegate = appDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dog")
        
        do {
            let dogsManagedObjects = try managedContext.fetch(fetchRequest)
            dogsManagedObjects.forEach({ dogManagedObj in
                guard let name = dogManagedObj.value(forKey: "name") as? String,
                      let breed = dogManagedObj.value(forKey: "breed") as? String,
                      let dateOfBirth = dogManagedObj.value(forKey: "dateOfBirth") as? String
                else {
                    return
                }
                let dog = DogCoreDataModel(name: name, breed: breed, dateOfBirth: dateOfBirth)
                dogsArr.append(dog)
            })
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return dogsArr
    }
    
}
