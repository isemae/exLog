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
	@Query private var items: [Item]

	@StateObject private var dataModel = DataModel()
	@State private var string = "0"
	@State private var isShowingKeypad = true
//	@State private var foldedDates: [Date: Bool] = [:]
	
	
	@State var dateFrames: [CGRect] = []
	var body: some View {
		let bounds = UIScreen.main.bounds
		var screenWidth = bounds.size.width
		var screenHeight = bounds.size.height
		
		
		NavigationSplitView {
			SpendingList(items: items, onTap: {/*try? modelContext.save()*/} )
				.environmentObject(dataModel)
				.onTapGesture(perform: {
					DispatchQueue.global().async {
						withAnimation(.spring(response: 0.2, dampingFraction: 1.0)) {
							isShowingKeypad = false
						}
					}
				})
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(action: addItem) {
							Label("Add Item", systemImage: "plus")
						}
					}
				}
		} detail: {}
		
		InputArea(
			isShowingKeypad: $isShowingKeypad,
			string: string.formatNumber(),
			onSwipeUp: { self.addItem()	},
			onSwipeDown: { self.deleteFirst() })
		.environmentObject(dataModel)
		
		LazyVStack{
			Keypad(string: $string)
				.opacity(isShowingKeypad ? 1 : 0)
				.padding([.leading, .trailing])
				.offset(y: isShowingKeypad ? 0 : screenHeight)
				.frame(height: isShowingKeypad ? screenHeight / 3 : 0)
				.font(.largeTitle)
		}
	}
	
	func addItem() {
		withAnimation(.easeOut(duration: 0.2)) {
			if let balance = Double(string) {
				if string != "0" {
					let newItem = Item(timestamp: Date(), balance: String(balance), currency: dataModel.currentCurrency.symbol)
					DispatchQueue.main.async {
						modelContext.insert(newItem)
						try? modelContext.save()
					}
					UISelectionFeedbackGenerator().selectionChanged()
					string = "0"
					
					let currentDate = Calendar.current.startOfDay(for: Date())
					dataModel.foldedItems[currentDate] = false
				}
			}
		}
	}
	
	func deleteFirst() {
		if let firstGroup = items.sortedByDate().first,
		   let recentItem = firstGroup.1.first {
			DispatchQueue.main.async {
				withAnimation() {
					modelContext.delete(recentItem)
					try? modelContext.save()
				}
				UISelectionFeedbackGenerator().selectionChanged()
			}
		}
	}
	
	func deleteItems(offsets: IndexSet) {
		DispatchQueue.global().async {
			withAnimation() {
				for index in offsets {
					modelContext.delete(items[index])
					try? modelContext.save()
				}
			}
		}
	}

	// for dev only
	func deleteAll() {
		try? modelContext.fetch(FetchDescriptor<Item>()).forEach { modelContext.delete($0)}
		try? modelContext.save()
	}
	
	func opacityForItem(_ item: Item) -> Double {
		let minOpacity: Double = 0.5
		
		if let index = items.firstIndex(of: item) {
			let opacity = Double(index + 1) / Double(items.count)
			return max(opacity, minOpacity)
		}
		return 1.0
	}
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)

}
