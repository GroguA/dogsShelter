//
//  SelectBreedRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

protocol ISelectBreedRouter {
    func popViewController()
}

final class SelectBreedRouter: ISelectBreedRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
}
