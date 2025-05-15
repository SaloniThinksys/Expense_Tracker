//
//  TransactionCardView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

struct TransactionCardView: View {
    @Environment(\.modelContext) private var context
    var transaction: TransactionModel
    var showsCategory: Bool = false
    var body: some View {
        HStack(spacing: 12){
            Text("\(transaction.title.prefix(1))")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 45, height: 45)
                .background(transaction.color.gradient, in: .circle)
            
            VStack(alignment: .leading, spacing: 4){
                Text(transaction.title)
                    .foregroundStyle(Color.primary)
                
                Text(transaction.remarks)
                    .font(.caption)
                    .foregroundStyle(Color.primary.secondary)
                
                Text(format(date: transaction.dateAdded, format: "dd - MM - yyyy"))
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                if showsCategory {
                    Text(transaction.category)
                        .font(.caption2)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .foregroundStyle(.white)
                        .background(transaction.category == CategoryModel.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
                }
                
            }
            .lineLimit(1)
            .hSpacing(.leading)
            
            Text(currencyString(transaction.amount, allowedDigit: 2))
                .fontWeight(.semibold)
            
            // Delete Button
            Button(action: {
                deleteTransaction()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.white.opacity(0.8), in: Circle())
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    private func deleteTransaction() {
        context.delete(transaction)
        try? context.save() // Save after deletion
    }
}

#Preview {
    ContentView()
}
