//
//  Item.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import Foundation
import SwiftData

@Model
final class Item {
	var id: UUID
    var date: Date
	var balance: String
	var currency: String
	init(date: Date, balance: String = "", currency: String = "") {
		self.id = UUID()
		self.date = Date()
		self.balance = balance
		self.currency = currency
	}
	
	var calculatedBalance: Int {
			if let balance = Double(balance) {
				return Int(round(balance * dealBasisRate))
			}
			return 0
		}
	
	let dealBasisRate = (Double(filteredResponse?.basePrice ?? 100) ) / Double(filteredResponse?.currencyUnit ?? 100)
}

extension Array where Element: Item {
	subscript(id: Item.ID?) -> Item? {
		first { $0.id == id}
	}
}

