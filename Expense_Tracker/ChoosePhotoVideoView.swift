//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

struct ChoosePhotoVideoView: View {
    //visibility status
    @AppStorage("isFirsttime") private var isFirstTime: Bool = true
    //active tab
    @State private var activeTab: TabModel = .recents
    
    var body: some View {
        TabView(selection: $activeTab){
            RecentsView()
                .tag(TabModel.recents)
                .tabItem {TabModel.recents.tabContent}
            SearchView()
                .tag(TabModel.search)
                .tabItem {TabModel.search.tabContent}
            GraphsView()
                .tag(TabModel.charts)
                .tabItem {TabModel.charts.tabContent}
            AddNoteView()
                .tag(TabModel.addnote)
                .tabItem {TabModel.addnote.tabContent}
            SettingsView()
                .tag(TabModel.settings)
                .tabItem {TabModel.settings.tabContent}
        }
        .tint(appTint)
        .sheet(isPresented: $isFirstTime, content: {
            IntroScreenView()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    ChoosePhotoVideoView()
}
