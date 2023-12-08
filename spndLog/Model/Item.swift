//
//  Item.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import Foundation
import SwiftData
//
//@Model
//class FoldedItems {
//	var date: Date
//	var items: [Item]?
//	var isFolded: Bool
//	
//	init(date: Date, item: Item, items: [Item], isFolded: Bool) {
//		self.date = item.date
//		self.isFolded = isFolded
//	}
//}
//

@Model
final class Item {
	var id: UUID
	var date: Date
	var balance: String
	var currency: Currency
	
	//	@Relationship(inverse: \FoldedItems.items)
	init(date: Date, balance: String = "", currency: Currency) {
		self.id = UUID()
		self.date = Date()
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

extension Array where Element: Item {
	subscript(id: Item.ID?) -> Item? {
		first { $0.id == id}
	}
}


