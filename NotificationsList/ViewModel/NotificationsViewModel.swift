//
//  NotificationsViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.01.2024.
//

import Foundation
import UserNotifications

class NotificationsViewModel {
    
    var viewStateDidChange: (NotificationsState) -> () = { _ in } {
        didSet {
            guard let currentState = currentState else {
                return
            }
            viewStateDidChange(currentState)
        }
    }
    
    private var notifications = [NotificationModel]()
    
    private var currentState: NotificationsState? = nil  {
        didSet {
            if let currentState = currentState {
                viewStateDidChange(currentState)
            }
        }
    }
    
    private let dateFormatter = DateFormatter()
    
    func getNotifications() {
        NotificationCenter.shared.getNotifications(array: { requests in
            requests.forEach({ request in
                var notification: NotificationModel
                if let dog = DogStorageService.shared.getOneDogById(id: request.identifier) {
                    let trigger = request.trigger as? UNCalendarNotificationTrigger
                    if let date = trigger?.nextTriggerDate() {
                        let dateString = date.formatted(date: .numeric, time: .shortened)
                        notification = NotificationModel(body: request.content.body, date: dateString , dogName: dog.name, dogBreed: dog.breed, dogID: request.identifier, isSelected: false)
                        self.notifications.append(notification)
                    }
                }
            })
            self.currentState = .success(notifications: self.notifications)
        })
    }
    
    func onNotificationClicked(index: Int) {
        if case .success(let notifications) = currentState {
            notifications[index].isSelected = !notifications[index].isSelected
        }
    }
    
    
    func onDeleteNotificationTapped() {
        let selectedNotificationsIds = notifications.filter({ notifications in
            notifications.isSelected
        }).map { $0.dogID }
        
        NotificationCenter.shared.deleteNotification(identifier: selectedNotificationsIds)
        
        for id in selectedNotificationsIds {
            notifications.removeAll(where: { $0.dogID == id })
        }
        
        currentState = .success(notifications: notifications)
    }
}
