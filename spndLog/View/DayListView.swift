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
				let sumForDate = dateGroup[date]?.reduce(0) { $0 + $1.calculatedBalance }
				TimeList(items: itemsInDate, date: itemsInDate.first!.date, sumForDate: sumForDate ?? 0)
				
			}
			.listRowInsets(EdgeInsets())
			.listRowSeparator(.hidden)}
		
		.listStyle(.plain)
		.listSectionSpacing(0)
		.safeAreaOverlay(alignment: .top, edges: .top)
	}
		
	func TimeList(items: [Item], date: Date, sumForDate: Int) -> some View {
		Section(
			header: DateHeader(items: items, date: date, sumForDate: sumForDate)
		) {
			ForEach(groupedItems, id: \.first!.date) { group in
				HHmmHeader(group.first!.date)
				ForEach(group, id: \.id) { item in
					SpendingItem(ampm: dataModel.ampm, item: item)
				}
				
			}
		}
	}
	
	private var groupedItems: [[Item]] {
		Dictionary(grouping: items){ item in
			dataModel.formattedHeaderDate(item.date)
		}
		.values
		.sorted(by: { $0.first!.date > $1.first!.date })
	}
	
	
	
	func HHmmHeader(_ date: Date) -> some View {
		HStack {
			Image(systemName: "clock")
			Text(dataModel.ampm ? "\(date, format: Date.FormatStyle(date: .none, time: .shortened))" : "\(dateFormatString(for: date, format: "hhmm"))" )
				.font(.title3)
				.foregroundColor(Color(uiColor: UIColor.label))
				.fixedSize()
			Spacer()
		}
		.padding(.vertical, 10)
		.overlayDividers()
		.onTapGesture {
			dataModel.ampm.toggle()
			UserDefaults.standard.set(dataModel.ampm, forKey: "ampm")
		}
		
	}
	
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
	


#Preview {
	DayListView(items: createTestItems(), onTap: {print("hello")})
		.environmentObject(DataModel())
}
