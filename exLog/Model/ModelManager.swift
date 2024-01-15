//
//  ModelManager.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/11/24.
//

import Foundation
import SwiftData
import SwiftUI

class ModelActor: ObservableObject {
	@Environment(\.modelContext) private var modelContext
	private var dataModel: DataModel

	init(modelContext: ModelContext, dataModel: DataModel) {
		self.dataModel = dataModel
	}

	func saveContext() {
		do {
			try modelContext.save()
			UISelectionFeedbackGenerator().selectionChanged()
		} catch {
			print("Error saving context: \(error)")
			UINotificationFeedbackGenerator().notificationOccurred(.warning)
		}
	}

	func updateFoldedDate() {
		let currentDate = Calendar.current.startOfDay(for: Date())
		if dataModel.foldedItems[currentDate] == true {
			dataModel.foldedItems[currentDate] = false
		}
	}

	func addItem(string: String) {
		if let balance = Double(string), string != "0" {
			let newItem = Item(date: Date(), balance: String(balance), currency: dataModel.currentCurrency)
			modelContext.insert(newItem)
			saveContext()
			updateFoldedDate()
		}
	}

	func deleteFirst(items: [Item]) async {
		if let firstGroup = items.sortedByDate().first,
		   let recentItem = firstGroup.1.first {
				withAnimation(.easeOut(duration: 0.2)) {
					modelContext.delete(recentItem)
					try? modelContext.save()
					updateFoldedDate()
				}
		}
	}

	func deleteItems(items: [Item], offsets: IndexSet) async {
		DispatchQueue.global().async {
			for index in offsets {
				self.modelContext.delete(items[index])
				try? self.modelContext.save()
			}
		}
	}

	// for dev only
	func deleteAll() {
		try? modelContext.fetch(FetchDescriptor<Item>()).forEach { modelContext.delete($0)}
		try? modelContext.save()
	}
}
