//
//  View_Extensions.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    var safeArea: UIEdgeInsets {
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene){
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        
        return .zero
    }
    
    func format(date: Date, format: String) ->  String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func currencyString(_ value: Double, allowedDigit: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits =  allowedDigit
        
        return formatter.string(from: .init(value: value)) ?? ""
    }
    
    func total(_ transactions: [TransactionModel], category: CategoryModel) -> Double {
        return transactions.filter({ $0.category == category.rawValue }).reduce(Double.zero) { partialResult, transaction in
            return partialResult + transaction.amount
        }
    }
}

//extension LinearGradient {
//    static let purpleGradient = LinearGradient(
//        gradient: Gradient(colors: [Color.purple, Color.white.opacity(0.7)]),
//        startPoint: .topLeading,
//        endPoint: .bottomTrailing
//    )
//}
