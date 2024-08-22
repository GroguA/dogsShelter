//
//  DateUtils.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.10.2023.
//

import Foundation

class DateUtils {
    static let shared = DateUtils()
    
    private init() {}
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    func getDogAgeInYears(dateOfBirth: String) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        guard let dateOfBirth = dateFormatter.date(from: dateOfBirth), let age = calendar.dateComponents([.year], from: dateOfBirth, to: currentDate).year else {
            return "0"
        }
        
        return String(age)
    }
    
    
    func getCurrentDate()  -> String {
        return dateFormatter.string(from: Date())
    }
    
}
