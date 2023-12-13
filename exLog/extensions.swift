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

extension Int {}
extension Color {
	static var primaryColor: Color {
		Color(UIColor { $0.userInterfaceStyle == .dark ? .white : .black })
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
					.foregroundColor(state == true ? Color(uiColor: UIColor.tertiaryLabel) : Color(uiColor: UIColor.secondaryLabel) ),
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
