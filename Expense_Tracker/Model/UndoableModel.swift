//
//  UndoableModel.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 07/04/25.
//

import Foundation
import SwiftUI

class UndoableModel: ObservableObject {
    @Published var addNoteText: String = "" {
        willSet {
            registerUndo(text: addNoteText, image: image)
        }
    }
    
    @Published var image: UIImage = UIImage() {
        willSet {
            registerUndo(text: addNoteText, image: image)
        }
    }
    
    var undoManager: UndoManager?
    
    private func registerUndo(text: String, image: UIImage) {
        let oldText = text
        let oldImage = image
        
        undoManager?.registerUndo(withTarget: self) { target in
            let currentText = target.addNoteText
            let currentImage = target.image
            
            target.addNoteText = oldText
            target.image = oldImage
            
            // Register redo
            target.registerUndo(text: currentText, image: currentImage)
        }
    }
}
