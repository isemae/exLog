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
	
	@State var dateFrames: [CGRect] = []
	var body: some View {
		var screenWidth = UIScreen.main.bounds.size.width
		var screenHeight = UIScreen.main.bounds.size.height
		GeometryReader { geo in
			ZStack {
				NavigationSplitView {
					SpendingList(items: items, onTap: { try? modelContext.save() } )
						.environmentObject(dataModel)
						.onTapGesture(perform: {
							isShowingKeypad = false
						})
					Color.clear.frame(height: height)
											.toolbar {
					//							ToolbarItem(placement: .navigationBarLeading) {
					//								Button(action: addItem) {
					//									Label("Add Item", systemImage: "plus")
					//								}
												}
					//						}
				} detail: {}
				
				LazyVStack(spacing: 0) {
					InputArea(
						isShowingKeypad: $isShowingKeypad,
						string: string.formatNumber(),
						onSwipeUp: { self.addItem()	},
						onSwipeDown: { self.deleteFirst() })
					.environmentObject(dataModel)
					.background(GeometryReader {
						Color.clear
							.edgesIgnoringSafeArea(.bottom)
							.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
					})
					.onPreferenceChange(ViewHeightKey.self) {
						self.height = $0 + 10
					}
					Keypad(string: $string)
						.opacity(isShowingKeypad ? 1 : 0)
						.padding([.leading, .trailing])
						.font(.largeTitle)
						.background()
					//			.frame(height: isShowingKeypad ? screenHeight / 3 : 0)
				}
				.offset(y: isShowingKeypad ? screenHeight / 4 : screenHeight / 1.7)
			}
			
		}
		
	}
	
	struct ViewHeightKey: PreferenceKey {
		typealias Value = CGFloat
		static var defaultValue = CGFloat.zero
		static func reduce(value: inout Value, nextValue: () -> Value) {
			value += nextValue()
		}
	}
	
	func addItem() {
			if let balance = Double(string) {
				if string != "0" {
					let newItem = Item(date: Date(), balance: String(balance), currency: dataModel.currentCurrency.symbol)
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
					
					let currentDate = Calendar.current.startOfDay(for: Date())
					dataModel.foldedItems[currentDate] = false
					scrollViewProxy?.scrollTo(0)
				}
			}
		}
	
	func deleteFirst() {
		if let firstItem = items.first {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
					modelContext.delete(firstItem)
				withAnimation(.easeOut(duration: 0.2)) {
					do {
						try modelContext.save()
					} catch {
						print("error saving context \(error)")
					}
				}
				UISelectionFeedbackGenerator().selectionChanged()
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
