//
//  SceneDelegate.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        let dogsListViewController = DogsListScreenAssembly.createDogListModule(with: navigationController)
        navigationController.viewControllers = [dogsListViewController]
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
}

