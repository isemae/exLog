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

	// Add test data
	let currentDate = Date()
	items.append(Item(date: currentDate, balance: "100", currency: "¥"))
	items.append(Item(date: currentDate.addingTimeInterval(-3600), balance: "50", currency: "€"))
	// Add more test items as needed

	return items
}
