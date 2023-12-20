//
//  exLogApp.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import SwiftUI
import SwiftData

@main
struct exLogApp: App {
	@AppStorage("selectedYear") private var selectedYear: Int?

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
			Item.self,
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
			ContentView(selectedYear: $selectedYear)
				.environmentObject(DataModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
