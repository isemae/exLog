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
	@Binding var string: String
	@StateObject private var dataModel = DataModel()

	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void

	var body: some View {
		VStack(spacing: 0) {
			ZStack {
				Capsule()
					.frame(width: Screen.width / 1.5, height: Screen.height / 15)
					.overlay(
						HStack {
							Image(systemName: "scope")
								.resizable()
								.frame(width: 30, height: 30)
								.foregroundColor(.accentColor)
							Spacer()
						}
							.padding()
					)
				HStack {
					Spacer()
					Text("\'여행이름\'")
						.font(.title2)
					Spacer()
				}
				.foregroundColor(.accentColor)
				.padding()
			}
			Form {
				Section("지출 추가") {
					Text("사진")
					Text("설명...")
					Text("시간")
				}
			}
			.font(.callout)
			CategoryCarouselView()
			VStack(spacing: 0) {
				InputStringArea(
					string: string,
					onSwipeUp: { addItem() },
					onSwipeDown: { deleteFirst() })
				.onChange(of: string, perform: { _ in
					if string.count > 9 {
						string = String(string.prefix(9)) }})

				Keypad(string: $string, onSwipeUp: { addItem() },
					   onSwipeDown: { deleteFirst() })
				.font(.largeTitle)
			}
			.background(.bar)
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

struct OverlayKeypadPreview: View {
	@State var string: String = "0"
	var body: some View {
		VStack {
			InputView(string: $string, onSwipeUp: {}, onSwipeDown: {})
			.environmentObject(DataModel())
		}
		.font(.largeTitle)
	}
}

#Preview {
	OverlayKeypadPreview()
}
