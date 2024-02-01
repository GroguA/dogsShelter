//
//  NotificationCenter.swift
//  Shelter
//
//  Created by Александра Сергеева on 15.01.2024.
//

import UIKit
import UserNotifications

class NotificationCenter {
    static let shared = NotificationCenter()
    
    private init() {}
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private var isNotificationsAvailable = false
    
    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: { didAllow, error in
                    if didAllow {
                        self.isNotificationsAvailable = true
                    } else {
                        self.isNotificationsAvailable = false
                    }
                })
            case .denied:
                return
            case .authorized:
                self.isNotificationsAvailable = true
            default:
                return
            }
        })
    }
    
    func getAvailability() -> Bool {
        return isNotificationsAvailable
    }
    
    func dispatchNotificationsOneDogVC(body: String, hour: Int, minute: Int, isDaily: Bool, day: Int, month: Int, identifier: String) {
        let title = "Don't forget to do"
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current)
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        notificationCenter.add(request)
        
    }
    
    func getNotifications(array: @escaping (Array<UNNotificationRequest>) -> Void) {
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            DispatchQueue.main.async {
                array(requests)
            }
        })
    }
    
    func deleteNotification(identifier: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifier)
    }
    
}
