//
//  NoteTabModel.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 02/04/25.
//

import SwiftUI

enum NoteTabModel: String {
    case speak = "Speak"
    case addnote = "Add Note"
    case attachment = "Attach"
    
    @ViewBuilder
    var noteTabContent:  some View{
        switch self {
        case .speak:
            Image(systemName: "microphone")
            Text(self.rawValue)
        case .addnote:
            Image(systemName: "pencil.and.list.clipboard")
            Text(self.rawValue)
        case .attachment:
            Image(systemName: "paperclip.circle.fill")
            Text(self.rawValue)
        }
    }
}
