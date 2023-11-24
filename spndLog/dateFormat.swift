//
//  date.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/24/23.
//

import Foundation
import SwiftUI
func dateFormat(_ format: String) -> String {
	let date = Date()
	let dateFormatter = DateFormatter()
	
	switch format {
	case "yymmdd":
		dateFormatter.dateFormat = "yyMMdd"
	case "mm/dd":
		dateFormatter.dateFormat = "MM/dd"
	case "dd":
		dateFormatter.dateFormat = "dd"
	default:
		dateFormatter.dateFormat = "yyyyMMdd"
	}
	
	return dateFormatter.string(from: date)
}

func dayColor() -> Color {
	let calendar = Calendar.current
	let currentDay = calendar.component(.weekday, from: Date())
	
	switch currentDay {
	case 1:
		return Color.red
	case 7:
		return Color.blue
	default:
		return Color.gray
	}
}

let calendar = Calendar.current
let currentData = Date()
let AM11 = DateComponents(hour: 11, minute: 0)

struct DateView: View {
	
	var body: some View {
		Text(dateFormat("yymmdd"))
		Text(dateFormat("mmdd"))
		Text(dateFormat("dd"))
		Text(dateFormat("흠그정돈가"))
	}
}

#Preview {
	DateView()
}



