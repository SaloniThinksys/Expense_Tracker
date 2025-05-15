//
//  SummaryCalculator.swift
//  Expense_Tracker
//
//  Created by Saloni Singh on 14/05/25.
//

import Foundation
import SwiftData

struct SummaryCalculator {
    
    func computeSummary() async throws -> ExpenseSummary {
        let modelContainer = try ModelContainer(for: TransactionModel.self)
        let context = await modelContainer.mainContext
        let allTransactions = try context.fetch(FetchDescriptor<TransactionModel>())

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let thisMonth = calendar.component(.month, from: .now)

        let daily = allTransactions.filter { calendar.isDate($0.dateAdded, inSameDayAs: today) }
        let monthly = allTransactions.filter { calendar.component(.month, from: $0.dateAdded) == thisMonth }

        let dailyIncome = daily.filter { $0.rawCategory == .income }.reduce(0) { $0 + $1.amount }
        let dailyExpense = daily.filter { $0.rawCategory == .expense }.reduce(0) { $0 + $1.amount }

        let monthlyIncome = monthly.filter { $0.rawCategory == .income }.reduce(0) { $0 + $1.amount }
        let monthlyExpense = monthly.filter { $0.rawCategory == .expense }.reduce(0) { $0 + $1.amount }

        return ExpenseSummary(
            dailyIncome: dailyIncome,
            dailyExpense: dailyExpense,
            monthlyIncome: monthlyIncome,
            monthlyExpense: monthlyExpense
        )
    }
}

