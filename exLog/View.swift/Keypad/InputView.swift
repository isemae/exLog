//
//  OverlayKeypad.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/12/24.
//

import SwiftUI
import SwiftData

struct InputView: View {
	@Environment(\.modelContext) var modelContext
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@Binding var string: String
	@StateObject private var dataModel = DataModel()
	@State var selectedCategory: Category = .nil
	@State var itemDesc: String = ""
	@State var showAddedIndicator = false
	@State var showDeletedIndicator = false
	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void
	@State var indicatorCancellation: DispatchWorkItem?

	var body: some View {
		VStack(spacing: 0) {
			HStack {
				Image(systemName: "scope")
					.resizable()
					.frame(width: 30, height: 30)
					.foregroundColor(.accentColor)
				Spacer()
			}
			.padding()
			.overlay(
				HStack {
					Spacer()
					ZStack {
						NavigationLink("여행이름", destination: LocationGridView(items: items.filter { $0.location == nil }, tapAction: { try? modelContext.save() }))
							.underline()
							.font(.title2)
						HStack {
							Spacer()
							itemAddedIndicator(item: items.first!)

						}
					}
					Spacer()
				}
					.foregroundColor(.accentColor)
					.padding(5)
			)
			Form {
				Section("지출 추가") {
					HStack {
						Text("사진")
						Spacer()
						Text(dataModel.ampm ? "\(dateFormatString(for: Date(), format: "aahhmm"))" : "\(dateFormatString(for: Date(), format: "hhmm"))")
					}
					TextField("설명...", text: $itemDesc)

				}
			}
			.font(.callout)
			CategoryPickerView(selectedCategory: $selectedCategory)
				.frame(height: Screen.height / 8)
			VStack(spacing: 0) {
				InputStringArea(
					string: string,
					onSwipeUp: {
						addItem()
					},
					onSwipeDown: {
						deleteFirst()
					})
				.onChange(of: string, perform: { _ in
					if string.count > 9 {
						string = String(string.prefix(9)) }})

				Keypad(string: $string, onSwipeUp: { addItem()
				},
					   onSwipeDown: { deleteFirst()
				})
				.font(.largeTitle)
			}
			.background(.bar)
		}
		.ignoresSafeArea(.keyboard)
	}

	func itemAddedIndicator(item: Item) -> some View {
		return
		HStack {
			ZStack {
				Capsule()
					.foregroundColor(Color(uiColor:.label))
				HStack {
					if showAddedIndicator {
						Image(systemName: "checkmark.circle")
							.foregroundColor(.green)
							.onAppear {
								showDeletedIndicator = false
							}
						Spacer()
					}
					if showDeletedIndicator {
						Image(systemName: "minus.circle")
							.foregroundColor(.red)
							.onAppear {
								showAddedIndicator = false
							}
						Spacer()
					}
					Group {
						Text(item.category?.symbol ?? "")
						if (showAddedIndicator || showDeletedIndicator) && !items.isEmpty {
							Text("₩\(item.calculatedBalance)")
								.foregroundColor(Color(UIColor.systemBackground))
//					.transition(.asymmetric(insertion: .move(edge:.bottom), removal: .move(edge: .top)))
						}
					}
				}
				.padding()
			}
			.frame(maxWidth: (showAddedIndicator || showDeletedIndicator) ? Screen.width / 2 : Screen.width / 5 )
		}
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

	enum IndicatorAction {
		case add
		case delete
	}

	func handleIndicator(action: IndicatorAction) {
		indicatorCancellation?.cancel()

		withAnimation(.easeOut(duration: 0.2)) {
			switch action {
			case .add:
				showDeletedIndicator = false
				showAddedIndicator = true
			case .delete:
				showDeletedIndicator = true
				showAddedIndicator = false
			}
		}

		let cancellation = DispatchWorkItem {
			withAnimation(.easeOut(duration: 0.2)) {
				switch action {
				case .add:
					showAddedIndicator = false
				case .delete:
					showDeletedIndicator = false
				}
			}
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: cancellation)
		indicatorCancellation = cancellation

	}

	func addItem() {
		if let balance = Double(string), string != "0" {
			let newItem = Item(date: Date(), balance: String(balance), currency: dataModel.currentCurrency, category: selectedCategory, desc: itemDesc)
			withAnimation(.easeOut(duration: 0.2)) {
				modelContext.insert(newItem)
				saveContext()
				updateFoldedDate()
			}
			string = "0"
		}
		handleIndicator(action: .add)

	}

	func deleteFirst() {
		if let recentItem = items.first {
			handleIndicator(action: .delete)
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

struct OverlayKeypadPreview: View {
	@State var string: String = "0"
	@State var selectedCategory: Category = .nil
	var body: some View {
		VStack {
			InputView(string: $string, selectedCategory: selectedCategory, onSwipeUp: {}, onSwipeDown: {})
				.environmentObject(DataModel())
		}
		.font(.largeTitle)
	}
}

#Preview {
	OverlayKeypadPreview()
}
