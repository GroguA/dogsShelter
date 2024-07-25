//
//  SelectBreedAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

enum SelectBreedAssembly {
    static func createSelectBreedModule(with navigationController: UINavigationController, isSingleSelectMode: Bool = true) -> SelectBreedViewController {
        let router = SelectBreedRouter(navigationController: navigationController)
        let viewModel = SelectBreedViewModel(router: router)
        let view = SelectBreedViewController(viewModel: viewModel, isSingleSelectMode: isSingleSelectMode)
        return view
    }
}
