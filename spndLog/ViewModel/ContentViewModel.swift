//
//  ContentViewModel.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/30/23.
//
//
//import Foundation
//import SwiftUI
//import SwiftData
//
//extension ContentView {
//	@Observable
//	class ContentViewModel {
//		var string: String
//		private var dataModel: DataModel
//		var modelContext: ModelContext
//		var items = [Item]()
//
//		init(modelContext: ModelContext) {
//			self.modelContext = modelContext
//		}
//		
//		func addItem(string: String) {
//			withAnimation(.easeOut(duration: 0.2)) {
//				if let balance = Double(string) {
//					if string != "0" {
//						let newItem = Item(timestamp: Date(), balance: String(balance), currency: dataModel.currentCurrency.symbol)
//						DispatchQueue.main.async {
//							self.modelContext.insert(newItem)
//							try? self.modelContext.save()
//						}
//						UISelectionFeedbackGenerator().selectionChanged()
//						self.string = "0"
//						
//						let currentDate = Calendar.current.startOfDay(for: Date())
//						dataModel.foldedItems[currentDate] = false
//					}
//				}
//			}
//		}
//		
//		func deleteFirst() {
//			if let firstGroup = items.sortedByDate().first,
//			   let recentItem = firstGroup.1.first {
//				DispatchQueue.main.async {
//					withAnimation() {
//						self.modelContext.delete(recentItem)
//						try? self.modelContext.save()
//					}
//					UISelectionFeedbackGenerator().selectionChanged()
//				}
//			}
//		}
//		
//		func deleteItems(offsets: IndexSet) {
//			DispatchQueue.global().async {
//				withAnimation() {
//					for index in offsets {
//						self.modelContext.delete(self.items[index])
//						try? self.modelContext.save()
//					}
//				}
//			}
//		}
//
//		// for dev only
//		func deleteAll() {
//			try? modelContext.fetch(FetchDescriptor<Item>()).forEach { modelContext.delete($0)}
//			try? modelContext.save()
//		}
//	}
//}
