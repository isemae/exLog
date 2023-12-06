//
//  extensions.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/23/23.
//

import SwiftUI

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
