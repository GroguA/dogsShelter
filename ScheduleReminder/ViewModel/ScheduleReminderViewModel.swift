//
//  ScheduleReminderViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 16.01.2024.
//

import Foundation

class ScheduleReminderViewModel {
    
    var onAction: (ScheduleReminderAction) -> () = { _ in }
    
    func onScheduleReminderTapped(body: String?, date: Date?, isDaily: Bool, identifier: String) {
        if let body, let date {
           let hour = Calendar.current.component(.hour, from: date)
           let minute = Calendar.current.component(.minute, from: date)
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            if !body.isEmpty {
                DogsNotificationsManager.shared.dispatchNotificationsDogDetailsVC(body: body, hour: hour, minute: minute, isDaily: isDaily, day: day, month: month, identifier: identifier)
                onAction(ScheduleReminderAction.closeScreen)
            } else {
                onAction(ScheduleReminderAction.showError)
            }
        } else {
            onAction(ScheduleReminderAction.showError)
        }
    }
}
