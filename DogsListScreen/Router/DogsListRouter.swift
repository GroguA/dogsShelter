//
//  DogsListRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

protocol IDogsListRouter: AnyObject {
    func showAddNewDogScreen()
}

final class DogsListRouter: IDogsListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showAddNewDogScreen() {
        let viewController = AddNewDogScreenAssembly.createAddNewDogModule(with: navigationController)
        navigationController.pushViewController(viewController, animated: true)
    }
}
