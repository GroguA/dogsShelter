//
//  DogFiltersScreenAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 22.07.2024.
//

import UIKit

enum DogFiltersScreenAssembly {
    static func createDogFiltersModule(with navigationController: UINavigationController) -> DogFiltersViewController {
        let router = DogFiltersRouter(navigationController: navigationController)
        let viewModel = DogFiltersViewModel(router: router)
        let view = DogFiltersViewController(viewModel: viewModel)
        return view
    }
}
