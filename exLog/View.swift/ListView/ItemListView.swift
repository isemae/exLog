//
//  SpendingList.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/30/23.
//
import SwiftUI
import SwiftData

struct ItemListView: View {
	@EnvironmentObject private var dataModel: DataModel
	var items: [Item]
	var onTap: () -> Void
	var location: String?
	var body: some View {
		let dateGroup: [Date: [Item]] = Dictionary(grouping: items) { item in
			Calendar.current.startOfDay(for: item.date) }
		let minuteGroup: [Date: [Date: [Item]]] = dateGroup.mapValues { itemsInDate in
			Dictionary(grouping: itemsInDate) { item in
				var components = Calendar.current.dateComponents([.hour, .minute], from: item.date)
				var date = Calendar.current.date(from: components)!
				return date
			}
		}

		List {
			ForEach(dateGroup.sorted(by: { $0.key > $1.key }), id: \.key) { date, group in
				let sumForDate = group.reduce(0) { $0 + $1.calculatedBalance }
				dayList(group: minuteGroup[date] ?? [:], date: date, sumForDate: sumForDate)
			}
			.listRowInsets(EdgeInsets())
			.listRowSeparator(.hidden)
			.listRowBackground(Color(uiColor: .systemBackground))
		}
		.listStyle(.insetGrouped)
		.background(Color(uiColor: .systemBackground))
		.environment(\.defaultMinListRowHeight, 12)
		.environment(\.defaultMinListHeaderHeight, 0)
	}

	func dayList(group: [Date: [Item]], date: Date, sumForDate: Int) -> some View {
		Section(
			header: DateHeader(items: items, date: date, sumForDate: sumForDate)
				.environmentObject(dataModel)
		) {
			ForEach(group.keys.sorted().reversed(), id: \.self) { minuteDate in
				if let itemsInMinute = group[minuteDate], !itemsInMinute.isEmpty && !dataModel.foldedItems[date, default: false] {
					Group {
						HHmmHeader(date: minuteDate)
						ForEach(itemsInMinute, id: \.id) { item in
							SpendingItem(ampm: dataModel.ampm, item: item)
						}
					}
					.background(Color(uiColor: .secondarySystemGroupedBackground).edgesIgnoringSafeArea(.all))
				}
			}
		}
	}
}
//
// #Preview {
//	ItemListView(string: <#Binding<String>#>, items: createTestItems(), onTap: {print("hello")})
//		.environmentObject(DataModel())
// }
