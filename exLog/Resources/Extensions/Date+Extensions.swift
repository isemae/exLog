//
//  Extension+Date.swift
//  exLog
//
//  Created by Jiwoon Lee on 2/2/24.
//

import Foundation

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
