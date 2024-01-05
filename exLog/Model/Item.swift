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
	var group: ItemGroup?
	var category: Category?
	var image: Data?
	var location: Location?
	
	//	@Relationship(inverse: \FoldedItems.items)
	init(date: Date, balance: String = "", currency: Currency ) {
		self.date = date
		self.balance = balance
		self.currency = currency
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
			let calculatedValue = Int(round(balance * DataManager.shared.dealBasisRate))
			UserDefaults.standard.setValue(calculatedValue, forKey: "calculatedBalance_\(id)")
			return calculatedValue
		}
		return 0
	}
}

@Model
class Location: Identifiable, Hashable {
	var name: String
	var startDate: Date?
	var endDate: Date?
	var items: [Item]?
//	var image: UIImage?
	
	init(name: String) {
		self.name = name
	}
}

extension Array where Element: Item {
	subscript(id: Item.ID?) -> Item? {
		first { $0.id == id}
	}
}


@Model
class ItemGroup {
	var pos: Int
	init(pos: Int) {
		self.pos = pos
	}
}
