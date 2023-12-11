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
	@State private var isShowingKeypad = true
	@State private var height = CGFloat.zero
	
	let screenHeight = UIScreen.main.bounds.size.height
	let screenWidth = UIScreen.main.bounds.size.width
	
	var body: some View {
		if !items.isEmpty {
			DayListView(items: items, onTap: { try? modelContext.save() })
				.safeAreaInset(edge: .bottom, spacing: 0) {
					OverlayKeypad()
						.animation(.spring(response: 0.2, dampingFraction: 1.0))
						.transition(.move(edge: .bottom))
				}
				.ignoresSafeArea(edges: .bottom)
				.environmentObject(dataModel)
				.background(.bar)
		} else {
			InitialView()
		}
	}
	
	func OverlayKeypad() -> some View {
		VStack(spacing: 0) {
			InputArea(isShowingKeypad: $isShowingKeypad,
					  string: string,
					  onSwipeUp: { addItem() },
					  onSwipeDown: { deleteFirst() })
			.environmentObject(dataModel)
			.onChange(of: string, perform: { newValue in
				if string.count > 9 {
					string = String(string.prefix(9)) }})
			
			Keypad(string: $string, isShowing: $isShowingKeypad,
				   onSwipeUp: { self.addItem() },
				   onSwipeDown: { self.deleteFirst()})
			.font(.largeTitle)
			.disabled(!isShowingKeypad)
			.offset(y: isShowingKeypad ? 0 : screenHeight / 2)
		}
		.background(.bar)
	}
	
	func InitialView() -> some View {
		Group {
			VStack (spacing: 0){
				DateHeader(items: [], date: Date(), sumForDate: 0)
			}
			VStack(spacing: 0) {
				Image(systemName: "pencil.and.list.clipboard")
					.resizable()
					.scaledToFit()
					.padding(30)
					.padding(.leading, 25)
					.frame(width: 200, height: 200, alignment: .center)
					.foregroundColor(Color(uiColor: .placeholderText))
				Text("내역이 없어요.")
				Text("하단의 입력창을 탭해보세요!")
			}
			.frame(maxHeight: .infinity)
			.safeAreaInset(edge: .bottom, spacing: 0) {
				OverlayKeypad()
					.animation(.spring(response: 0.2, dampingFraction: 1.0))
					.transition(.move(edge: .bottom))
			}
		}
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
