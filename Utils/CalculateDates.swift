//
//  CalculateDogAge.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.10.2023.
//

import Foundation

class CalculateDates {
    static let shared = CalculateDates()
    
    private init() {}
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    func getDogAge(dateOfBirth: String) -> String {
        guard let dateOfBirth = dateFormatter.date(from: dateOfBirth) else {
            return "0"
        }
        let calendar = Calendar.current
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        
        let birthYear = calendar.component(.year, from: dateOfBirth)
        
        let age = currentYear - birthYear
        
        return String(age)
        
    }
    
    func getCurrentDate()  -> String {
        return dateFormatter.string(from: Date())
    }
}
