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
    var timestamp: Date
	var balance: String
	var currency: String
	init(timestamp: Date, balance: String, currency: String) {
        self.timestamp = timestamp
		self.balance = balance
		self.currency = currency
		self.id = UUID()
    }
	
	var calculatedBalance: Int {
			if let balance = Double(balance) {
				return Int(round(balance * dealBasisRate))
			}
			return 0
		}
	
	let dealBasisRate = (Double(filteredResponse?.basePrice ?? 100) ) / Double(filteredResponse?.currencyUnit ?? 100)
}
