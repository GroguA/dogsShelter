//
//  NotificationListAssembly.swift
//  Shelter
//
//  Created by Александра Сергеева on 24.07.2024.
//

import UIKit

enum NotificationListAssembly {
    static func createNotificationListModule() -> NotificationListViewController {
        let viewModel = NotificationListViewModel()
        let viewController = NotificationListViewController(viewModel: viewModel)
        return viewController
    }
}
