//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI
import UserNotifications

@main
struct Expense_TrackerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    requestNotificationPermission()
                }
        }
        .modelContainer(for: [TransactionModel.self])
    }
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error.localizedDescription)")
        } else {
            print("Notification granted: \(granted)")
        }
    }
}


