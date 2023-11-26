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
	@State var dateFrames: [CGRect] = []
	@State private var string = "0"
	@State private var isShowingKeypad = false
	@State private var currentCurrency = "¥"
	
	let minDistance = 10.0
	

	var body: some View {
		let bounds = UIScreen.main.bounds
		var screenWidth = bounds.size.width
		var screenHeight = bounds.size.height
		let groupedItems = items.sortedByDate()
		//			var dayTotal: Int = 0
		
		NavigationSplitView {
			ScrollView {
				ForEach(groupedItems.sorted(by: { $0.0 > $1.0}), id: \.0) { date, itemsInDate in
					let sortedItems = itemsInDate.sorted { $0.timestamp > $1.timestamp }
					let sumForDate = sortedItems.reduce(0) { $0 + $1.calculatedBalance }

					VStack(alignment: .leading, spacing: 0) {
						Group {
							HStack {
								Text("\(dateFormat(for: date, format: "mm/dd"))")
									.font(.title)
									.foregroundColor(dayColor(for: date))
								Spacer()
								
								Text("₩\(sumForDate)")
									.font(.title2)
									.foregroundColor(.gray)
							}
							Divider()
						}
						.sticky(dateFrames)
						.padding(.top, 10)
					
						
						ForEach(sortedItems, id: \.id) { item in
							HStack (alignment: .top){
								VStack(alignment: .leading) {
									Text("\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
										.foregroundColor(.gray)
										.font(.title2)
									
									Text("\(currentCurrency) → ₩")
										.font(.title2)
								}
								VStack {
									HStack {
										Spacer()
										Text("₩\(item.calculatedBalance)")
											.font(.title)
										//										.opacity(opacityForItem(item))
									}
								}.padding([.top, .bottom], 5)
							}
						}
						
						.padding([.top, .leading, .trailing], 10)
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
					.transition(.move(edge: .top).combined(with: .opacity))
					//					.onDelete(perform: { indexSet in
					//						deleteItems(offsets: indexSet)
					//						dayTotal = itemsInDate.reduce(0) { $0 + Int($1.balance)! }
					//					})
					//					}
					//					Divider()
					//				}
					//			}
				}
				.padding([.leading, .trailing], 10)
				.frame(width: screenWidth)
				
			}
			.coordinateSpace(name: "container")
			.onPreferenceChange(FramePreference.self, perform: {
				dateFrames = $0.sorted(by: { $0.minY < $1.minY })
			})
				.toolbar {
					//	ToolbarItem(placement: .navigationBarTrailing) {
					//		EditButton()
					//	}
					ToolbarItem {
						Button(action: addItem) {
							Label("Add Item", systemImage: "plus")
						}
					}
					
//										dev only
//					ToolbarItem(placement: .navigationBarLeading) {
//						Button(action: deleteAll) {
//							Label("delete All", systemImage:"trash")
//						}
//					}
				}
		} detail: {
		}
		
		VStack {
			Divider()
			HStack {
				Text(currentCurrency)
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
				Keypad(string: $string)
					.frame(height: isShowingKeypad ? screenHeight / 3.5 : 0)
					.opacity(isShowingKeypad ? 1 : 0)
					.offset(y: isShowingKeypad ? 0 : screenHeight)
					.transition(.move(edge: .bottom))
					.padding()
			}
		}
		.font(.largeTitle)
		.onAppear {
			// print("Loading Exchange rate data...")
			 fetchData()
		}
						
	}
	
	
	private func addItem() {
		withAnimation(.easeInOut(duration: 0.2)) {
			if let balance = Double(string) {
				if string != "0" {
					let newItem = Item(timestamp: Date(), balance: String(balance))
					modelContext.insert(newItem)
					UISelectionFeedbackGenerator().selectionChanged()
					string = "0"
				}
			}
		}
	}
	
	private func deleteItems(offsets: IndexSet) {
		withAnimation() {
			for index in offsets {
				modelContext.delete(items[index])
			}
		}
	}
	
	private func deleteFirst() {
		withAnimation() {
			if let firstGroup = items.sortedByDate().first,
			   let recentItem = firstGroup.1.first {
				modelContext.delete(recentItem)
				UISelectionFeedbackGenerator().selectionChanged()
			}
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
