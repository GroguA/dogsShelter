//
//  DogDetailsRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 23.07.2024.
//

import UIKit

protocol IDogDetailsRouter {
    func popViewController()
    func navigateToScheduleReminderScreen()
}

final class DogDetailsRouter: IDogDetailsRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToScheduleReminderScreen() {
        let reminderVC = ScheduleReminderViewController()
        let isNotificationOn = DogsNotificationsManager.shared.getAvailability()
        if isNotificationOn {
            navigationController.pushViewController(reminderVC, animated: true)
//            reminderVC.dogId = self.dogId
        } else {
            return
        }
    }
}
