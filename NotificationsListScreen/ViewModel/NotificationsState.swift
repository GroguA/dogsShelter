//
//  NotificationsState.swift
//  Shelter
//
//  Created by Александра Сергеева on 19.01.2024.
//

import Foundation

enum NotificationsState {
    case success(notifications: [NotificationModel], atLeastOneNotificationSelected: Bool)
    case empty
}
