//
//  TextScannerController.swift
//  Expense_Tracker
//
//  Created by Saloni Singh on 25/04/25.
//

import Foundation
import SwiftUI
import VisionKit

struct TextScannerView: UIViewControllerRepresentable {
    @Binding var scannedText: String
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        try? scanner.startScanning()
        return scanner
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: TextScannerView

        init(_ parent: TextScannerView) {
            self.parent = parent
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            if case let .text(textItem) = item {
                parent.scannedText = textItem.transcript
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

