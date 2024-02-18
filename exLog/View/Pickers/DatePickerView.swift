//
//  DatePickerView.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/5/24.
//

import SwiftUI

struct DatePickerView: View {
	@State var dateRange: Set<DateComponents> = []
	@Binding var selectedDates: [Date]

	private var dates: [Date] {
		guard !dateRange.isEmpty else { return [] }
		return dateRange.compactMap { $0.date }
	}

	var body: some View {
		MultiDatePicker("날짜 선택", selection: $dateRange)
			.frame(maxHeight: Screen.height / 2)
			.onAppear {
				dateRange.removeAll()
				selectedDates.removeAll()
			}
			.onChange(of: dateRange) { _ in
				if dateRange.count > 2 {
					dateRange.removeAll()
					selectedDates.removeAll()
				}
				withAnimation(.spring(duration: 0.3)) {
					selectedDates = dates.sorted()
					print(dateRange)
				}
			}

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

//
// #Preview {
//    DatePickerView()
// }
