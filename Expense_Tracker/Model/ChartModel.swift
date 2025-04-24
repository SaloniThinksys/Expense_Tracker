//
//  ChartModel.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 01/04/25.
//

import SwiftUI

struct ChartModel: Identifiable {
    let id: UUID = .init()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpense: Double
}

struct ChartCategory: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var category: CategoryModel
}
