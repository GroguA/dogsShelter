//
//  DogStorageService.swift
//  Shelter
//
//  Created by Александра Сергеева on 03.10.2023.
//

import UIKit
import CoreData

final class DogStorageService  {
    static let shared = DogStorageService()
    
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func saveDog(_ dog: SaveDogCoreDataModel) -> Bool {
        guard let appDelegate = appDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Dog", in: managedContext) else {
            return false
        }
        
        let dogsNSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        dogsNSManagedObject.setValue(dog.name, forKey: "name")
        dogsNSManagedObject.setValue(dog.breed, forKey: "breed")
        dogsNSManagedObject.setValue(dog.dateOfBirth, forKey: "dateOfBirth")
        dogsNSManagedObject.setValue(dog.image, forKey: "image")
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func fetchSavedDogs() -> Array<FetchDogCoreDataModel> {
        var dogsArr = [FetchDogCoreDataModel]()
        
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
                      let dateOfBirth = dogManagedObj.value(forKey: "dateOfBirth") as? String,
                      let image = dogManagedObj.value(forKey: "image") as? Data
                else {
                    return
                }
                let dog = FetchDogCoreDataModel(name: name, breed: breed, dateOfBirth: dateOfBirth, image: image, id: dogManagedObj.objectID.uriRepresentation().absoluteString, dateOfWash: nil)
                dogsArr.append(dog)
            })
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return dogsArr
    }
    
    func getOneDogBy(id: String) -> FetchDogCoreDataModel? {
        guard let appDelegate = appDelegate else {
            return nil
        }
        var dog: FetchDogCoreDataModel? = nil
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let url = URL(string: id), let storageCoordinator = managedContext.persistentStoreCoordinator else { return nil
        }
        guard let objectID = storageCoordinator.managedObjectID(forURIRepresentation: url) else { return nil }
        let dogManagedObj = managedContext.object(with: objectID)
        
        guard let name = dogManagedObj.value(forKey: "name") as? String,
              let breed = dogManagedObj.value(forKey: "breed") as? String,
              let dateOfBirth = dogManagedObj.value(forKey: "dateOfBirth") as? String,
              let image = dogManagedObj.value(forKey: "image") as? Data,
              let dateOfWash = dogManagedObj.value(forKey: "dateOfWash") as? String
        else {
            guard let name = dogManagedObj.value(forKey: "name") as? String,
                  let breed = dogManagedObj.value(forKey: "breed") as? String,
                  let dateOfBirth = dogManagedObj.value(forKey: "dateOfBirth") as? String,
                  let image = dogManagedObj.value(forKey: "image") as? Data
            else {
                return nil
            }
            dog = FetchDogCoreDataModel(
                name: name,
                breed: breed,
                dateOfBirth: dateOfBirth,
                image: image,
                id: dogManagedObj.objectID.uriRepresentation().absoluteString,
                dateOfWash: nil
            )
            return dog
        }
        dog = FetchDogCoreDataModel(
            name: name,
            breed: breed,
            dateOfBirth: dateOfBirth,
            image: image,
            id: dogManagedObj.objectID.uriRepresentation().absoluteString,
            dateOfWash: dateOfWash
        )
        return dog
    }
    
    func deleteDogBy(id: String) -> Bool {
        guard let appDelegate = appDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let url = URL(string: id), let storageCoordinator = managedContext.persistentStoreCoordinator else { return false
        }
        
        guard let objectID = storageCoordinator.managedObjectID(forURIRepresentation: url) else { return false }
        let dogManagedObj = managedContext.object(with: objectID)
        
        managedContext.delete(dogManagedObj)
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not delete this object. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func saveDogDateOfWash(id: String, date: String) -> Bool {
        guard let appDelegate = appDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let url = URL(string: id), let storageCoordinator = managedContext.persistentStoreCoordinator else { return false
        }
        
        guard let objectID = storageCoordinator.managedObjectID(forURIRepresentation: url) else { return false }
        let dogManagedObj = managedContext.object(with: objectID)
        
        dogManagedObj.setValue(date, forKey: "dateOfWash")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save this date. \(error), \(error.userInfo)")
            return false
        }
        
    }
    
}
