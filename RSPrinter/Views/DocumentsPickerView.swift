//
//  DocumentsPickerView.swift
//  RSPrinter
//
//  Created by Rajasekhar on 11/04/25.
//

import Foundation
import SwiftUI

struct DocumentsPickerView: UIViewControllerRepresentable {
    
    let coordinator: SavedPrintersListViewModel
    
    private let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.text,.pdf, .image, .html])

    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.allowsMultipleSelection = false
        controller.shouldShowFileExtensions = true
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> SavedPrintersListViewModel {
        coordinator
    }
    
}
