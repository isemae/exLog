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
	//	@Query(filter: #Predicate<Items> { items in
	//		!items.isFolded
	//	})
	@StateObject private var dataModel = DataModel()
	@State var keypadState = States.Keypad()
	@State var locationState = States.Location()
	@State var pickerState = States.Picker()
	@State private var image: UIImage?

	var body: some View {
		//		let years = items.map { item in
		//			return Calendar.current.component(.year, from: item.date)
		//		}
		//		let uniqueYears = Array(Set(years))
		if !items.isEmpty {
			NavigationView {
				ScrollView(.vertical) {
					NavigationLink("분류되지 않음", destination: destinationItemListView())
					LocationGridView(items: items.filter { $0.location == nil }, tapAction: { try? modelContext.save() })
				}
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							pickerState.isDatePickerPresented.toggle()
						} label: {
							Label("새 일정", systemImage: "calendar.badge.plus")
						}
					}
				}
				.sheet(isPresented: $pickerState.isDatePickerPresented, content: {
					VStack {
						DatePickerView(selectedDates: $pickerState.selectedDates)
						TextField("위치...", text: $pickerState.addingLocationName)
					}
					HStack {
						Button {
							pickerState.isDatePickerPresented = false
							pickerState.selectedDates = []
						} label : {
							Text("취소")
						}
						Button {
							let newLocation = Location(name: pickerState.addingLocationName, startDate: pickerState.selectedDates.first ?? Date(), endDate: pickerState.selectedDates.last ?? Date(), items: [])
							pickerState.isDatePickerPresented = false
							newLocation.name = pickerState.addingLocationName
							newLocation.startDate = pickerState.selectedDates.first
							newLocation.endDate = pickerState.selectedDates.last
							newLocation.items = items.filter { item in
								if let startDate = newLocation.startDate, let endDate = newLocation.endDate {
									return startDate <= item.date && item.date <= endDate
								}
								return false
							}
							withAnimation(.easeOut(duration: 0.2)) {
								modelContext.insert(newLocation)
								saveContext()
							}
							pickerState.addingLocationName = ""
							pickerState.selectedDates = []
							for location in locations {
								print(location.name)
							}
						} label : {
							Text("확인")
						}
					}
				})
			}

		} else {
			initialView()
		}
	}

	func destinationItemListView() -> some View {
		ItemListView(items: items, onTap: { try? modelContext.save() })
			.navigationBarTitle("분류되지 않음")
			.foregroundColor(Color(uiColor: .label))
			.safeAreaInset(edge: .bottom) {
				overlayKeypad()
					.transition(.move(edge: .bottom))
			}
			.environmentObject(dataModel)
	}

	func initialView() -> some View {
		ZStack {
			Group {
				ZStack {
					VStack(spacing: 0) {
						if keypadState.isShowingKeypad {
							VStack(alignment: .leading) {
								ForEach([
									("arrow.up", "hand.tap.fill", " - 내역을 등록해요."),
									("arrow.down", "hand.tap.fill", " - 가장 최근의 내역이 삭제돼요.")
								], id: \.0) { icons in
									HStack(spacing: 0) {
										Image(systemName: icons.1)
											.frame(height: 40)
										Image(systemName: icons.0)
										Text(icons.2)
									}
								}
							}
						}
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
				}
				.animation(.spring(response: 0.3, dampingFraction: 0.9))
				Text("")
					.frame(maxHeight: .infinity)
					.safeAreaInset(edge: .bottom, spacing: 0) {
						overlayKeypad()
							.transition(.move(edge: .bottom))
					}
			}
		}
	}

	func overlayKeypad() -> some View {
		VStack(spacing: 0) {
			InputArea(isShowingKeypad: $keypadState.isShowingKeypad,
					  string: keypadState.string,
					  onSwipeUp: {
				addItem()
				//				selectedYear = Calendar.current.component(.year, from: Date())
			},
					  onSwipeDown: {
				deleteFirst()
			})
			.environmentObject(dataModel)
			.onChange(of: keypadState.string, perform: { _ in
				if keypadState.string.count > 9 {
					keypadState.string = String(keypadState.string.prefix(9)) }})

			Keypad(string: $keypadState.string, isShowing: $keypadState.isShowingKeypad,
				   onSwipeUp: {
				self.addItem()
				//				selectedYear = Calendar.current.component(.year, from: Date())
			},
				   onSwipeDown: {
				self.deleteFirst()
			})
			.font(.largeTitle)
			.disabled(!keypadState.isShowingKeypad)
			.offset(y: keypadState.isShowingKeypad ? 0 : Screen.height / 2)
		}
		.background(.bar)
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

	func addItem() {
		if let balance = Double(keypadState.string), keypadState.string != "0" {
			let newItem = Item(date: Date(), balance: String(balance), currency: dataModel.currentCurrency)
			withAnimation(.easeOut(duration: 0.2)) {
				modelContext.insert(newItem)
				saveContext()
				updateFoldedDate()
			}
			keypadState.string = "0"
		}
	}

	func deleteFirst() {
		if let firstGroup = items.sortedByDate().first,
		   let recentItem = firstGroup.1.first {
				withAnimation(.easeOut(duration: 0.2)) {
					modelContext.delete(recentItem)
					saveContext()
					updateFoldedDate()
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
