//
//  ScheduleReminderRouter.swift
//  Shelter
//
//  Created by Александра Сергеева on 24.07.2024.
//

import UIKit

protocol IScheduleReminderRouter {
    func popViewController()
}

final class ScheduleReminderRouter: IScheduleReminderRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
}
