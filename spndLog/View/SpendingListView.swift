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
		Dictionary(grouping: items) { item in
			Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: item.date)!
		}
	}
	var onTap: () -> Void
	var body: some View {
		List {
			ForEach(dateDict.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
				let sumForDate = dateDict[date]?.reduce(0) { $0 + $1.calculatedBalance }
				if let itemsForDate = dateDict[date] {
//					if shouldShow(.day, items: items, date: date) {
						DateHeader(dataModel: dataModel, items: itemsForDate, date: date, sumForDate: sumForDate!, onTap: onTap, isFolded: dataModel.foldedItems[date, default: false])
						if !dataModel.foldedItems[date, default: false] {
							//					Text(dateFormat(for: dateDict[date]!.first!.date, format: "aahhmm"))

							var prevItem: Item?
							ForEach(itemsForDate.reversed()) { item in
								let showHeader = shouldShow(.minute, currentItem: item, prevItem: prevItem)
//								prevItem = item
								HHmmHeader(showHeader: showHeader, item: item, date: item.date)

								SpendingItem(ampm: $ampm, date: item.date, item: item)
							

								
								
								//							let currentIndex = itemsForDate.lastIndex(of: item)
								//							let prevDate = currentIndex! > 0 ? itemsForDate[currentIndex! - 1].date : nil
								
								//							if shouldShow(.minute, items: itemsForDate, date: item.date) {
								
								//						ItemMinuteView(date: dateDict[date]!.first!.date)
								
								//							let currentIndex = itemsForDate.firstIndex(of: item)!
								//							let prevItem = currentIndex > 0 ? itemsForDate[currentIndex - 1] : nil
								
							
								//								.opacity(opacityForItem(item))
							}
						}
//					}
					
				}
			}
			.listRowInsets(EdgeInsets())
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
		.listSectionSpacing(.compact)
		.safeAreaOverlay(alignment: .top, edges: .top)
	}
	
	func HHmmHeader(showHeader: Bool, item: Item, date: Date) -> some View {
		Group {
			if showHeader {
				HStack {
					Image(systemName: "clock")
					Text(ampm ? "\(item.date, format: Date.FormatStyle(date: .none, time: .shortened))" : "\(dateFormat(for: item.date, format: "hhmm"))" )
						.font(.title3)
						.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
						.fixedSize()
					Spacer()
				}
				.padding(10)
				.padding(.leading, 5)
				.overlay(Divider()
					.padding(.trailing, 10), alignment: .bottom)
				.onTapGesture {
					ampm.toggle()
					UserDefaults.standard.set(ampm, forKey: "ampm")
				}
			} else {
				EmptyView()
			}
		}
	}

	
	
	func shouldShow(_ format: Calendar.Component, currentItem: Item, prevItem: Item?) -> Bool {
		guard let prevItem = prevItem else {
			return true
		}

		let shouldShow = !Calendar.current.isDate(prevItem.date, equalTo: currentItem.date, toGranularity: format)
		return shouldShow
	}
//		let shouldShow = !Calendar.current.isDate(prevDate ?? Date(), equalTo: items.last!.date, toGranularity: format)
//		
//		
//			print("last: \(items.last!.date)")
//			print(currentIndex)
//			print("prev:\(String(describing: prevDate))")
//			print(shouldShow)
//			return shouldShow
		

	
//	func shouldShow(_ format: Calendar.Component, items: [Item], date: Date) -> Bool {
//		guard let prevItem = items.first, items.count > 1 else {
//			return true
//		}
//		
//		let isTimeSame = Calendar.current.isDate(prevItem.date, equalTo: date, toGranularity: .minute)
//		return !isTimeSame || items.firstIndex(of: prevItem) == 0
//	}

	func opacityForItem(_ item: Item) -> Double {
		let minOpacity: Double = 0.5
		
		if let index = items.firstIndex(of: item) {
			let opacity = Double(index + 1) / Double(items.count)
			return max(opacity, minOpacity)
		}
		return 1.0
	}
}


#Preview {
	SpendingList(items: createTestItems(), onTap: {print("hello")})
		.environmentObject(DataModel())
}
