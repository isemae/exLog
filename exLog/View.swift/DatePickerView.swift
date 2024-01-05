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
	
	@State private var dateRange: Set<DateComponents> = []

	var body: some View {
		Form {
			MultiDatePicker("", selection: $dateRange, in: Date()...)
				.environment(\.locale, Locale.init(identifier: "ko"))
				.environment(\.calendar.locale, Locale.init(identifier: "ko"))
		}
	}
	
	private func formattedDate(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		return dateFormatter.string(from: date)
	}
}

#Preview {
    DatePickerView()
}
