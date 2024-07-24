//
//  ScheduleReminderScreenAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 24.07.2024.
//

import UIKit

enum ScheduleReminderScreenAssembly {
    static func createScheduleReminderScreen(with navigationController: UINavigationController, id: String) -> ScheduleReminderViewController {
        let router = ScheduleReminderRouter(navigationController: navigationController)
        let viewModel = ScheduleReminderViewModel(id: id, router: router)
        let viewController = ScheduleReminderViewController(viewModel: viewModel)
        return viewController
    }
}
