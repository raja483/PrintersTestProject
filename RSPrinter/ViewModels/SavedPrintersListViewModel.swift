//
//  SavedPrintersListViewModel.swift
//  RSPrinter
//
//  Created by Rajasekhar on 11/04/25.
//

import Foundation
import UIKit
import SwiftData

class SavedPrintersListViewModel: NSObject, ObservableObject {
    
    @Published var isPrintInprogress: Bool = false
    @Published var showPrintSuccessAlert: Bool = false
    @Published var printers: [Printer] = []
    
    var modelContext: ModelContext
    
    private var printerSelected: UIPrinter?

    init(modelContext: ModelContext) {
        
        self.modelContext = modelContext
        
        super.init()
        self.featchSavedPrinters()
    }
    
    // Connet with Printer
    func connectPrinter(printer: Printer) async -> Bool {
        guard let url = URL(string: printer.url) else {
            return false
        }
        
        printerSelected = await UIPrinter(url: url)
        let isConnected = await printerSelected?.contactPrinter() ?? false
        updateProgress(inProgress: isConnected)
        return isConnected
    }
    
    func updateProgress(inProgress: Bool) {
        DispatchQueue.main.async{[weak self] in
            self?.isPrintInprogress = true
        }
    }
    
    //Print function
    func printDocument(fileUrl: URL) {
        
        if UIPrintInteractionController.isPrintingAvailable, let printer = printerSelected {
            
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.outputType = .general
            printInfo.jobName = fileUrl.lastPathComponent
            
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.printingItem = fileUrl
            
            printController.print(to: printer) {[weak self] controller, status, error in
                
                self?.isPrintInprogress = false
                self?.showPrintSuccessAlert = true

            }
            
        } else {
            print("Printing is not available on this device.")
        }
    }
    
    //MARK: - Swift Data
    
    func featchSavedPrinters() {
        
        do {
            let descriptor = FetchDescriptor<Printer>(sortBy: [SortDescriptor(\.name)])
            printers = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
        
    }
    
    func saveNew(printer: UIPrinter) {
        
        let name = printer.displayName
        let url = printer.url.absoluteString
        let location = printer.displayLocation ?? ""
        
        let newPrinter = Printer(url: url, name: name, location: location)
        modelContext.insert(newPrinter)
        self.featchSavedPrinters()
        
    }
    
    func delete(printer: Printer) {
        
        modelContext.delete(printer)
        self.featchSavedPrinters()
        
    }
    
}
//MARK: - UIDocumentPickerDelegate

extension SavedPrintersListViewModel: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else {
            return
        }
        
        printDocument(fileUrl: url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.isPrintInprogress = false
    }
    
    
    
}
