//
//  ContentView.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
	@State private var string = "0"
	
	let minDistance = 10.0
	
	
	var body: some View {
		let bounds = UIScreen.main.bounds
		var width = bounds.size.width
		var height = bounds.size.height
		let groupedItems = groupItemsByDate(items: items)
		NavigationSplitView {
			List {
				ForEach(groupedItems.reversed(), id: \.0) { date, itemsInDate in
					Section(header: Text("\(date, format: Date.FormatStyle(date: .long, time: .none))")) {
						ForEach(itemsInDate, id: \.id) { item in
							HStack {
								Text(" \(item.balance) ")
								Spacer()
								Text(" \(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
									.foregroundColor(.gray)
							}.padding(5)
						}
					}
				}
				.onDelete(perform: deleteItems)
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					EditButton()
				}
				ToolbarItem {
					Button(action: addItem) {
						Label("Add Item", systemImage: "plus")
					}
				}
				ToolbarItem {
					Button(action: deleteAll) {
						Label("delete All", systemImage:"trash")
					}
				}
			}
		} detail: {
			Text("Select an item")
		}
		VStack {
			HStack {
				Spacer()
				Text(string)
			}
			.contentShape(Rectangle())
			.padding([.leading, .trailing])
			.gesture(
				DragGesture()
					.onChanged { orientation in
						let trans = orientation.translation
						if abs(trans.width) > abs(trans.height) {
							return
						}
						
						if trans.height < minDistance {
							if string != "0" {
								UISelectionFeedbackGenerator().selectionChanged()
								addItem()
							}
						}
						
						if ((orientation.location.y - orientation.startLocation.y) > 0) {
							UISelectionFeedbackGenerator().selectionChanged()
							deleteFirst()
						}
					}
					.onEnded { orientation in }
			)
			Divider()
			Keypad(string: $string)
		}
		.font(.largeTitle)
		.padding()
	}
	
    private func addItem() {
			let newItem = Item(timestamp: Date(), balance: string)
			string = "0"
            modelContext.insert(newItem)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
	
	private func deleteFirst() {
		let firstItem = items.firstIndex
//		modelContext.delete(firstItem)
	}
	
	// for dev only
	private func deleteAll() {
		do {
			try modelContext.delete(model: Item.self)
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	func groupItemsByDate(items: [Item]) -> [(Date, [Item])] {
		let groupedDictionary = Dictionary(grouping: items) { item in
			Calendar.current.startOfDay(for: item.timestamp)
		}

		let sortedGroups = groupedDictionary.sorted { $0.key > $1.key }

		return sortedGroups
	}
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
