//
//  ListViewModel.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/30/23.
//

import Foundation
import SwiftUI

class SpendingListViewModel: ObservableObject {
	@Published var items: [Item]
	@Published var foldedItems: [Date: Bool] = [:]

	init(items: [Item]) {
		self.items = items
	}

	func toggleFoldedItem(for date: Date) {
		foldedItems[date, default: false].toggle()
	}
}
