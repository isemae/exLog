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
	
	let exchangeURL = ExchangeURL(authKey: authKey, theDateBefore: "20231101")
	
	var body: some View {
		let bounds = UIScreen.main.bounds
		var width = bounds.size.width
		var height = bounds.size.height
		
		let groupedItems = items.sortedByDate()
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
//					ToolbarItem(placement: .navigationBarTrailing) {
//						EditButton()
//					}
					ToolbarItem {
						Button(action: addItem) {
							Label("Add Item", systemImage: "plus")
						}
					}
					
// dev only
//					ToolbarItem(placement: .navigationBarLeading) {
//						Button(action: deleteAll) {
//							Label("delete All", systemImage:"trash")
//						}
//					}
				}
				.onAppear {
					print("Loading Exchange rate data...")
//	Disabled for now
//					fetchData()
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
		if let firstGroup = items.sortedByDate().first,
		   let recentItem = firstGroup.1.first {
			modelContext.delete(recentItem)
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
	private func fetchData() {
		guard items.isEmpty else {
			print("Previous data already exists.")
			return
		}
		
		request(url: exchangeURL.url!.absoluteString, method: .get) { result in
			switch result {
			case .success(let data):
				print("Received data: \(data)")
				
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}
}


	

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
