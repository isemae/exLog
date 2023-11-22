//
//  extensions.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/23/23.
//

import SwiftUI

extension View {
	
}

extension String {
	
}

extension Array where Element == Item {
	func sortedByDate() -> [(Date, [Item])] {
		let groupedDictionary = Dictionary(grouping: self) { item in
			Calendar.current.startOfDay(for: item.timestamp)
		}
		
		let sortedGroups = groupedDictionary.sorted { $0.key > $1.key }
		
		let sortedItemsInGroups = sortedGroups.map { (date, items) in
			(date, items.sorted(by: { $0.timestamp > $1.timestamp }))
		}
		
		return sortedItemsInGroups
	}
}

//extension Int {
//	private func rateCalculated() -> Int {
//		let rate
//		return self * rate
//	}
//}
