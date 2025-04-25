//
//  DocumentScannerView.swift
//  Expense_Tracker
//
//  Created by Saloni Singh on 25/04/25.
//

import Foundation
import SwiftUI
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable {
    var completion: (UIImage) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var completion: (UIImage) -> Void

        init(completion: @escaping (UIImage) -> Void) {
            self.completion = completion
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true)

            if scan.pageCount > 0 {
                let image = scan.imageOfPage(at: 0)
                completion(image)
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
            print("Document scan failed: \(error.localizedDescription)")
        }
    }
}

