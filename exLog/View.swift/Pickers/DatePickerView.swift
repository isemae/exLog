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

	@State var startDate = Date.distantPast
	@State var endDate = Date.distantFuture

	@State var dateRange: Set<DateComponents> = []
	@Binding var selectedDates: [Date]
//	@State var dateRange: ClosedRange<Date>? = nil

	private var dates: [Date] {
		guard !dateRange.isEmpty else { return [] }

		let formatter = DateFormatter()
		formatter.dateStyle = .short

		return dateRange.map { components in
			guard let date = components.date else { return Date() }
			return date
		}
	}

	var body: some View {
		MultiDatePicker("", selection: $dateRange)
			.environment(\.locale, Locale.init(identifier: "ko_kr"))
			.environment(\.calendar.locale, Locale.init(identifier: "ko_kr"))
			.onChange(of: dateRange) { _ in

				//				if selectedDates.contains($dateRange.first) {
				//					selectedDates.removeAll(where: { $0 == $dateRange.first })
				//				} else {
				//					selectedDates.append($dateRange.first)
				//				}
				//
				if dateRange.count > 2 {
					dateRange.removeAll()

					//					if let firstSelectedDate = selectedDates.first {
					//					dateRange.insert(calendar.dateComponents([.year, .month, .day], from: selectedDates.last ?? Date()))
					//					}
					//					selectedDates.append($dateRange.first)
				}
			}
			.frame(maxHeight: Screen.height / 2)

//		HStack {
//			Text(formattedDate(date: dates.sorted().first))
//			if dates.count >= 2 {
//				Text(formattedDate(date: dates.sorted().last))
//			}
//		}

		HStack(spacing: 10) {
			if let startDate = dateRange.first {
				Text(formattedDateComponent(dateComponent: startDate) ?? "")
			}
			Spacer()

			if dateRange.count > 1 {
//				if let endDate = dateRange.last {
//					Text(formattedDateComponent(dateComponent: endDate))
//				}
//			}
		}
	}
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
