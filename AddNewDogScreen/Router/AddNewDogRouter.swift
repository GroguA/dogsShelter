//
//  AddNewDogRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

protocol IAddNewDogRouter {
    func showSelectBreedScreen()
}

final class AddNewDogRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showSelectBreedScreen(doOnSingleSelect: @escaping (String) -> Void) {
        let viewController = SelectBreedAssembly.createSelectBreedModule(with: navigationController)
        viewController.isSingleSelectMode = true
        viewController.doOnSingleSelect = doOnSingleSelect
        navigationController.pushViewController(viewController, animated: true)
    }
}
