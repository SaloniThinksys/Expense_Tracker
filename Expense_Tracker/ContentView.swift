//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sharedImageVM = SharedImageViewModel()
    //visibility status
    @AppStorage("isFirsttime") private var isFirstTime: Bool = true
    //active tab
    @State private var tabSelection = 1
    @Namespace private var animation
    
    var body: some View {
        TabView(selection: $tabSelection){
            RecentsView()
                .tag(1)
                
            SearchView()
                .tag(2)
                
            GraphsView()
                .tag(3)
                
            AddNoteView(viewModel: sharedImageVM)
                .tag(4)
                
            SettingsView()
                .tag(5)
                
        }
        .overlay(alignment: .bottom){
            CustomTabBar(tabSelection: $tabSelection, animation: animation)
        }
        .tint(appTint)
        .sheet(isPresented: $isFirstTime, content: {
            IntroScreenView()
                .interactiveDismissDisabled()
        })
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
