//
//  AddNoteView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 02/04/25.
//

import SwiftUI

struct AddNoteView: View {
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
                    TextEditor(text: Binding(
                        get: { model.addNoteText },
                        set: { newValue in
                            model.updateText(newValue)
                        }
                    ))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            model.undoManager = undoManager
                            model.setInitialValues(text: initialText, image: viewModel.image)
                        }

                } else {
                    Image(uiImage: model.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    TextEditor(text: Binding(
                        get: { model.addNoteText },
                        set: { newValue in
                            model.updateText(newValue)
                        }
                    ))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            model.undoManager = undoManager
                            model.setInitialValues(text: initialText, image: viewModel.image)
                        }
                }
            }
            .onChange(of: viewModel.image) {
                model.updateImage(viewModel.image)
            }
            //.background(Color.gray.opacity(0.15))
            .navigationTitle("Add a Note")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    undoButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    redoButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ToolBarContent()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    AttachmentView(viewModel: viewModel)
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
    
    @ViewBuilder
    func undoButton() -> some View{
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
    
    @ViewBuilder
    func redoButton() -> some View{
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

