//
//  SettingsView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

struct SettingsView: View {
    //user properties
    @AppStorage("userName") private var userName: String = ""
    //app lock properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    
    var body: some View {
        NavigationStack{
            List{
                Section("UserName"){
                    TextField("iJUstine", text: $userName)
                }
                Section("App lock"){
                    Toggle("Enable App", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled{
                        Toggle("Lock When App Goes Background", isOn: $lockWhenAppGoesBackground)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
