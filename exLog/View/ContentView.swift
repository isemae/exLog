//
//  ContentView.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@Query private var locations: [Location]
	@EnvironmentObject var navigationFlow: NavigationFlow
	//	@Query(filter: #Predicate<Items> { items in
	//		!items.isFolded
	//	})
	//	@StateObject private var dataModel = DataModel()
	@State var keypadState = States.Keypad()
	//	@State var locationState = States.Location()
	@State private var image: UIImage?

	var body: some View {
		//		let years = items.map { item in
		//			return Calendar.current.component(.year, from: item.date)
		//		}
		//		let uniqueYears = Array(Set(years))
		NavigationStack(path: $navigationFlow.path) {
			InputView()
				.navigationDestination(for: LocationNavigation.self) { destination in
					LocationViewFactory.setViewForDestination(destination, location: navigationFlow.selectedLocation)
				}
		}

	}

	//			.safeAreaInset(edge: .bottom) {
	//				OverlayKeypad(string: $keypadState.string, isShowingKeypad: $keypadState.isShowingKeypad, onSwipeUp: addItem, onSwipeDown: deleteFirst)
	//					.transition(.move(edge: .bottom))
	//			}
	//			.environmentObject(dataModel)

	//	func initialView() -> some View {
	//		ZStack {
	//			Group {
	//				ZStack {
	//					VStack(spacing: 0) {
	//						if keypadState.isShowingKeypad {
	//							VStack(alignment: .leading) {
	//								ForEach([
	//									("arrow.up", "hand.tap.fill", " - 내역을 등록해요."),
	//									("arrow.down", "hand.tap.fill", " - 가장 최근의 내역이 삭제돼요.")
	//								], id: \.0) { icons in
	//									HStack(spacing: 0) {
	//										Image(systemName: icons.1)
	//											.frame(height: 40)
	//										Image(systemName: icons.0)
	//										Text(icons.2)
	//									}
	//								}
	//							}
	//						}
	//						Image(systemName: "pencil.and.list.clipboard")
	//							.resizable()
	//							.scaledToFit()
	//							.padding(30)
	//							.padding(.leading, 25)
	//							.frame(width: 200, height: 200, alignment: .center)
	//							.foregroundColor(Color(uiColor: .placeholderText))
	//						Text("내역이 없어요.")
	//						Text("하단의 입력창을 탭해보세요!")
	//					}
	//					.frame(maxHeight: .infinity)
	//				}
	////				.animation(.spring(response: 0.3, dampingFraction: 0.9))
	//				Text("")
	//					.frame(maxHeight: .infinity)
	//					.safeAreaInset(edge: .bottom, spacing: 0) {
	//						OverlayKeypad(string: $keypadState.string, isShowingKeypad: $keypadState.isShowingKeypad, onSwipeUp: addItem, onSwipeDown: deleteFirst)
	//							.transition(.move(edge: .bottom))
	//					}
	//			}
	//		}
	//	}

	func saveContext() {
		do {
			try modelContext.save()
			UISelectionFeedbackGenerator().selectionChanged()
		} catch {
			print("Error saving context: \(error)")
			UINotificationFeedbackGenerator().notificationOccurred(.warning)
		}
	}

	//	func updateFoldedDate() {
//	let currentDate = Calendar.current.startOfDay(for: Date())
	//		if dataModel.foldedItems[currentDate] == true {
	//			dataModel.foldedItems[currentDate] = false
	//		}
	//	}

	func addItem() {
		if let balance = Double(keypadState.string), keypadState.string != "0" {
			//			let newItem = Item(date: Date(), balance: String(balance), currency: dataModel.currentCurrency)
			withAnimation(.easeOut(duration: 0.2)) {
				//				modelContext.insert(newItem)
				saveContext()
				//				updateFoldedDate()
			}
			keypadState.string = "0"
		}
	}

	func deleteFirst() {
		if let recentItem = items.last {
			withAnimation(.easeOut(duration: 0.2)) {
				modelContext.delete(recentItem)
				saveContext()
				//				updateFoldedDate()
			}
		}
	}

	func deleteItems(offsets: IndexSet) {
		DispatchQueue.global().async {
			for index in offsets {
				modelContext.delete(items[index])
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

//
// #Preview {
//    ContentView()
//		.modelContainer(for: [Item.self], inMemory: true)
//		.environmentObject(DataModel())
// }
