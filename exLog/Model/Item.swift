//
//  Item.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Item: Identifiable {
	var id = UUID()
	var date: Date
	var balance: String
	var currency: Currency
	var category: Category?
	var desc: String?
	var image: Data?
	var location: Location?
	//	@Relationship(inverse: \FoldedItems.items)
	init(date: Date, balance: String = "", currency: Currency, category: Category? = nil, desc: String? = nil, location: Location? = nil) {
		self.date = date
		self.balance = balance
		self.currency = currency
		self.category = category
		self.desc = desc
		self.location = location
	}

	var calculatedBalance: Int {
		get {
			if let storedValue = UserDefaults.standard.value(forKey: "calculatedBalance_\(id)") as? Int {
				return storedValue
			} else {
				return calculateAndSaveBalance()
			}
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: "calculatedBalance_\(id)")
		}
	}

	private func calculateAndSaveBalance() -> Int {
		if let balance = Double(balance) {
			let calculatedValue = Int(round(balance * ResponseManager.shared.dealBasisRate))
			UserDefaults.standard.setValue(calculatedValue, forKey: "calculatedBalance_\(id)")
			return calculatedValue
		}
		return 0
	}
}

@Model
class Location: Identifiable, Hashable {
	@Relationship(inverse: \Item.location) var items : [Item]?
	var id = UUID()
	var name: String
	var startDate: Date?
	var endDate: Date?
	var bgImage: Data?
	@Attribute(.externalStorage) var imageData: Data?

	init(name: String, startDate: Date, endDate: Date, items: [Item], imageData: Data? = nil) {
		self.name = name
		self.startDate = startDate
		self.endDate = endDate
		self.items = items
		self.imageData = imageData
	}
}

extension Array where Element: Item {
	subscript(id: Item.ID?) -> Item? {
		first { $0.id == id}
	}
}
