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
	@Query private var items: [Item]
	@State private var frames: [CGRect] = []
	@State private var string = "0"
	@State private var isShowingKeypad = false
	
	let minDistance = 10.0

	var body: some View {
		let bounds = UIScreen.main.bounds
		var width = bounds.size.width
		var height = bounds.size.height
		let groupedItems = items.sortedByDate()
		//			var dayTotal: Int = 0
		
		let dealBasisRate = (Double(filteredResponse?.deal_bas_r ?? "1000") ?? 1.0) / 1000
		
		NavigationSplitView {
			ScrollView {
				ForEach(groupedItems, id: \.0) { date, itemsInDate in
					let dateFormatter = DateFormatter()
					VStack(alignment: .leading, spacing: 0) {
						Group {
							HStack {
								Text("\(dateFormat(for: date, format: "mm/dd"))")
									.font(.title)
									.foregroundColor(dayColor(for: date))
								Spacer()
								Text("₩sum")
									.font(.title2)
									.foregroundColor(.gray)
							}
							Divider()
						}
		
						.sticky(frames)
						
						VStack(alignment: .leading) {
							ForEach(itemsInDate, id: \.id) { item in
								HStack {
									Text("\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
										.foregroundColor(.gray)
										.font(.title2)
									if let balance = Double(item.balance) {
										Text("¥ →")
											.font(.title2)
										Spacer()
										Text("₩\(item.calculatedBalance)")
											.font(.title)
										//										.opacity(opacityForItem(item))
									}
								}
							}
						}
						.padding([.top, .trailing], 10)
						.padding([.leading], 5)
						//						Divider()
						//						VStack(alignment: .trailing) {
						//							Text(dealBasisRate ?? "0")
						
						
						//										.onAppear {
						//											if let balance = Int(item.balance) {
						//												dayTotal += balance
						//											}
						//										}
					}
					.padding([.bottom], 20)
						//								.transition(.move(edge: .bottom).combined(with: .opacity))
						//									.onDelete(perform: { indexSet in
						//										deleteItems(offsets: indexSet)
						//										dayTotal = itemsInDate.reduce(0) { $0 + Int($1.balance)! }
						//									})
//					}
//					Divider()
//				}
//			}
		}
				.padding([.leading, .trailing], 10)
				
			}
		

			.coordinateSpace(name: "container")
			.onPreferenceChange(FramePreference.self, perform: {
				frames = $0.sorted(by: { $0.minY < $1.minY
				})
			})
//				.toolbar {
//					//	ToolbarItem(placement: .navigationBarTrailing) {
//					//		EditButton()
//					//	}
//					ToolbarItem {
//						Button(action: addItem) {
//							Label("Add Item", systemImage: "plus")
//						}
//					}
					
					//					dev only
//					ToolbarItem(placement: .navigationBarLeading) {
//						Button(action: deleteAll) {
//							Label("delete All", systemImage:"trash")
//						}
//					}
//				}
		} detail: {
		}
		
		VStack {
			Divider()
			HStack {
				Text("¥")
					.contentShape(Rectangle())
					.onLongPressGesture(perform: {
						UIImpactFeedbackGenerator().impactOccurred()
					})
				
				Spacer()
				Text(formatNumber(string))
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
						
						// on swipe up
						if trans.height < minDistance {
							addItem()
						}
						
						// restricts swipe directions
						if abs(trans.width) > abs(trans.height) {
							return
						}
					}
					.onEnded { orientation in
						let trans = orientation.translation
						if (trans.height > minDistance) {
							deleteFirst()
						}
					}
			)
			
			VStack(spacing: 0) {
				Divider()
				Keypad(string: $string)
					.frame(height: isShowingKeypad ? height / 3.5 : 0)
					.opacity(isShowingKeypad ? 1 : 0)
					.offset(y: isShowingKeypad ? 0 : height)
					.transition(.move(edge: .bottom))
			}
		}
		.font(.largeTitle)
		.padding()	
		.onAppear {
			// print("Loading Exchange rate data...")
			// fetchData()
		}
						
	}
	
	
	private func addItem() {
		if let balance = Double(string) {
			if string != "0" {
				let newItem = Item(timestamp: Date(), balance: String(balance))
				modelContext.insert(newItem)
				UISelectionFeedbackGenerator().selectionChanged()
				string = "0"
			}
		}
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
			UISelectionFeedbackGenerator().selectionChanged()
		}
	}
	
	// for dev only
	private func deleteAll() {
		try? modelContext.fetch(FetchDescriptor<Item>()).forEach { modelContext.delete($0)}
		try? modelContext.save()
	}
	
	// formats keypad num
	private func formatNumber(_ number: String) -> String {
		if let doubleValue = Double(number) {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			return formatter.string(from: NSNumber(value: doubleValue)) ?? ""
		}
		return ""
	}
	
	func opacityForItem(_ item: Item) -> Double {
		let minOpacity: Double = 0.7
		
		if let index = items.firstIndex(of: item) {
			let Opacity = Double(index + 1) / Double(items.count)
			return max(Opacity, minOpacity)
		}
		return 1.0
	}
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
