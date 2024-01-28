//
//  date.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/24/23.
//

import Foundation
import SwiftUI

extension Date {
	var startDateOfYear: Date {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: self)) else {
			fatalError("Unable to get start date from date")
		}
		return date
	}

	var endDateOfYear: Date {
		guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfYear) else {
			fatalError("Unable to get end date from date")
		}
		return date
	}
}

let formatter = DateFormatter()

func formattedDateComponent(dateComponent: DateComponents) -> String? {
	formatter.locale = Locale(identifier: "ko_kr")
	formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
	formatter.dateStyle = .long

	guard let date = Calendar.current.date(from: dateComponent) else {
		return nil
	}
	return formatter.string(from: date)
}

func formattedDate(date: Date?) -> String {
	formatter.locale = Locale(identifier: "ko_kr")
	formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
	formatter.dateStyle = .long
	formatter.timeStyle = .none

	if let validDate = date {
		return formatter.string(from: validDate)
	} else {
		return ""
	}
}

func dateFormatString(for date: Date, format: String) -> String {
	formatter.locale = Locale(identifier: "ko_kr")
	formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

	switch format {
	case "yymmdd":
		formatter.dateFormat = "yyMMdd"
	case "mm/dd":
		formatter.dateFormat = "MM/dd"
	case "mm":
		formatter.dateFormat = "MM"
	case "dd":
		formatter.dateFormat = "dd"
	case "aahhmm":
		formatter.dateFormat = "h:mm a"
	case "hhmm":
		formatter.dateFormat = "HH:mm"
	default:
		formatter.dateFormat = "yyyyMMdd"
	}
	return formatter.string(from: date)
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

struct DateView: View {
	var body: some View {
		Text(dateFormatString(for: Date(), format: "yymmdd"))
		Text(dateFormatString(for: Date(), format:"mmdd"))
		Text(dateFormatString(for: Date(), format:"dd"))
		Text(dateFormatString(for: Date(), format:"흠그정돈가"))
	}
}

#Preview {
	DateView()
}
