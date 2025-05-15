//
//  SharedDataManager.swift
//  Expense_Tracker
//
//  Created by Saloni Singh on 14/05/25.
//

import Foundation
import SwiftUI

struct ExpenseSummary: Codable {
    var dailyIncome: Double
    var dailyExpense: Double
    var monthlyIncome: Double
    var monthlyExpense: Double
}

class SharedDataManager {
    static let shared = SharedDataManager()
    private let suiteName = "group.com.thinksys.widget.shared"
    private let key = "expense_summary"

    func save(summary: ExpenseSummary) {
        if let data = try? JSONEncoder().encode(summary) {
            UserDefaults(suiteName: suiteName)?.set(data, forKey: key)
        }
    }

    func fetchSummary() -> ExpenseSummary? {
        guard let data = UserDefaults(suiteName: suiteName)?.data(forKey: key),
              let summary = try? JSONDecoder().decode(ExpenseSummary.self, from: data) else {
            return nil
        }
        return summary
    }
}
