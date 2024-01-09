//
//  extensions.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/23/23.
//

import SwiftUI

enum UIRole: String {
	case main
	case secondary
	case unknown
}

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

extension Int {}
extension Color {
	static var primaryColor: Color {
		Color(UIColor { $0.userInterfaceStyle == .dark ? .white : .black })
	}
}

extension Text {
	func getContrastText(backgroundColor: Color) -> some View {
		var red,green,blue,alpha: CGFloat
		(red,green,blue,alpha) = (0,0,0,0)
		UIColor(backgroundColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
		return luminance < 0.6 ? self.foregroundColor(.white) : self.foregroundColor(.black)
	}
}

extension View {
	func safeAreaOverlay(alignment: Alignment, edges: Edge.Set) -> some View {
		self.overlay(alignment: alignment) {
			Color(uiColor: UIColor.systemBackground)
				.ignoresSafeArea(edges: edges)
				.frame(height: 0)
		}
	}
	func overlayDivider(alignment: Alignment, state: Bool? = nil) -> some View {
		self.overlay(
			Divider()
				.opacity(state == true ? 0 : 1)
				.foregroundColor(Color(uiColor: UIColor.systemGray))
			,
			alignment: alignment
		)
	}
	func overlayDividers(state: Bool? = nil, role: UIRole = .unknown) -> some View {
		return self
			.overlayDivider(alignment: .top, state: state)
			.overlayDivider(alignment: .bottom, state: state)
	}
}

extension String {
	// formats keypad num
	func formatNumber() -> String {
		if let doubleValue = Double(self) {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			return formatter.string(from: NSNumber(value: doubleValue)) ?? ""
		}
		return ""
	}
}

extension Array where Element == Item {
	func sortedByDate() -> [(Date, [Item])] {
		let groupedDictionary = Dictionary(grouping: self) { item in
			Calendar.current.startOfDay(for: item.date)
		}
		let sortedGroups = groupedDictionary.sorted { $0.key > $1.key }
		let sortedItemsInGroups = sortedGroups.map { (date, items) in
			(date, items.sorted(by: { $0.date > $1.date }))
		}
		return sortedItemsInGroups
	}
}
