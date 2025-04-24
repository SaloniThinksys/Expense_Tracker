//
//  SearchView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI
import Combine

struct SearchView: View {
    //view properties
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    @State private var selectedCategory: CategoryModel? = nil
    let searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(spacing: 12){
                    FilterTransactionView(category: selectedCategory, searchText: filterText){ transaction in
                        ForEach(transaction){ transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
                .padding(15)
            }
            .overlay(content: {
                ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1 : 0)
            })
            .onChange(of: searchText, { oldValue, newValue in
                if newValue.isEmpty{
                    filterText = ""
                }
                searchPublisher.send(newValue)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                filterText = text
                print(text)
            })
            .searchable(text: $searchText)
            .navigationTitle("Search")
            .background(.gray.opacity(0.15))
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    ToolBarContent()
                }
            }
        }
    }
    
    @ViewBuilder
    func ToolBarContent() -> some View {
        Menu{
            Button {
                selectedCategory = nil
            } label: {
                HStack{
                    Text("Both")
                    
                    if selectedCategory == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
            ForEach(CategoryModel.allCases, id: \.rawValue) { category in
                Button {
                    selectedCategory = category
                } label: {
                    HStack{
                        Text(category.rawValue)
                        
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "slider.vertical.3")
        }
    }
    
    @ViewBuilder
    func TransactionRow(transaction: TransactionModel) -> some View {
        NavigationLink(destination: TransactionView(editTransaction: transaction)) {
            TransactionCardView(transaction: transaction, showsCategory: true)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SearchView()
}
