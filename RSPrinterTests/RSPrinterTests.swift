//
//  RSPrinterTests.swift
//  RSPrinterTests
//
//  Created by Rajasekhar on 10/04/25.
//

import XCTest
import SwiftData
@testable import RSPrinter

@MainActor final class RSPrinterTests: XCTestCase {

    var container: ModelContainer?
    var viewModel:SavedPrintersListViewModel?
    
    enum TestErros: String, Error {
        case invalidUrl = "Invalide Url"
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Printer.self, configurations: config)
        viewModel = SavedPrintersListViewModel(modelContext: container!.mainContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        container = nil
        viewModel = nil
    }
    
    func testEmptyList() throws {
        
        viewModel!.featchSavedPrinters()
        XCTAssertEqual(viewModel!.printers.count, 0)
    }
    
    func saveTestData() {
        
        guard let url = URL(string: "ipps://Raja-MacBook-Pro.local.:8632/ipp/print/save") else {
            return
        }
        let printer = UIPrinter(url: url)
        viewModel?.saveNew(printer: printer)
    }
    
    func testAddPrinter() throws {
        
        saveTestData()
        viewModel?.featchSavedPrinters()
        XCTAssertEqual(viewModel!.printers.count, 1)
        
    }
    
    func testDeletePrinter() throws {
        
        saveTestData()
        viewModel?.featchSavedPrinters()
        XCTAssertEqual(viewModel!.printers.count, 1)

        if let printer = viewModel?.printers.first {
            
            viewModel?.delete(printer: printer)
            viewModel?.featchSavedPrinters()
            XCTAssertEqual(viewModel!.printers.count, 0)
        }
        
    }
    
}

