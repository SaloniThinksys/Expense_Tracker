//
//  UndoableModel.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 07/04/25.
//

import Foundation
import SwiftUI

//class UndoableModel: ObservableObject {
//    @Published var addNoteText: String = "" {
//        willSet {
//            registerUndo(text: addNoteText, image: image)
//        }
//    }
//    
//    @Published var image: UIImage = UIImage() {
//        willSet {
//            registerUndo(text: addNoteText, image: image)
//        }
//    }
//    
//    var undoManager: UndoManager?
//    
//    private func registerUndo(text: String, image: UIImage) {
//        let oldText = text
//        let oldImage = image
//        
//        undoManager?.registerUndo(withTarget: self) { target in
//            let currentText = target.addNoteText
//            let currentImage = target.image
//            
//            target.addNoteText = oldText
//            target.image = oldImage
//            
//            // Register redo
//            target.registerUndo(text: currentText, image: currentImage)
//        }
//    }
//}


class UndoableModel: ObservableObject {
    @Published var addNoteText: String = ""
    @Published var image: UIImage = UIImage()

    var undoManager: UndoManager?

    func setInitialValues(text: String, image: UIImage) {
        addNoteText = text
        self.image = image
    }

    func updateText(_ newText: String) {
        let oldText = addNoteText
        guard oldText != newText else { return }

        undoManager?.registerUndo(withTarget: self) { target in
            target.updateText(oldText)
            target.undoManager?.registerUndo(withTarget: target) { redoTarget in
                redoTarget.updateText(newText)
            }
        }

        addNoteText = newText
    }

    func updateImage(_ newImage: UIImage) {
        let oldImage = image
        guard oldImage != newImage else { return }

        undoManager?.registerUndo(withTarget: self) { target in
            target.updateImage(oldImage)
            target.undoManager?.registerUndo(withTarget: target) { redoTarget in
                redoTarget.updateImage(newImage)
            }
        }

        image = newImage
    }
}


