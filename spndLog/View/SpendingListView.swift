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
	var dateDict: [Date: [Item]] {
		Dictionary(grouping: items) { items in
			Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: items.date)!
		}
	}
	var onTap: () -> Void
	
	var body: some View {
		List {
			ForEach(dateDict.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
				let sumForDate = dateDict[date]?.reduce(0) { $0 + $1.calculatedBalance }
				if let itemsForDate = dateDict[date] {
					Section(
						header:	DateTitle(dataModel: dataModel, items: itemsForDate, date: date, sumForDate: sumForDate!, onTap: onTap)) {
							if !dataModel.foldedItems[date, default: false] {
								ForEach(itemsForDate) { item in
									let currentIndex = itemsForDate.firstIndex(of: item)!
									let prevItem = currentIndex > 0 ? itemsForDate[currentIndex - 1] : nil
									SpendingItem(ampm: $ampm, date: item.date, item: item, prevItem: prevItem)
										.padding(.horizontal, 15)
								}
							}
						}
				}
			}
			.listRowInsets(EdgeInsets())
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
		.safeAreaOverlay(alignment: .top, edges: .top)
	}
}


#Preview {
	SpendingList(items: createTestItems(), onTap: {print("hello")})
		.environmentObject(DataModel())
}
