//
//  DatePickerView.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/5/24.
//

import SwiftUI

struct DatePickerView: View {
	@Environment(\.calendar) var calendar
	@Environment(\.timeZone) var timeZone

	//	@State var startDate = Date.distantPast
	//	@State var endDate = Date.distantFuture

	@State var dateRange: Set<DateComponents> = []
	@Binding var selectedDates: [Date]

	private var dates: [Date] {
		guard !dateRange.isEmpty else { return [] }
		return dateRange.compactMap { $0.date }
	}

	var body: some View {
		MultiDatePicker("", selection: $dateRange)
			.environment(\.locale, Locale.init(identifier: "ko_kr"))
			.environment(\.calendar.locale, Locale.init(identifier: "ko_kr"))
			.onAppear {
				dateRange.removeAll()
				selectedDates.removeAll()
			}
			.onChange(of: dateRange) { _ in
				if dateRange.count > 2 {
					dateRange.removeAll()
					selectedDates.removeAll()
				}
				selectedDates = dates.sorted()
			}
			.frame(maxHeight: Screen.height / 2)

		HStack(spacing: 10) {
			Text(formattedDate(date: dates.sorted().first))
			if dates.count >= 2 {
				Text(formattedDate(date: dates.sorted().last))
			}
		}

		//			Text(selectedDates, formatter: formattedDateComponent(dateComponent: dateRange))
		//			if dateRange.count > 1 {
		//				if let endDate = dateRange.endIndex {
		//					Text("\(dateRange)")
		//					Text(formattedDateComponent(dateComponent: endDate) ?? "")
		//				}
		//			}

		//		DateRangePicker(selectedDates: $selectedDates)
		//			.frame(maxHeight: Screen.height / 2)
		//			.onChange(of: selectedDates) { dates in
		//				selectedDates = dates.sorted()
		//			}
		//		ForEach(Array(dateRange), id: \.self) { dateComponent in
		//			if let formattedDate = formattedDate(dateComponent: dateComponent) {
		//				Text(formattedDate)
		//			}
		//		}
	}

}
//
// #Preview {
//    DatePickerView()
// }
extension DateComponents: Comparable {
	public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
		// 비교할 로직을 여기에 추가
		if let lhsDate = lhs.date, let rhsDate = rhs.date {
			return lhsDate < rhsDate
		}
		return false
	}
}
