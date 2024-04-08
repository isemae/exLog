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

	@Environment(\.modelContext) private var modelContext
	@StateObject private var dataModel = DataModel()

	var body: some Scene {
		let modelActor = ModelActor(modelContext: modelContext, dataModel: dataModel)

        WindowGroup {
			ContentView(modelContext: modelContext)
				.environmentObject(dataModel)
				.environmentObject(modelActor)
				.environmentObject(NavigationFlow.shared)
				.environment(\.locale, Locale.init(identifier: "ko_kr"))
				.environment(\.calendar.locale, Locale.init(identifier: "ko_kr"))
				.environment(\.timeZone, TimeZone.init(identifier: "Asia/Seoul")!)
        }
        .modelContainer(sharedModelContainer)
    }
}
