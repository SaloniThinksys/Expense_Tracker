//
//  TransactionModel.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI
import SwiftData

@Model
class TransactionModel {
    //propeties
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var category: String  //differentiates btw income and expense
    var tintColor: String  // used to give a random color to each transaction view
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: CategoryModel, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    //extracting color value from tintcolor
    @Transient
    var color: Color {
        return tints.first(where: { $0.color == tintColor })?.value ?? appTint
    }
    
    @Transient
    var tint: TintColor? {
        return tints.first(where: { $0.color == tintColor })
    }
    
    @Transient
    var rawCategory: CategoryModel? {
        return CategoryModel.allCases.first(where: {category == $0.rawValue})
    }
}

//sample transactions for UI building
//var sampleTransactions: [TransactionModel] = [
//    .init(title: "Magic Keyboard", remarks: "Apple Product", amount: 129, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
//    .init(title: "Apple Music", remarks: "Subscription", amount: 10.99, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
//    .init(title: "iCloud", remarks: "Subscription", amount: 1.99, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
//    .init(title: "Payment", remarks: "Payment Recieved", amount: 2229, dateAdded: .now, category: .income, tintColor: tints.randomElement()!),
//]
