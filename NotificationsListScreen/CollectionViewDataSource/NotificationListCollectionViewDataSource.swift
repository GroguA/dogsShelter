//
//  NotificationListCollectionViewDataSource.swift
//  Shelter
//
//  Created by Александра Сергеева on 24.07.2024.
//

import UIKit

final class NotificationListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var notifications: [NotificationModel] = []
    
    func setNotifications(_ notifications: [NotificationModel]) {
        self.notifications = notifications
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NotificationCollectionViewCell.identifier,
            for: indexPath) as? NotificationCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let notification = notifications[indexPath.item]
        cell.fillCell(with: notification)
        
        return cell
    }
}
