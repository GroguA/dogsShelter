//
//  AddNewDogAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

enum AddNewDogAssembly {
    static func createAddNewDogModule(with navigationController: UINavigationController) -> AddNewDogViewController {
        let router = AddNewDogRouter(navigationController: navigationController)
        let viewModel = AddNewDogViewModel(router: router)
        let view = AddNewDogViewController(viewModel: viewModel)
        return view
    }
}
