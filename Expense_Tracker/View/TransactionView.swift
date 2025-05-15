//
//  NewExpenseView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 01/04/25.
//

import SwiftUI
import WidgetKit

struct TransactionView: View {
    //env properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var editTransaction: TransactionModel?
    
    //view properties
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: CategoryModel = .expense
    
    //random tint
    @State var tint: TintColor = tints.randomElement()!
    
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 15){
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                // preview transaction card view
                TransactionCardView(transaction: .init(
                    title: title.isEmpty ? "Title" : title,
                    remarks: remarks.isEmpty ? "Remarks" : remarks,
                    amount: amount,
                    dateAdded: dateAdded,
                    category: category,
                    tintColor: tint
                ))
                
                CustomSection("Title", "Magic Keyboard", value: $title)
                
                CustomSection("Remarks", "Apple Products", value: $remarks)
                
                //amount 7 category check box
                VStack(alignment: .leading, spacing: 10){
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing: 15){
                        TextField("0.0", value: $amount, formatter: numberFormatter)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(.background, in: .rect(cornerRadius: 10))
                            .frame(maxWidth: 120)
                            .keyboardType(.decimalPad)
                        
                        //custom check box
                        CategoryCheckBox()
                    }
                }
                
                //date picker
                VStack(alignment: .leading, spacing: 10){
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                }
            }
            .padding(15)
        }
        .navigationTitle("Add Transaction")
        .background(.gray.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
            }
        })
        .onAppear(perform: {
            if let editTransaction = editTransaction {
            //load all existing data from transaction
                title = editTransaction.title
                remarks = editTransaction.remarks
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory{
                    self.category = category
                }
                amount = editTransaction.amount
                if let tint = editTransaction.tint{
                    self.tint = tint
                }
                
            }
        })
    }
    
    //saving date
    func save() {
        //saving items to swiftData
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.category = category.rawValue
            editTransaction?.dateAdded = dateAdded
        }else{
            let transaction = TransactionModel(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            context.insert(transaction)
        }
        Task {
            do {
                //Save context BEFORE computing summary
                try context.save()

                let summary = try await SummaryCalculator().computeSummary()
                SharedDataManager.shared.save(summary: summary)
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                print("Failed to save context or compute summary: \(error)")
            }
        }
        
        sendTransactionNotification()
        
        //dismissing view
        dismiss()
    }
    
    @ViewBuilder
    func CustomSection(_ title: String,_ hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading,spacing: 10){
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            
            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        }
    }
    
    //custom Category Check box
    @ViewBuilder
    func CategoryCheckBox() -> some View {
        HStack(spacing: 10){
            ForEach(CategoryModel.allCases, id: \.rawValue){ category in
                HStack(spacing: 5){
                    ZStack{
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        
                        if self.category == category{
                            Image(systemName: "circle.fill")
                                .font(.title3)
                                .foregroundStyle(appTint)
                        }
                    }
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category =  category
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    //number formatter
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    //push notification
    func sendTransactionNotification() {
        let content = UNMutableNotificationContent()
        content.title = category == .income ? "New Income Added 💰" : "New Expense Recorded 💸"
        content.body = "\(title): \(currencyString(amount))"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification error: \(error.localizedDescription)")
            } else {
                print("✅ Local notification scheduled.")
            }
        }
    }

}

#Preview {
    NavigationStack{
        TransactionView()
    }
}
