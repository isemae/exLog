//
//  Sequence.swift
//  exLog
//
//  Created by Jiwoon Lee on 2/2/24.
//

import Foundation

extension Array where Element == Item {
	func groupByDate() -> [(Date, [Item])] {
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
