//
//  DogListAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 20.07.2024.
//

import UIKit

enum DogListAssembly {
    static func createDogListModule(with navigationController: UINavigationController) -> UIViewController {
        let router = DogListRouter(navigationController: navigationController)
        let viewModel = DogListViewModel(router: router)
        let view = DogListViewController(viewModel: viewModel)
        return view
    }
}
