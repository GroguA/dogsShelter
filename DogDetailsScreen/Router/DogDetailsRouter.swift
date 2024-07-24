//
//  DogDetailsRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 23.07.2024.
//

import UIKit

protocol IDogDetailsRouter {
    func popViewController()
    func navigateToScheduleReminderScreen(_ dogId: String)
}

final class DogDetailsRouter: IDogDetailsRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToScheduleReminderScreen(_ dogId: String) {
        let viewController = ScheduleReminderScreenAssembly.createScheduleReminderScreen(with: navigationController, id: dogId)
        let isNotificationOn = DogsNotificationsManager.shared.getAvailability()
        if isNotificationOn {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            return
        }
    }
}
