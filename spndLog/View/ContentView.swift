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

	@StateObject private var dataModel = DataModel()
	@State private var string = "0"
	@State private var isShowingKeypad = false
	@State private var scrollViewProxy: ScrollViewProxy? = nil
	@State private var height = CGFloat.zero
	@State private var topTrigger = false
	
	var body: some View {
		var screenWidth = UIScreen.main.bounds.size.width
		var screenHeight = UIScreen.main.bounds.size.height
		ZStack {
			NavigationSplitView {
				SpendingList(
					items: items,
					onTap: {
						try? modelContext.save()
					}
				)
				.environmentObject(dataModel)
				.onTapGesture(perform: {
					isShowingKeypad = false
				})
				.safeAreaInset(edge: .bottom, spacing: 0) {
					VStack(spacing: 0) {
						InputArea(
							isShowingKeypad: $isShowingKeypad,
							string: string.formatNumber(), 
							onSwipeUp: { addItem() },
							onSwipeDown: { deleteFirst() })
						
						.environmentObject(dataModel)
						//							.background(GeometryReader {
						//								Color.clear
						//									.edgesIgnoringSafeArea(.bottom)
						//									.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
						//							})
						//							.onPreferenceChange(ViewHeightKey.self) {
						//								self.height = $0 + 10
						//							}
						if isShowingKeypad {
							Keypad(string: $string,
								   onSwipeUp: { self.addItem() },
								   onSwipeDown: { self.deleteFirst() })
								.padding([.leading, .trailing])
								.font(.largeTitle)
						}
					}
					.background()
				}
				.toolbar {}
			} detail: {}
		}
	}
	
	func scrollToTop() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
			topTrigger.toggle()
		}
	}
//	}
	
//	struct ViewHeightKey: PreferenceKey {
//		typealias Value = CGFloat
//		static var defaultValue = CGFloat.zero
//		static func reduce(value: inout Value, nextValue: () -> Value) {
//			value += nextValue()
//		}
//	}
	
	func addItem() {
			if let balance = Double(string) {
				if string != "0" {
					let newItem = Item(date: Date(), balance: String(balance), currency: dataModel.currentCurrency.symbol)
					let currentDate = Calendar.current.startOfDay(for: Date())
					withAnimation(.easeOut(duration: 0.2)) {
						dataModel.foldedItems[currentDate] = false
					}
					DispatchQueue.main.async {
						modelContext.insert(newItem)
						
						withAnimation(.easeOut(duration: 0.2)) {
							do {
								try modelContext.save()
							} catch {
								print("error saving context \(error)")
							}
						}
						UISelectionFeedbackGenerator().selectionChanged()
					}
					string = "0"
					scrollToTop()
				}
			}
		}
	
	func deleteFirst() {
		if let firstGroup = items.sortedByDate().first,
		   let recentItem = firstGroup.1.first {
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
				print(items)
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
