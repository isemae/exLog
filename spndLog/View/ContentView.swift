//
//  ContentView.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
//	@Query(filter: #Predicate<Items> { items in
//		!items.isFolded
//	})
	@StateObject private var dataModel = DataModel.init()
	@State private var string = "0"
	@State private var isShowingKeypad = false
	@State private var height = CGFloat.zero
	
	var body: some View {
		var screenWidth = UIScreen.main.bounds.size.width
		var screenHeight = UIScreen.main.bounds.size.height
		
		DayListView(items: items, onTap: { try? modelContext.save() })
			.safeAreaInset(edge: .bottom, spacing: 0) {
				OverlayKeypad()
			}
			.contentMargins(.trailing, 5, for: .scrollContent)
			.ignoresSafeArea( edges:  isShowingKeypad ? .Element() : .bottom)
			.environmentObject(dataModel)
	}
	
	func OverlayKeypad() -> some View {
		VStack(spacing: 0) {
			InputArea(
				isShowingKeypad: $isShowingKeypad,
				string: string,
				onSwipeUp: { addItem() },
				onSwipeDown: { deleteFirst() }
			)
			.environmentObject(dataModel)
			.onChange(of: string, perform: { newValue in
				if string.count > 9 {
					string = String(string.prefix(9))
				}
			})
			
			if isShowingKeypad {
				Keypad(string: $string,
					   onSwipeUp: { self.addItem() },
					   onSwipeDown: { self.deleteFirst() })
				.font(.largeTitle)
			}
		}
		.safeAreaOverlay(alignment: .bottom, edges: .bottom)
	}
	
	func addItem() {
			if let balance = Double(string) {
				if string != "0" {
					let newItem = Item(date: Date(), balance: String(balance), currency: dataModel.currentCurrency)
					let currentDate = Calendar.current.startOfDay(for: Date())
					withAnimation(.easeOut(duration: 0.2)) {
						dataModel.foldedItems[currentDate] = false
					}
					
					DispatchQueue.main.async {
						modelContext.insert(newItem)
						withAnimation(.easeOut(duration: 0.2)) {
							do {
								try modelContext.save()
								for (index, element) in items.enumerated() {
									print("items: \(index) \(element.calculatedBalance)")
								}
							} catch {
								print("error saving context \(error)")
							}
						}
						UISelectionFeedbackGenerator().selectionChanged()
					}
					string = "0"
				}
			}
		}
	
	func deleteFirst() {
		if let firstGroup = items.sortedByDate().first,
		   let recentItem = firstGroup.1.first {
			let currentDate = Calendar.current.startOfDay(for: Date())
			if dataModel.foldedItems[currentDate] == true {
				withAnimation(.easeOut(duration: 0.2)) {
					dataModel.foldedItems[currentDate] = false
				}
			}
			DispatchQueue.main.async {
					modelContext.delete(recentItem)
				withAnimation(.easeOut(duration: 0.2)) {
					do {
						try modelContext.save()
					} catch {
						print("error saving context \(error)")
					}
				}
				UISelectionFeedbackGenerator().selectionChanged()
				print(items.last?.balance)
			}
		}
	}
	
	func deleteItems(offsets: IndexSet) {
		DispatchQueue.global().async {
//			withAnimation() {
				for index in offsets {
					modelContext.delete(items[index])
					try? modelContext.save()
				}
//			}
		}
	}

	// for dev only
	func deleteAll() {
		try? modelContext.fetch(FetchDescriptor<Item>()).forEach { modelContext.delete($0)}
		try? modelContext.save()
	}
	
	
}


//	let fetchItemsDescriptor = FetchDescriptor<Items>(sortBy: [SortDescriptor(\.date, order: .reverse), SortDescriptor(\.isFolded)])
//
//	let unFoldedItems = FetchDescriptor<Item>(predicate: #Predicate { item in
//		items.isFolded})
//	do {
//		let items = try modelContext.fetch(fetchItemsDescriptor)
//		for item in items {
//			print("Found \(item.balance)")
//		}
//	} catch {
//		print("Failed to load Item model")
//	}


#Preview {
    ContentView()
		.modelContainer(for: [Item.self], inMemory: true)
		.environmentObject(DataModel())
}
