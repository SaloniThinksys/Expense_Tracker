//
//  FilterTransactionView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 01/04/25.
//

import SwiftUI
import SwiftData

//custom view
struct FilterTransactionView<Content: View>: View {
    var content: ([TransactionModel]) -> Content
    
    @Query(animation: .snappy) private var  transactions: [TransactionModel]
    init(category: CategoryModel?, searchText: String, @ViewBuilder content: @escaping ([TransactionModel]) -> Content) {
        //custom predicate
        
        let rawValue =  category?.rawValue ?? ""
        let predicate = #Predicate<TransactionModel> { transaction in
            return transaction.title.localizedStandardContains(searchText) || transaction.remarks.localizedStandardContains(searchText) && (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        _transactions = Query(filter: predicate,sort: [SortDescriptor(\TransactionModel.dateAdded, order: .reverse)], animation: .snappy)
        
        self.content = content
    }
    
    //date filteration
    init(startDate: Date, endDate: Date, @ViewBuilder content: @escaping ([TransactionModel]) -> Content) {
        //custom predicate
        let predicate = #Predicate<TransactionModel> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
        }
        _transactions = Query(filter: predicate,sort: [SortDescriptor(\TransactionModel.dateAdded, order: .reverse)], animation: .snappy)
        
        self.content = content
    }
    
    var body: some View {
        content(transactions)
    }
}


