//
//  RSPrinterView.swift
//  RSPrinter
//
//  Created by Rajasekhar on 10/04/25.
//

import Foundation
import SwiftUI

struct PrinterPickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    var viewModel: SavedPrintersListViewModel
    
    @Environment(\.modelContext) var modelContext
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        let pickerController = UIPrinterPickerController(initiallySelectedPrinter: nil)
        pickerController.delegate = context.coordinator
        pickerController.present(animated: false) { printerVC, userSelected, error in
            
            // Printer selected, save the selected printer in swift data
            if userSelected, let printer = printerVC.selectedPrinter {
                viewModel.saveNew(printer: printer)
            }
            // Error handling
            else if let _ = error {
               
                
            }
            
        }
    }
    
    func makeCoordinator() -> PrinterPickerCoordinator {
        PrinterPickerCoordinator(self)
    }
    
}

//MARK: - Coordinator Implementation

class PrinterPickerCoordinator: NSObject, UIPrinterPickerControllerDelegate {
    
    let printerView: PrinterPickerView
    init(_ printerView: PrinterPickerView) {
        self.printerView = printerView
    }
    
    //MARK: - Printer Picker Controller Delegate
    func printerPickerControllerWillDismiss(_ printerPickerController: UIPrinterPickerController) {
        printerView.isPresented.toggle()
    }
    
}
