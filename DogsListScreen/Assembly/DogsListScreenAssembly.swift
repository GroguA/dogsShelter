//
//  DogsListScreenAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 20.07.2024.
//

import UIKit

enum DogsListScreenAssembly {
    static func createDogListModule(with navigationController: UINavigationController) -> UIViewController {
        let viewModel = DogsListViewModel()
        let view = DogsListViewController(viewModel: viewModel)
        return view
    }
}
