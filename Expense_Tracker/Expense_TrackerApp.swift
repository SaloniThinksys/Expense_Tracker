//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

@main
struct Expense_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ChoosePhotoVideoView()
        }
        .modelContainer(for: [TransactionModel.self])
    }
}
