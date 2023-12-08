//
//  SpendingList.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/30/23.
//

import SwiftUI
import SwiftData

struct DayListView: View {
	@Environment(\.modelContext) private var modelContext
	@EnvironmentObject private var dataModel: DataModel
	
//	@Query var items: [Item]
	@Query var groups: [ItemGroup]
	var items: [Item]
	var itemsArray: [Item] = []
	//	var dateDict: [Date: [[Item]]] = [:]
	
	var onTap: () -> Void
	var body: some View {
		//			ForEach(dateDict.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
		//			ForEach(items)) { date in
		//				let sumForDate = dateDict[date]?.reduce(0) { $0 + $1.calculatedBalance }
		//				if let itemsForDate = dateDict[date] {
		//					if shouldShow(.day, items: items, date: date) {
		//						DateHeader(dataModel: dataModel, items: itemsForDate, date: date, sumForDate: sumForDate!, onTap: onTap, isFolded: dataModel.foldedItems[date, default: false])
		//						if !dataModel.foldedItems[date, default: false] {
		//							Text(dateFormat(for: dateDict[date]!.first!.date, format: "aahhmm")
		let dateGroup: [Date: [Item]] = Dictionary(grouping: groupedItems.flatMap { $0 }) { item in
			Calendar.current.startOfDay(for: item.date)
		}
		
		List {
			ForEach(dateGroup.sorted(by: { $0.key > $1.key }), id: \.key) { date, itemsInDate in
				TimeList(items: itemsInDate, date: itemsInDate.first!.date)
			}
			.listRowInsets(EdgeInsets())
			.listRowSeparator(.hidden)}
		
		.listStyle(.plain)
		.listSectionSpacing(.compact)
		.safeAreaOverlay(alignment: .top, edges: .top)
	}
		
	func TimeList(items: [Item], date: Date) -> some View {
		Section(
			header: DateHeader(items: items, date: date)
		) {
//// hang
			ForEach(groupedItems.indices, id: \.self) { index in
//				HHmmHeader(groupedItems[index].first!.date)
				ForEach(groupedItems[index], id: \.id) { item in
					SpendingItem(ampm: dataModel.ampm, item: item)
				}
			}
////
		}
	}
	
	private var groupedItems: [[Item]] {
//// hang
		Dictionary(grouping: items){ item in
			dataModel.formattedHeaderDate(item.date)
		}
////
		.values
		.sorted(by: { $0.first!.date > $1.first!.date })
	}
	
	
	
	func HHmmHeader(_ date: Date) -> some View {
		HStack {
			Image(systemName: "clock")
			Text(dataModel.ampm ? "\(date, format: Date.FormatStyle(date: .none, time: .shortened))" : "\(dateFormatString(for: date, format: "hhmm"))" )
				.font(.title3)
				.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
				.fixedSize()
			Spacer()
		}
//		.padding(10)
		.overlayDividers()
		.onTapGesture {
			dataModel.ampm.toggle()
			UserDefaults.standard.set(dataModel.ampm, forKey: "ampm")
		}
		
	}
	
//	private func groupItems(items: inout [Item]) {
//		guard items.count > 1 else { return }
//		
//		let lastIndex = items.count - 1
//		var currentItem = items[lastIndex]
//		
//		for (index, item) in items.enumerated().reversed() {
//			if index > 0 {
//				let previousItem = items[index - 1]
//				let calendar = Calendar.current
//				let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: previousItem.date, to: currentItem.date)
//				
//				// 이전 아이템과 현재 아이템이 같은 분 내에 추가된 경우 그룹화
//				if let minutes = components.minute, minutes == 0 {
//					currentItem.group = ItemGroup(pos: (previousItem.group?.pos ?? -1) + 1)
//					break
//				}
//			}
//		}
//	}
	
//	func shouldShow(_ format: Calendar.Component, currentItem: Item, prevItem: Item?) -> Bool {
//		guard let prevItem = prevItem else {
//			return true
//		}
//		
//		let shouldShow = !Calendar.current.isDate(prevItem.date, equalTo: currentItem.date, toGranularity: format)
//		return shouldShow
//	}
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
	
//	func opacityForItem(_ item: Item) -> Double {
//		let minOpacity: Double = 0.5
//		
//		if let index = items.firstIndex(of: item) {
//			let opacity = Double(index + 1) / Double(items.count)
//			return max(opacity, minOpacity)
//		}
//		return 1.0
//	}
}
	

//
//#Preview {
//	DayListView(onTap: {print("hello")}, items: <#[Item]#>)
//		.environmentObject(DataModel())
//}
