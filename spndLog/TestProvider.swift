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
	items.append(Item(date: Date(), balance: "100", currency: .JPY))
	items.append(Item(date: Date().addingTimeInterval(-600), balance: "5000", currency: .AUD))
	items.append(Item(date: Date().addingTimeInterval(-3600), balance: "50", currency: .CAD))
	// Add more test items as needed

	return items
}
