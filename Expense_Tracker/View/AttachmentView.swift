//
//  AttachmentView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 02/04/25.
//

import SwiftUI
import PhotosUI

struct AttachmentView: View {
    
    //properties for file attachments
    @State private var presentImporter = false
    @State private var selectedFileURL: URL?
    
    //properties for choose photo or videos
    @ObservedObject var viewModel: SharedImageViewModel
    @State private var showSheet: Bool = false
    
    //properties for take photo and videos
    @State private var image = UIImage()
    @State private var showCamera: Bool = false
    
    //properties for scan documents
    @State private var showDocScanner = false
    @State private var scannedDocumentImage: UIImage?
    
    //properties for scan text
    @State private var scannedText = ""
    @State private var showTextScanner = false
    @State private var showNoteView = false

    
    var body: some View {
        Menu{
            attachFile()
            choosePhotoVideo()
            takePhotoVideo()
            scanText()
            scanDoc()
            
        } label: {
            Image(systemName: "paperclip")
                .font(.caption)
                .bold()
                .foregroundStyle(appTint)
                //.padding()
        }
        .fileImporter(
            isPresented: $presentImporter,
            allowedContentTypes: [.pdf, .jpeg, .png, .plainText, .rtf],
            allowsMultipleSelection: false
        ) { result in  // for file attachments
            switch result {
                case .success(let urls):
                    if let url = urls.first {  // Extract the first file
                        selectedFileURL = url
                        print("Selected File: \(url)")
                    }
                case .failure(let error):
                    print("File Import Error: \(error.localizedDescription)")
                }
        }
        .sheet(isPresented: $showSheet) {  // to choose photo and videos
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.image)
        }
        .sheet(isPresented: $showCamera) { // to take or record photo and videos
            ImagePicker(sourceType: .camera, selectedImage: self.$image)
        }
        .sheet(isPresented: $showNoteView) {
            AddNoteView(initialText: scannedText, viewModel: viewModel)
        }
        .sheet(isPresented: $showTextScanner) {
            TextScannerView(scannedText: $scannedText)
        }
        .sheet(isPresented: $showDocScanner) {
            DocumentScannerView { image in
                scannedDocumentImage = image
                viewModel.image = image
                showNoteView = true
            }
        }
        .onChange(of: scannedText) {
            if !scannedText.isEmpty {
                showNoteView = true
            }
        }

    }
    
    @ViewBuilder
    func attachFile() -> some View {
        Button("Attach Files") {
            presentImporter = true
        }
    }
    
    @ViewBuilder
    private func choosePhotoVideo() -> some View {
        Button("Choose Photo or Video") {
            showSheet = true
        }

    }
    
    @ViewBuilder
    func takePhotoVideo() -> some View {
        Button("Take Photo or Video") {
            showCamera = true
        }
    }
    
    @ViewBuilder
    func scanDoc() -> some View {
        Button("Scan Document") {
            showDocScanner = true
        }
    }
    
    @ViewBuilder
    func scanText() -> some View {
        Button("Scan Text") {
            showTextScanner = true
        }
    }
    
}

