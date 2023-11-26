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
	
	@State private var string = "0"
	@State private var currentCurrency = "¥"
	@State private var isShowingKeypad = false
	@State private var foldedDates: [Date: Bool] = [:]
	@State private var ampm: Bool = false
	
	@State var dateFrames: [CGRect] = []
	
	var body: some View {
		let bounds = UIScreen.main.bounds
		var screenWidth = bounds.size.width
		var screenHeight = bounds.size.height
		let groupedByDate = items.sortedByDate()
		//			var dayTotal: Int = 0
		
		NavigationSplitView {
			ScrollView {
				ForEach(groupedByDate.sorted(by: { $0.0 > $1.0}), id: \.0) { date, itemsInDate in
					let sortedItems = itemsInDate.sorted { $0.timestamp > $1.timestamp }
					let sumForDate = sortedItems.reduce(0) { $0 + $1.calculatedBalance }
					
					VStack(alignment: .leading, spacing: 0) {
						DateTitle(date: date, sumForDate: sumForDate, dateFrames: dateFrames)
							.padding(.bottom, 15)
							.transition(.move(edge: .top).combined(with: .opacity))
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.3)) {
									foldedDates[date, default: false].toggle()
									try? modelContext.save()

								}
							}
						if !foldedDates[date, default: false] {
							VStack(alignment: .center) {
								ForEach(sortedItems, id: \.id) { item in
									SpendingItem(currentCurrency: $currentCurrency, ampm: $ampm, item: item)
										.opacity(opacityForItem(item))
								}
							}
							.padding([.bottom], 25)
						}
					}
				}
				.frame(width: screenWidth)
				
			}
			.onTapGesture(perform: {
				withAnimation(.spring(response: 0.2, dampingFraction: 1.0)) {
					isShowingKeypad = false
				}
			})
			.coordinateSpace(name: "container")
			.onPreferenceChange(FramePreference.self, perform: {
				dateFrames = $0.sorted(by: { $0.minY < $1.minY })
			})
			.toolbar {
				//	ToolbarItem(placement: .navigationBarTrailing) {
				//		EditButton()
				//	}
				ToolbarItem {
					Button(action: addItem) {
						Label("Add Item", systemImage: "plus")
					}
				}
				
				//										dev only
				//					ToolbarItem(placement: .navigationBarLeading) {
				//						Button(action: deleteAll) {
				//							Label("delete All", systemImage:"trash")
				//						}
				//					}
			}
		} detail: {
		}
		
		VStack {
			Divider()
			InputArea(
				currentCurrency: currentCurrency,
				string: string.formatNumber(),
				isShowingKeypad: $isShowingKeypad,
				onSwipeUp: {
					self.addItem()
				},
				onSwipeDown: {
					self.deleteFirst()
				}
			)
			Keypad(string: $string)
				.frame(height: isShowingKeypad ? screenHeight / 3.5 : 0)
				.opacity(isShowingKeypad ? 1 : 0)
				.offset(y: isShowingKeypad ? 0 : screenHeight)
				.transition(.move(edge: .bottom))
				.padding()
		}
		.font(.largeTitle)
		.onAppear {
			// print("Loading Exchange rate data...")
						 fetchData()
		}
		
	}
	
	func opacityForItem(_ item: Item) -> Double {
		let minOpacity: Double = 0.5
		
		if let index = items.firstIndex(of: item) {
			let opacity = Double(index + 1) / Double(items.count)
			return max(opacity, minOpacity)
		}
		return 1.0
	}
	
	func addItem() {
		withAnimation(.easeInOut(duration: 0.2)) {
			if let balance = Double(string) {
				if string != "0" {
					let newItem = Item(timestamp: Date(), balance: String(balance))
					modelContext.insert(newItem)
					UISelectionFeedbackGenerator().selectionChanged()
					string = "0"
				}
			}
		}
		try? modelContext.save()
	}
	
	func deleteItems(offsets: IndexSet) {
		withAnimation() {
			for index in offsets {
				modelContext.delete(items[index])
				try? modelContext.save()
			}
		}
	}
	
	func deleteFirst() {
		withAnimation() {
			if let firstGroup = items.sortedByDate().first,
			   let recentItem = firstGroup.1.first {
				modelContext.delete(recentItem)
				UISelectionFeedbackGenerator().selectionChanged()
				try? modelContext.save()
			}
		}
	}
	
	// for dev only
	func deleteAll() {
		try? modelContext.fetch(FetchDescriptor<Item>()).forEach { modelContext.delete($0)}
		try? modelContext.save()
	}
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
