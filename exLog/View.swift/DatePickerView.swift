//
//  DatePickerView.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/5/24.
//

import SwiftUI
import UIKit

struct DateRangePicker: UIViewRepresentable {
	@Binding var selectedDates: [Date]
	
	func makeUIView(context: Context) -> some UIDatePicker {
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
		return datePicker
	}
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject {
		var parent: DateRangePicker
		
		init(_ parent: DateRangePicker) {
			self.parent = parent
		}
		
		@objc func dateChanged(_ sender: UIDatePicker) {
			let selectedDate = sender.date
			
			parent.selectedDates.removeAll(where: { $0 == selectedDate })
			parent.selectedDates.append(selectedDate)
			
			if parent.selectedDates.count > 2 {
				parent.selectedDates.removeAll()
				parent.selectedDates.append(selectedDate)
			}
		}
	}
}

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
