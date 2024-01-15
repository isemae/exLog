//
//  date.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/24/23.
//

import Foundation
import SwiftUI

func formattedDateComponent(dateComponent: DateComponents) -> String? {
	let formatter = DateFormatter()
	formatter.locale = Locale(identifier: "ko_kr")
	formatter.dateStyle = .long

	guard let date = Calendar.current.date(from: dateComponent) else {
		return nil
	}
	return formatter.string(from: date)
}

func formattedDate(date: Date?) -> String {
	let formatter = DateFormatter()
	formatter.dateStyle = .long
	formatter.timeStyle = .none
	formatter.locale = Locale(identifier: "ko_kr")
	if let validDate = date {
		return formatter.string(from: validDate)
	} else {
		return ""
	}
}

func dateFormatString(for date: Date, format: String) -> String {
		let dateFormatter = DateFormatter()

		switch format {
		case "yymmdd":
			dateFormatter.dateFormat = "yyMMdd"
		case "mm/dd":
			dateFormatter.dateFormat = "MM/dd"
		case "mm":
			dateFormatter.dateFormat = "MM"
		case "dd":
			dateFormatter.dateFormat = "dd"
		case "aahhmm":
			dateFormatter.dateFormat = "a h:mm"
		case "hhmm":
			dateFormatter.dateFormat = "HH:mm"
		default:
			dateFormatter.dateFormat = "yyyyMMdd"
		}
		return dateFormatter.string(from: date)
}

func dayColor(for date: Date) -> Color {
	let calendar = Calendar.current
	let currentDay = calendar.component(.weekday, from: date)

	switch currentDay {
	case 1:
		return Color.red
	case 7:
		return Color.blue
	default:
		return Color.primary
	}
}

let calendar = Calendar.current
let currentDate = Date()
let AM11 = DateComponents(hour: 11, minute: 0)

struct DateView: View {

	var body: some View {
		Text(dateFormatString(for: currentDate, format: "yymmdd"))
		Text(dateFormatString(for: currentDate, format:"mmdd"))
		Text(dateFormatString(for: currentDate, format:"dd"))
		Text(dateFormatString(for: currentDate, format:"흠그정돈가"))
	}
}

#Preview {
	DateView()
}
