//
//  FormData.swift
//  SimpleFormScreen
//
//  Created by Shrirang Zend on 07/03/25.
//


import Foundation

struct FormData: Codable, Equatable {
    var fullName: String = ""
    var email: String = ""
    var password: String = ""
    var dateOfBirth: Date = Date()
    var gender: String = "Other"
    var numPets: Int = 0
    var monthlySpending: Double = 0.0
    var age: Int? = nil
    var satisfaction: Double? = nil  
    var accountType: String = "Basic"
    var bio: String = ""
    var termsAccepted: Bool = false
}

enum Gender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    
    var id: String { self.rawValue }
}

enum AccountType: String, CaseIterable, Identifiable, Codable {
    case basic = "Basic"
    case premium = "Premium"
    case enterprise = "Enterprise"
    
    var id: String { self.rawValue }
}
