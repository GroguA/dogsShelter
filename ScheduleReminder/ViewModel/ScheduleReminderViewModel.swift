//
//  ScheduleReminderViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 16.01.2024.
//

import Foundation

class ScheduleReminderViewModel {
    
    var onAction: (ScheduleReminderAction) -> () = { _ in }
    
    func onScheduleREminderTapped(body: String?, hour: Int?, minute: Int?, isDaily: Bool, day: Int?, month: Int?, identifier: String) {
        if let body, let hour, let minute, let day, let month {
            if !body.isEmpty {
                DogsNotificationsManager.shared.dispatchNotificationsDogDetailsVC(body: body, hour: hour, minute: minute, isDaily: isDaily, day: day, month: month, identifier: identifier)
            } else {
                onAction(ScheduleReminderAction.editingError)
            }
        } else {
            onAction(ScheduleReminderAction.editingError)
        }
    }
}
