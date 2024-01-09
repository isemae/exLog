//
//  exLogApp.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import SwiftUI
import SwiftData

@main
struct ExLogApp: App {
	@AppStorage("selectedYear") private var selectedYear: Int?

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
			Item.self, Location.self
        ])
		let itemModelConfiguration = ModelConfiguration(schema: Schema([Item.self]), isStoredInMemoryOnly: false)
		let locationModelConfiguration = ModelConfiguration(schema: Schema([Location.self]), isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [itemModelConfiguration, locationModelConfiguration])
        } catch {
          fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
			ContentView()
				.environmentObject(DataModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
