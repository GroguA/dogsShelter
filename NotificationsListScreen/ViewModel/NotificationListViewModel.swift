//
//  NotificationsViewModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.01.2024.
//

import Foundation
import UserNotifications

protocol INotificationListViewModel {
    var viewStateDidChange: (NotificationsState) -> () { get set }
    func getNotifications()
    func onNotificationClicked(index: Int)
    func onDeleteNotificationTapped()
}

final class NotificationListViewModel {
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
    
    init() {
        self.getNotifications()
    }
    
}

extension NotificationListViewModel: INotificationListViewModel {
    func getNotifications() {
        DogsNotificationsManager.shared.getNotificationRequests(onSuccess: { requests in
            requests.forEach({ request in
                var notification: NotificationModel
                if let dog = DogStorageService.shared.getOneDogById(id: request.identifier) {
                    let trigger = request.trigger as? UNCalendarNotificationTrigger
                    if let date = trigger?.nextTriggerDate() {
                        let dateString = date.formatted(date: .numeric, time: .shortened)
                        notification = NotificationModel(
                            body: request.content.body,
                            date: dateString,
                            dogName: dog.name, 
                            dogBreed: dog.breed,
                            dogID: request.identifier,
                            isSelected: false
                        )
                        self.notifications.append(notification)
                    }
                }
            })
            if !self.notifications.isEmpty {
                self.currentState = .success(
                    notifications: self.notifications,
                    atLeastOneNotificationSelected: false
                )
            } else {
                self.currentState = .empty
            }
        })
    }
    
    func onNotificationClicked(index: Int) {
        notifications[index].isSelected = !notifications[index].isSelected
        currentState = .success(
            notifications: notifications,
            atLeastOneNotificationSelected: notifications.contains(where: { $0.isSelected })
        )
    }
    
    
    func onDeleteNotificationTapped() {
        let selectedNotificationsIds = notifications.filter({ notifications in
            notifications.isSelected
        }).map { $0.dogID }
        
        DogsNotificationsManager.shared.deleteNotifications(identifiers: selectedNotificationsIds)
        
        for id in selectedNotificationsIds {
            notifications.removeAll(where: { $0.dogID == id })
        }
        
        if notifications.isEmpty {
            currentState = .empty
        } else {
            currentState = .success(notifications: notifications, atLeastOneNotificationSelected: false)
        }
    }
}
