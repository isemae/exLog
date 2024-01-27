//
//  OverlayKeypad.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/12/24.
//

import SwiftUI
import SwiftData

struct InputView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@EnvironmentObject var navigationFlow: NavigationFlow
	@Binding var string: String
	@StateObject private var dataModel = DataModel()
	@State var selectedCategory: Category = .nil
	@State var itemDesc: String = ""
	@State var showAddedIndicator = false
	@State var showDeletedIndicator = false
	@State var indicatorCancellation: DispatchWorkItem?

	var body: some View {
		VStack(spacing: 0) {
			lastItemIndicator(item: items.first!)
				.padding(.vertical, 5)
			Form {
				HStack {
					TextField("설명...", text: $itemDesc)
					Spacer()
					Text("\(dateFormatString(for: Date(), format: "aahhmm"))" )
				}
			}
			.font(.callout)
			CategoryPickerView(selectedCategory: $selectedCategory)
				.frame(height: Screen.height / 8)
			VStack(spacing: 0) {
				InputStringArea(string: string)
					.onChange(of: string, perform: { _ in
						if string.count > 9 {
							string = String(string.prefix(9)) }})
				Keypad(string: $string)
			}
			.gestureHandler(onSwipeUp: addItem, onSwipeDown: deleteFirst)
			.background(.bar)
		}
		.ignoresSafeArea(.keyboard)
		.navigationTitle("지출 추가")
		.toolbarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					navigationFlow.navigateToLocationGridView()
				} label: {
					Image(systemName: "square.grid.2x2.fill")
				}
			}
		}
	}

	func lastItemIndicator(item: Item) -> some View {
		return
		HStack {
			ZStack {
				Capsule()
					.foregroundStyle(.bar)
				HStack {
					if showAddedIndicator || showDeletedIndicator {
						indicatorImage(for: showAddedIndicator ? .add : .delete)
					} else {
						EmptyView()
					}
					Spacer()
					Group {
						Text(item.category?.symbol ?? "")
						if (showAddedIndicator || showDeletedIndicator) && !items.isEmpty {
							Text("₩\(item.calculatedBalance)")
								.foregroundColor(Color(UIColor.label))
							//					.transition(.asymmetric(insertion: .move(edge:.bottom), removal: .move(edge: .top)))
						}
					}
				}
				.padding()
			}
			.frame(maxWidth: (showAddedIndicator || showDeletedIndicator) ? Screen.width / 1.5 : Screen.width / 3, maxHeight: 40)

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

	//	func showIndicator() {
	//		if showAddedIndicator {
	//			Image(systemName: "checkmark.circle")
	//				.foregroundColor(.green)
	//				.onAppear {
	//					showDeletedIndicator = false
	//				}
	//			Spacer()
	//		}
	//		if showDeletedIndicator {
	//			Image(systemName: "minus.circle")
	//				.foregroundColor(.red)
	//				.onAppear {
	//					showAddedIndicator = false
	//				}
	//			Spacer()
	//		}
	//	}

	func indicatorImage(for action: IndicatorAction) -> some View {
		let systemName: String
		let color: Color

		switch action {
		case .add:
			systemName = "checkmark.circle"
			color = .green
		case .delete:
			systemName = "minus.circle"
			color = .red
		}

		return Image(systemName: systemName)
			.foregroundColor(color)
			.onAppear {
				switch action {
				case .add:
					showDeletedIndicator = false
				case .delete:
					showAddedIndicator = false
				}
			}
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
			itemDesc = ""
		}
		handleIndicator(action: .add)

		print(items.first?.date ?? Date())
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
			InputView(string: $string, selectedCategory: selectedCategory)
				.environmentObject(DataModel())
		}
		.font(.largeTitle)
	}
}

#Preview {
	OverlayKeypadPreview()
}
