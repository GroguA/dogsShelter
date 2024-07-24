//
//  DogDetailsScreenAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 23.07.2024.
//

import UIKit

enum DogDetailsScreenAssembly {
    static func createDogDetailsModule(with navigationController: UINavigationController, dogId: String) -> DogDetailsViewController {
        let router = DogDetailsRouter(navigationController: navigationController)
        let viewModel = DogDetailsViewModel(router: router, dogId: dogId)
        let view = DogDetailsViewController(viewModel: viewModel)
        return view
    }
}
