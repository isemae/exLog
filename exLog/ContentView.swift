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
	@StateObject private var dataModel = DataModel.init()
	@State private var string = "0"
	@State private var isShowingKeypad = false
	@State private var height = CGFloat.zero
//	@State private var currentYear: Int = Calendar.current.component(.year, from: Date())
	@State private var currentLocation: String = ""
	@State private var selectedLocation: String = ""
	@State private var isDatePickerPresented = false
	
	@Binding var selectedYear: Int?
	@State var addingLocationName: String = ""

	let screenHeight = UIScreen.main.bounds.size.height
	let screenWidth = UIScreen.main.bounds.size.width
	
	var body: some View {
//		let years = items.map { item in
//			return Calendar.current.component(.year, from: item.date)
//		}
//		let uniqueYears = Array(Set(years))
		
		if !items.isEmpty {
			NavigationView {
				ScrollView {
					LazyVStack {
						ForEach(locations, id: \.self) { location in
							NavigationLink(location.name, destination: List(createTestItems()) { item in
								Text(item.balance)}
							)}
//							ForEach(locations, id: \.self) { location in
								
//								let locationItems = items.filter({ $0.location?.name == location.name})
							
//								NavigationLink(destination: DayListView(items: createTestItems(), onTap: { try? modelContext.save() }, location: location.name )
//									.safeAreaInset(edge: .bottom, spacing: 0) {
//										OverlayKeypad()
//											.transition(.move(edge: .bottom))
//									}
//									.navigationTitle(location.name!)
//									.foregroundColor(Color(uiColor: UIColor.label))
//									.environmentObject(dataModel)
//								) {
//									//								ImagePickerView(date: String(year))
//									//									.buttonStyle(.plain)
//								}
							NavigationLink("분류되지 않음", destination: DayListView(items: items, onTap: { try? modelContext.save() } )
								.safeAreaInset(edge: .bottom, spacing: 0) {
									OverlayKeypad()
										.transition(.move(edge: .bottom))
								}
										   //									.navigationTitle("\(String(selectedYear ?? currentYear))")
								.navigationTitle("분류되지 않음")
								.foregroundColor(Color(uiColor: UIColor.label))
								.environmentObject(dataModel)
							)
					}
						.navigationTitle("main")
				}
				.onAppear() {
//					if let storedLocation = selectedLocation {
//						currentLocation = storedLocation
//					} else {
////						currentLocation = Calendar.current.component(.year, from: Date())
//					}
				}
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							isDatePickerPresented.toggle()
						} label: {
							Label("새 일정", systemImage: "calendar.badge.plus")
						}
					}
				}
				.sheet(isPresented: $isDatePickerPresented, content: {
					VStack {
						DatePickerView()
						TextField("위치...", text: $addingLocationName)
						HStack {
							Button {
								isDatePickerPresented = false
							} label : {
								Text("취소")
							}
							
							Button {
								let newLocation = Location(name: addingLocationName)
								isDatePickerPresented = false
								newLocation.name = addingLocationName
								addingLocationName = ""
								withAnimation(.easeOut(duration: 0.2)) {
									modelContext.insert(newLocation)
									saveContext()
								}
								for location in locations {
									print(location.name)
								}
							} label : {
								Text("확인")
							}
						}
					}
				})
				
			}
			.safeAreaInset(edge: .bottom, spacing: 0) {
				OverlayKeypad()
					.transition(.move(edge: .bottom))
			}
			
			.onAppear() {
				//				currentYear = Calendar.current.component(.year, from: Date())
			}
		} else {
			InitialView()
		}
	}
	
	func InitialView() -> some View {
		ZStack {
			Group {
				ZStack {
					VStack(spacing: 0) {
						if isShowingKeypad {
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
						OverlayKeypad()
							.transition(.move(edge: .bottom))
					}
			}
		}
	}
	
	func OverlayKeypad() -> some View {
		VStack(spacing: 0) {
			InputArea(isShowingKeypad: $isShowingKeypad,
					  string: string,
					  onSwipeUp: { 
				addItem()
				selectedYear = Calendar.current.component(.year, from: Date())
			},
					  onSwipeDown: {
				deleteFirst()
			})
			.environmentObject(dataModel)
			.onChange(of: string, perform: { newValue in
				if string.count > 9 {
					string = String(string.prefix(9)) }})
			
			Keypad(string: $string, isShowing: $isShowingKeypad,
				   onSwipeUp: { 
				self.addItem()
				selectedYear = Calendar.current.component(.year, from: Date())
			},
				   onSwipeDown: {
				self.deleteFirst()
			})
			.font(.largeTitle)
			.disabled(!isShowingKeypad)
			.offset(y: isShowingKeypad ? 0 : screenHeight / 2)
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
		if let balance = Double(string), string != "0" {
			let newItem = Item(date: Date(), balance: String(balance), currency: dataModel.currentCurrency)
				withAnimation(.easeOut(duration: 0.2)) {
					modelContext.insert(newItem)
					saveContext()
					updateFoldedDate()
				}
			string = "0"
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
//#Preview {
//    ContentView()
//		.modelContainer(for: [Item.self], inMemory: true)
//		.environmentObject(DataModel())
//}
