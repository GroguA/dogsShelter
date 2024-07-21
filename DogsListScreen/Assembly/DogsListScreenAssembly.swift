//
//  DogsListScreenAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 20.07.2024.
//

import UIKit

enum DogsListScreenAssembly {
    static func createDogListModule(with navigationController: UINavigationController) -> UIViewController {
        let router = DogsListRouter(navigationController: navigationController)
        let viewModel = DogsListViewModel(router: router)
        let view = DogsListViewController(viewModel: viewModel)
        return view
    }
}
