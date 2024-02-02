//
//  String+Extensions.swift
//  exLog
//
//  Created by Jiwoon Lee on 2/2/24.
//

import Foundation

extension String {
	func formatNumber() -> String {
		if let doubleValue = Double(self) {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			return formatter.string(from: NSNumber(value: doubleValue)) ?? ""
		}
		return ""
	}
}
