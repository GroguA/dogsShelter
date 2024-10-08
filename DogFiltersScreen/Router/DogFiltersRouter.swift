//
//  DogFiltersRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 22.07.2024.
//

import UIKit

protocol IDogFilterRouters {
    func navigateToSelectBreedScreen(doOnMultiSelect: @escaping (([String]) -> Void))
    func popViewController()
}

final class DogFiltersRouter: IDogFilterRouters {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToSelectBreedScreen(doOnMultiSelect: @escaping (([String]) -> Void)) {
        let viewController = SelectBreedAssembly.createSelectBreedModule(with: navigationController, isSingleSelectMode: false)
        viewController.doOnMultiSelect = doOnMultiSelect
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
