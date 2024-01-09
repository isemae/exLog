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

	@State private var startDate = Date()
	@State private var endDate = Date()
	//	@State private var dateRange: Set<DateComponents> = []
	@Binding var selectedDates: [Date]
	var image: Image?

	var body: some View {
		//			MultiDatePicker("", selection: $dateRange, in: Date()...)
		//				.environment(\.locale, Locale.init(identifier: "ko"))
		//				.environment(\.calendar.locale, Locale.init(identifier: "ko"))
		HStack(spacing: 10) {
			if let startDate = selectedDates.first {
				Text("\(formattedDate(date: startDate))")
			}
			Spacer()
			if selectedDates.count > 1, let endDate = selectedDates.last {
				Text("\(formattedDate(date: endDate))")
			}
		}
		DateRangePicker(selectedDates: $selectedDates)
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
