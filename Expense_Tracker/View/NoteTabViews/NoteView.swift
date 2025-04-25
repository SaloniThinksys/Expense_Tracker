//
//  AddNoteView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 02/04/25.
//

import SwiftUI

struct NoteView: View {
    //scannedText
    var initialText: String = ""
    
    @State private var addNoteText: String = ""
    @State private var copiedText: String? = nil
    @ObservedObject var viewModel: SharedImageViewModel
    
    //undo redo
    @Environment(\.undoManager) var undoManager
    @StateObject private var model = UndoableModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if model.image == UIImage() {
                    // If image is not selected, show only full screen TextEditor
                    TextEditor(text: $model.addNoteText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            model.undoManager = undoManager
                            model.image = viewModel.image
                            model.addNoteText = initialText
                        }
                } else {
                    Image(uiImage: model.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    TextEditor(text: $model.addNoteText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            model.undoManager = undoManager
                            model.image = viewModel.image
                            model.addNoteText = initialText
                        }
                }
                    
            }
            //.background(Color.gray.opacity(0.15))
            .navigationTitle("Add a Note")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        undoManager?.undo()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(appTint)
                            .disabled(!(undoManager?.canUndo ?? false))
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        undoManager?.redo()
                    } label: {
                        Image(systemName: "arrow.uturn.forward")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(appTint)
                            .disabled(!(undoManager?.canRedo ?? false))
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ToolBarContent()
                }
            }
            .overlay(
                copiedText != nil ?
                Text("Copied to clipboard!")
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                    .transition(.opacity)
                : nil, alignment: .bottom
            )
        }
    }
    
    @ViewBuilder
    func ToolBarContent() -> some View {
        Menu {
            Button {
                copyText(addNoteText)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            Button {
                shareNote(addNoteText)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.caption)
                .bold()
                .foregroundStyle(appTint)
        }
    }
    
    func copyText(_ note: String) {
        UIPasteboard.general.string = note
        copiedText = "Copied to clipboard!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copiedText = nil
        }
    }
    
    func shareNote(_ note: String) {
        let activityController = UIActivityViewController(activityItems: [note], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController?.present(activityController, animated: true)
        }
    }
    
}

//#Preview {
//    NoteView()
//}


