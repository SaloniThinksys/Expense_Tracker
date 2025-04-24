//
//  GraphsView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI
import Charts
import SwiftData

struct GraphsView: View {
    //view propeties
    @Query(animation: .snappy) private var transactions: [TransactionModel]
    @State private var chartGroups: [ChartModel] = []

    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVStack(spacing: 10){
                    //chartview
                    chartSection
                    
                    ForEach(chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(format(date: group.date, format: "MM - yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)

                            CardView(income: group.totalIncome, expense: group.totalExpense)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .onAppear{
                //creating chart group
                createChartGroup()
            }
        }
    }
    
    private var chartSection: some View {
        ChartView()
            .frame(height: 200)
            .padding(10)
            .padding(.top, 10)
            .background(.background, in: .rect(cornerRadius: 10))
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        Chart{
            ForEach(chartGroups, id: \.id) { group in
                       let formattedDate = format(date: group.date, format: "MM - yy")

                       ForEach(group.categories, id: \.id) { chart in
                           BarMark(
                               x: .value("Month", formattedDate),  // Ensure String type
                               y: .value("Total Value", chart.totalValue)
                           )
                           .position(by: .value("Category", chart.category.rawValue)) // Ensure String
                           .foregroundStyle(by: .value("Category", chart.category.rawValue))
                       }
                   }
        }
        //making chart scrollable
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis{
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                
                AxisGridLine()
                AxisTick()
                AxisValueLabel{
                    Text(axisLabel(doubleValue))
                }
            }
        }
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
    
    func createChartGroup() {
        Task.detached(priority: .high) {
            let calendar = Calendar.current
            let groupedByDate = Dictionary(grouping: transactions) { transaction in
                let components = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                
                return components
            }
            
            //sorting groups by date
            let sortedGroup = groupedByDate.sorted {
                let date1 =  calendar.date(from: $0.key) ?? .init()
                let date2 =  calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let chartGroups = sortedGroup.compactMap { dict -> ChartModel? in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter({ $0.category == CategoryModel.income.rawValue})
                let expense = dict.value.filter({ $0.category == CategoryModel.expense.rawValue})
                
                let incomeTotalValue = total(income, category: .income)
                let expenseTotalValue = total(expense, category: .expense)
                
                return .init(
                    date: date,
                    categories: [
                        ChartCategory(totalValue: incomeTotalValue, category: .income),
                        ChartCategory(totalValue: expenseTotalValue, category: .expense)
                    ],
                    totalIncome: incomeTotalValue,
                    totalExpense: expenseTotalValue
                )
            }
            //ui must be updated on main thread
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = Int(value) / 1000
        
        return intValue < 1000 ? "\(intValue)" : "\(kValue)"
    }
}

#Preview {
    GraphsView()
}
