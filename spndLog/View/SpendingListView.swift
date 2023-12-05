//
//  SpendingList.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/30/23.
//

import SwiftUI

struct SpendingList: View {
	@EnvironmentObject private var dataModel: DataModel
	@State private var ampm: Bool = UserDefaults.standard.bool(forKey: "ampm")
	var items: [Item]
	var onTap: () -> Void
	
	var body: some View {
		//		let sumForDate = items.sortedByDate().reduce(into: 0) { $0 + $1.calculatedBalance }
		List {
			ForEach(items) { item in
				let currentIndex = items.firstIndex(of: item)!
				let prevItem = currentIndex > 0 ? items[currentIndex - 1] : nil
				
				DateTitle(dataModel: dataModel, item: item, prevItem: prevItem, onTap: onTap)
				if !dataModel.foldedItems[item.date, default: false] {
							Section {
								SpendingItem(ampm: $ampm, date: item.date, item: item, prevItem: prevItem)
						}
					}
			}
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
		
		//				ForEach(groupedByDate.sorted(by: { $0.0 > $1.0}), id: \.0) { date, itemsInDate in
		//					let sortedItems = itemsInDate.sorted { $0.date > $1.date }
		//					let sumForDate = sortedItems.reduce(0) { $0 + $1.calculatedBalance }
		//
		//					VStack(alignment: .leading, spacing: 0) {
		//						DateTitle(dataModel: dataModel, date: date, sumForDate: sumForDate, onTap: onTap)
		//						if !dataModel.foldedItems[date, default: false] {
		//							VStack(alignment: .center, spacing: 0) {
		//								ForEach(sortedItems, id: \.self) { item in
		//									let currentIndex = sortedItems.firstIndex(of: item)!
		//									let previousItem = currentIndex > 0 ? sortedItems[currentIndex - 1] : nil
		//									SpendingItem(ampm: $ampm, item: item, prevItem: previousItem)
		//								}
		//							}
		//							.padding([.top, .bottom])
		//						}
		//					}
		//				}
		//				.frame(width: UIScreen.main.bounds.width)
		
		//			.onChange(of: topTrigger) { _ in
		//				withAnimation(.spring()) {
		//					if let first = items.first {
		//						proxy.scrollTo(first.id, anchor: .top)
		//					}
		//				}
		//			}
	}
}
	


#Preview {
	SpendingList(items: createTestItems() , onTap: {print("hello")})
		.environmentObject(DataModel())
}
