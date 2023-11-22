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
	@State private var isShowingKeypad = false
	let minDistance = 10.0
	
	var body: some View {
		let bounds = UIScreen.main.bounds
		var width = bounds.size.width
		var height = bounds.size.height
		
		let groupedItems = groupItemsByDate(items: items)
		NavigationSplitView {
			var dayTotal: Int = 0
			ScrollView {
				ForEach(groupedItems, id: \.0) { date, itemsInDate in
					HStack(alignment: .top) {
						VStack {
							Text("\(date, format: Date.FormatStyle(date: .numeric, time: .none))")
								.font(.title2)
								.foregroundColor(.blue)
						}
						VStack(alignment: .trailing) {
							VStack {
								ForEach(itemsInDate, id: \.id) { item in
									HStack {
										Text("₩\(item.balance)")
											.onAppear {
												if let balance = Int(item.balance) {
													dayTotal += balance
												}
											}
											.font(.title)
										Spacer()
										Text("\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
											.foregroundColor(.gray)
											.font(.title2)
									}
									.transition(.move(edge: .bottom).combined(with: .opacity))
								}
								.onDelete(perform: { indexSet in
									deleteItems(offsets: indexSet)
									dayTotal = itemsInDate.reduce(0) { $0 + Int($1.balance)! }
								})
							}
							Divider()
							
						}
						.padding(5)
					}
				}
			}.padding()
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
			
		}
		VStack {
			HStack {
				Text("¥")
				Spacer()
				Text(string)
			}
			.contentShape(Rectangle())
			.padding([.leading, .trailing])
			.onTapGesture(perform: {
				withAnimation(.spring(response: 0.2, dampingFraction: 1.0)) {
					isShowingKeypad.toggle()
				}
			})
			.gesture(
				DragGesture()
					.onChanged { orientation in
						let trans = orientation.translation
						if abs(trans.width) > abs(trans.height) {
							return
						}
						
						if trans.height < minDistance {
							if string != "0" {
								addItem()
								UISelectionFeedbackGenerator().selectionChanged()
							}
						}
				
					}
					.onEnded { orientation in
						let trans = orientation.translation
						if (trans.height > minDistance) {
							deleteFirst()
							UISelectionFeedbackGenerator().selectionChanged()
						}
					}
			)
			Divider()
			Keypad(string: $string)
				.frame(height: isShowingKeypad ? height / 3.5 : 0)
				.opacity(isShowingKeypad ? 1 : 0)
				.offset(y: isShowingKeypad ? 0 : height)
				.transition(.move(edge: .bottom))
		}
		.font(.largeTitle)
		.padding()
	}
	
	private func addItem() {
			let newItem = Item(timestamp: Date(), balance: string)
			modelContext.insert(newItem)
			string = "0"
	}
	
    private func deleteItems(offsets: IndexSet) {
        
            for index in offsets {
                modelContext.delete(items[index])
            }
        
    }
	
	private func deleteFirst() {
			if let recentItem = items.last {
				withAnimation {
				modelContext.delete(recentItem)
			}
		}
	}
	
	// for dev only
	private func deleteAll() {
		do {
			try? modelContext.fetch(FetchDescriptor<Item>()).forEach { modelContext.delete($0)}
			try? modelContext.save()
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	func groupItemsByDate(items: [Item]) -> [(Date, [Item])] {
		let groupedDictionary = Dictionary(grouping: items) { item in
			Calendar.current.startOfDay(for: item.timestamp)
		}

		let sortedGroups = groupedDictionary.sorted { $0.key > $1.key }

		
		let sortedItemsInGroups = sortedGroups.map { (date, items) in
			(date, items.sorted(by: { $0.timestamp > $1.timestamp }))
		}

		return sortedItemsInGroups
	}
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
