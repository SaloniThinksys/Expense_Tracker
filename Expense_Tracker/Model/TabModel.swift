//
//  TabModel.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

enum TabModel: String {
    case recents = "Recents"
    case search = "Filter"
    case charts = "Charts"
    case addnote = "AddNote"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent:  some View{
        switch self {
        case .recents:
            Image(systemName: "calendar")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .charts:
            Image(systemName: "chart.bar.xaxis")
            Text(self.rawValue)
        case .addnote:
            Image(systemName: "list.clipboard.fill")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }
}
