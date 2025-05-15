//
//  ExpenseWidget.swift
//  ExpenseWidget
//
//  Created by Saloni Singh on 14/05/25.
//

import WidgetKit
import SwiftUI

struct ExpenseEntry: TimelineEntry {
    let date: Date
    let summary: ExpenseSummary
}

struct ExpenseProvider: TimelineProvider {
    func placeholder(in context: Context) -> ExpenseEntry {
        ExpenseEntry(date: Date(), summary: .init(dailyIncome: 0, dailyExpense: 0, monthlyIncome: 0, monthlyExpense: 0))
    }

    func getSnapshot(in context: Context, completion: @escaping (ExpenseEntry) -> Void) {
        let summary = SharedDataManager.shared.fetchSummary() ?? ExpenseSummary(dailyIncome: 0, dailyExpense: 0, monthlyIncome: 0, monthlyExpense: 0)
        completion(ExpenseEntry(date: Date(), summary: summary))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ExpenseEntry>) -> Void) {
        let summary = SharedDataManager.shared.fetchSummary() ?? ExpenseSummary(dailyIncome: 0, dailyExpense: 0, monthlyIncome: 0, monthlyExpense: 0)
        let entry = ExpenseEntry(date: Date(), summary: summary)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}


struct ExpenseWidgetEntryView : View {
    var entry: ExpenseProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today")
                .font(.caption)
                .bold()
                .foregroundColor(.gray)
            
            HStack {
                HStack{
                    Image(systemName: "arrow.up")
                        .font(.callout.bold())
                        .foregroundStyle(.green)
                        .frame(width: 25, height: 25)
                        .background{
                            Circle()
                                .fill(.green.opacity(0.25).gradient)
                        }
                    VStack{
                        Text("Income")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        Text(currencyString(entry.summary.dailyIncome))
                            .font(.caption2)
                    }
                }
                Spacer()
                HStack{
                    Image(systemName: "arrow.down")
                        .font(.callout.bold())
                        .foregroundStyle(.red)
                        .frame(width: 25, height: 25)
                        .background{
                            Circle()
                                .fill(.red.opacity(0.25).gradient)
                        }
                    VStack{
                        Text("Expense")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        Text(currencyString(entry.summary.monthlyExpense))
                            .font(.caption2)
                    }
                }
            }.font(.footnote)
            
            Divider()
            
            Text("This Month")
                .font(.caption)
                .bold()
                .foregroundColor(.gray)
            
            HStack {
                HStack{
                    Image(systemName: "arrow.up")
                        .font(.callout.bold())
                        .foregroundStyle(.green)
                        .frame(width: 25, height: 25)
                        .background{
                            Circle()
                                .fill(.green.opacity(0.25).gradient)
                        }
                    VStack{
                        Text("Income")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        Text(currencyString(entry.summary.monthlyIncome))
                            .font(.caption2)
                    }
                }
                Spacer()
                HStack{
                    Image(systemName: "arrow.down")
                        .font(.callout.bold())
                        .foregroundStyle(.red)
                        .frame(width: 25, height: 25)
                        .background{
                            Circle()
                                .fill(.red.opacity(0.25).gradient)
                        }
                    VStack{
                        Text("Expense")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        Text(currencyString(entry.summary.monthlyExpense))
                            .font(.caption2)
                    }
                }

            }.font(.footnote)
        }
        .padding()
    }
    
    func currencyString(_ value: Double, allowedDigit: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits =  allowedDigit
        
        return formatter.string(from: .init(value: value)) ?? ""
    }
}

struct ExpenseWidget: Widget {
    let kind: String = "ExpenseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ExpenseProvider()) { entry in
            ExpenseWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Expense Summary")
        .description("View your daily and monthly income and expenses.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}
//
//#Preview(as: .systemSmall) {
//    ExpenseWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
