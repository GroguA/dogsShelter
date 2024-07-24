//
//  DogListRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

protocol IDogListRouter: AnyObject {
    func showAddNewDogScreen()
    func showDogFiltersScreen(onDogFiltersSelected: @escaping ((_ filter: DogFiltersModel) -> Void))
    func showDogDetailsScreen(with dogId: String)
    func showNotificationListScreen()
}

final class DogListRouter: IDogListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showAddNewDogScreen() {
        let viewController = AddNewDogScreenAssembly.createAddNewDogModule(with: navigationController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDogFiltersScreen(onDogFiltersSelected: @escaping ((_ filter: DogFiltersModel) -> Void)) {
        let viewController = DogFiltersScreenAssembly.createDogFiltersModule(with: navigationController)
        viewController.onDogFiltersSelected = onDogFiltersSelected
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDogDetailsScreen(with dogId: String) {
        let viewController = DogDetailsScreenAssembly.createDogDetailsModule(with: navigationController, dogId: dogId)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showNotificationListScreen() {
        let viewController = NotificationListScreenAssembly.createNotificationListModule()
        navigationController.pushViewController(viewController, animated: true)
    }
}
