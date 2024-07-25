//
//  DogListRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

protocol IDogListRouter: AnyObject {
    func navigateToAddNewDogScreen()
    func navigateToDogFiltersScreen(onDogFiltersSelected: @escaping ((_ filter: DogFiltersModel) -> Void))
    func navigateToDogDetailsScreen(with dogId: String)
    func navigateToNotificationListScreen()
}

final class DogListRouter: IDogListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToAddNewDogScreen() {
        let viewController = AddNewDogAssembly.createAddNewDogModule(with: navigationController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToDogFiltersScreen(onDogFiltersSelected: @escaping ((_ filter: DogFiltersModel) -> Void)) {
        let viewController = DogFiltersAssembly.createDogFiltersModule(with: navigationController)
        viewController.onDogFiltersSelected = onDogFiltersSelected
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToDogDetailsScreen(with dogId: String) {
        let viewController = DogDetailsAssembly.createDogDetailsModule(with: navigationController, dogId: dogId)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToNotificationListScreen() {
        let viewController = NotificationListAssembly.createNotificationListModule()
        navigationController.pushViewController(viewController, animated: true)
    }
}
