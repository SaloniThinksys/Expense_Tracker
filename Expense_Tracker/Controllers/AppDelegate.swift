//
//  NotificationDelegate.swift
//  Expense_Tracker
//
//  Created by Saloni Singh on 14/05/25.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // Set the delegate to self to handle foreground notifications
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Show notification even when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.banner, .sound]) // Show banner + sound
    }
}

