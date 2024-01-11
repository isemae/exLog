//
//  UIDateRangePicker.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/6/24.
//

import SwiftUI
import UIKit

struct DateRangePicker: UIViewRepresentable {
	@Binding var selectedDates: [Date]

	func makeUIView(context: Context) -> some UIDatePicker {
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.preferredDatePickerStyle = .inline
		datePicker.locale = Locale(identifier: "ko_kr")
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
