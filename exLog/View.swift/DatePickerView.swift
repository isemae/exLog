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
	@State private var selectedDates: [Date] = []
	
	var body: some View {
		Form {
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
		}
		
//		ForEach(Array(dateRange), id: \.self) { dateComponent in
//			if let formattedDate = formattedDate(dateComponent: dateComponent) {
//				Text(formattedDate)
//			}
//		}
	}
	
	func formattedDate(dateComponent: DateComponents) -> String? {
		   let formatter = DateFormatter()
		   formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

		   guard let date = Calendar.current.date(from: dateComponent) else {
			   return nil
		   }
		   return formatter.string(from: date)
	   }
	
	private func formattedDate(date: Date) -> String {
			let formatter = DateFormatter()
			formatter.dateStyle = .long
			return formatter.string(from: date)
		}
}

#Preview {
    DatePickerView()
}
