//
//  NoteComponent.swift
//  Expense_Tracker
//
//  Created by Saloni Singh on 15/05/25.
//

import Foundation
import SwiftUI

enum NoteComponent: Identifiable, Equatable {
    case text(id: UUID, content: String)
    case image(id: UUID, image: UIImage)

    var id: UUID {
        switch self {
        case .text(let id, _), .image(let id, _):
            return id
        }
    }
}

