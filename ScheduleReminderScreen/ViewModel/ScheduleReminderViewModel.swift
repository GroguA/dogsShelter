//
//  ScheduleReminderViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 16.01.2024.
//

import Foundation

protocol IScheduleReminderViewModel {
    var onAction: (ScheduleReminderAction) -> () { get set }
    func onScheduleReminderTapped(body: String?, date: Date?, isDaily: Bool)
}

protocol IScheduleReminderNavigation {
    func popScheduleReminderScreen()
}

final class ScheduleReminderViewModel: IScheduleReminderViewModel {
    var onAction: (ScheduleReminderAction) -> () = { _ in }
    
    private let id: String
    
    private let router: IScheduleReminderRouter
    
    init(id: String, router: IScheduleReminderRouter) {
        self.id = id
        self.router = router
    }
    
    func onScheduleReminderTapped(body: String?, date: Date?, isDaily: Bool) {
        if let body, let date {
           let hour = Calendar.current.component(.hour, from: date)
           let minute = Calendar.current.component(.minute, from: date)
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            if !body.isEmpty {
                DogsNotificationsManager.shared.dispatchNotificationsDogDetailsVC(
                    body: body,
                    hour: hour,
                    minute: minute,
                    isDaily: isDaily,
                    day: day,
                    month: month,
                    identifier: id
                )
                onAction(ScheduleReminderAction.closeScreen)
            } else {
                onAction(ScheduleReminderAction.showError)
            }
        } else {
            onAction(ScheduleReminderAction.showError)
        }
    }
}

extension ScheduleReminderViewModel: IScheduleReminderNavigation {
    func popScheduleReminderScreen() {
        router.popViewController()
    }
}
