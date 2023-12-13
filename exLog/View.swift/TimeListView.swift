////
////  TimeListView.swift
////  exLog
////
////  Created by Jiwoon Lee on 12/9/23.
////
////
//import SwiftUI
//
//struct TimeListView: View {
//	var items: [Item]
//	var date: Date
//	var dataModel: DataModel
//	
//	var body: some View {
//		Section(
//			header: DateHeader(items: items, date: date)
//		) {
//			ForEach(groupedItems.indices, id: \.self) { index in
//				HHmmHeader(groupedItems[index].first!.date)
//				ForEach(groupedItems[index], id: \.id) { item in
//					SpendingItem(ampm: dataModel.ampm, item: item)
//				}
//			}
//		}
//	}
//	
//	func HHmmHeader(_ date: Date) -> some View {
//		HStack {
//			Image(systemName: "clock")
//			Text(dataModel.ampm ? "\(date, format: Date.FormatStyle(date: .none, time: .shortened))" : "\(dateFormat(for: date, format: "hhmm"))" )
//				.font(.title3)
//				.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
//				.fixedSize()
//			Spacer()
//		}
////		.padding(10)
//		.overlayDividers()
//		.onTapGesture {
//			dataModel.ampm.toggle()
//			UserDefaults.standard.set(dataModel.ampm, forKey: "ampm")
//		}
//		
//	}
//	
//	private var groupedItems: [[Item]] {
//		Dictionary(grouping: items){ item in
//			dataModel.formattedHeaderDate(item.date)
//		}
//		.values
//		.sorted(by: { $0.first!.date > $1.first!.date })
//	}
//}
//
////
////#Preview {
////    TimeListView()
////}
