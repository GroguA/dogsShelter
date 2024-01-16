//
//  ScheduleReminderViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 16.01.2024.
//

import Foundation

class ScheduleReminderViewModel {
    
    var onAction: (ScheduleReminderAction) -> () = { _ in }
    
    func onScheduleREminderTapped(body: String?, hour: Int?, minute: Int?, isDaily: Bool) {
        if let body, let hour, let minute {
            if !body.isEmpty {
                NotificationCenter.shared.dispatchNotificationsOneDogVC(body: body, hour: hour, minute: minute, isDaily: isDaily)
            } else {
                onAction(ScheduleReminderAction.editingError)
            }
        } else {
                onAction(ScheduleReminderAction.editingError)
            }
        }
}
