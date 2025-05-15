//
//  TabModel.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case recents = "Recents"
    case search = "Filter"
    case charts = "Charts"
    case addnote = "AddNote"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .recents:
            return "calendar"
        case .search:
            return "magnifyingglass"
        case .charts:
            return "chart.bar.xaxis"
        case .addnote:
            return "note.text"
        case .settings:
            return "gearshape"
        }
    }
}
