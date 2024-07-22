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
}
