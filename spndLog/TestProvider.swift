//
//  TestProvider.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/30/23.
//

import Foundation
import SwiftData

func createTestItems() -> [Item] {
	var items: [Item] = []
	let currentDate = Date()

	// Add test data
	items.append(Item(date: Date(), balance: "100", currency: .JPY))
	items.append(Item(date: Date().addingTimeInterval(-600), balance: "5000", currency: .AUD))
	items.append(Item(date: Date().addingTimeInterval(-3600), balance: "50", currency: .CAD))
	items.append(Item(date: Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!, balance: "50", currency: .CAD))
	items.append(Item(date: Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!, balance: "50", currency: .CAD))
	// Add more test items as needed

	return items
}
