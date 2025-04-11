//
//  RSPrinterApp.swift
//  RSPrinter
//
//  Created by Rajasekhar on 10/04/25.
//

import SwiftUI
import SwiftData

@main
struct RSPrinterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Printer.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SavedPrintersListView(viewModel: SavedPrintersListViewModel(modelContext: sharedModelContainer.mainContext))
        }
        .modelContainer(sharedModelContainer)
    }
}
