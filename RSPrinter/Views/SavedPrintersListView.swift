//
//  ContentView.swift
//  RSPrinter
//
//  Created by Rajasekhar on 10/04/25.
//

import SwiftUI
import SwiftData

struct SavedPrintersListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showPrinterPicker: Bool = false
    @MainActor @State private var showDocumentPicker: Bool = false
    @MainActor @State private var showAlert: Bool = false
    
    @State private var alertTitle: String  = ""
    
    @ObservedObject var viewModel: SavedPrintersListViewModel
    
    var body: some View {
        ZStack{
            NavigationStack {
                
                List {
                    ForEach(viewModel.printers) { printer in
                        
                        Button {
                            self.connectPrinterAndShowDocumentPicker(printer)
                        } label: {
                            RSPrinterListCellView(name: printer.name, location: printer.location)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(.plain)
                .overlay(content: {
                    if viewModel.printers.isEmpty {
                        Text("No printer added yet. \nAdd one by tapping the plus button")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.orange)
                        
                    }
                })
                .toolbar {
                    ToolbarItem {
                        Button {
                            self.showPrinterPicker = true
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                        .fullScreenCover(isPresented: $showPrinterPicker) {
                            PrinterPickerView(isPresented: $showPrinterPicker, viewModel: viewModel)
                        }
                    }
                }
                .navigationTitle("Printers")
                .toolbarBackground(Color.navigationBarColor, for: .navigationBar)
                .sheet(isPresented: $showDocumentPicker) {
                    withAnimation(.easeIn) {
                        DocumentsPickerView(coordinator: viewModel)
                    }
                }
                .alert(alertTitle, isPresented: $showAlert) { }
                .alert("Print Job completed", isPresented: $viewModel.showPrintSuccessAlert) { }
            }
            
            if viewModel.isPrintInprogress {
                PrintInProgressView()
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewModel.delete(printer: viewModel.printers[index])
            }
        }
    }
    
    private func connectPrinterAndShowDocumentPicker(_ printer: Printer)  {
        Task {
            if await self.viewModel.connectPrinter(printer: printer) {
                self.showDocumentPicker = true
            }
            else {
                self.alertTitle = "Failed to connect printer"
                self.showAlert = true
            }
        }
        
    }
    
}

//MARK: - Preview

#Preview {
    
    // save sample data in swift data for preview only
    
    let printer = Printer(url: "", name: "Printer 1", location: "Hyderabad")
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: Printer.self, configurations: config)
    let context = modelContainer.mainContext
    context.insert(printer)
    
    // Return preview data
    return SavedPrintersListView(viewModel: SavedPrintersListViewModel(modelContext: context))
        .modelContainer(modelContainer)
}
