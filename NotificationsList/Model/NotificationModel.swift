//
//  NotificationModel.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.01.2024.
//

import Foundation

class NotificationModel {
    let body: String
    let date: String
    let dogName: String
    let dogBreed: String
    let dogID: String
    var isSelected: Bool
    
    init(body: String, date: String, dogName: String, dogBreed: String, dogID: String, isSelected: Bool) {
        self.body = body
        self.date = date
        self.dogName = dogName
        self.dogBreed = dogBreed
        self.dogID = dogID
        self.isSelected = isSelected
    }
}
