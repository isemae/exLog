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
	init(timestamp: Date, balance: String) {
        self.timestamp = timestamp
		self.balance = balance
		self.id = UUID()
    }
	var calculatedBalance: Int {
			if let balance = Double(balance) {
				return Int(round(balance * dealBasisRate))
			}
			return 0
		}
	let dealBasisRate = (Double(filteredResponse?.deal_bas_r ?? "1000") ?? 1.0) / 1000
}
