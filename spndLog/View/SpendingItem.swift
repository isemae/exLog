//
//  SpendingItem.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct SpendingItem: View {
	var ampm: Bool
	var item: Item
	
	var body: some View {
		HStack (alignment: .center) {
			LocalCurrencyValue()
			Spacer()
			Text("₩\(item.calculatedBalance)")
				.font(.title2)
		}
		.padding(.vertical, 5)
		.padding(.horizontal, 10)
	}
	
	func LocalCurrencyValue() -> some View {
		HStack {
			//			RoundedRectangle(cornerRadius: 12)
			//				.stroke(Color(uiColor: UIColor.secondarySystemBackground))
			Text("\(item.currency.symbol) \(item.balance.formatNumber())")
				.font(.headline)
				.foregroundColor(.gray)
				.frame(width: UIScreen.main.bounds.size.width / 3.5, alignment: .leading)
			Image(systemName: "arrow.right")
			Spacer()
			//					.opacity(opacityForItem(item))
		}
		//		.fixedSize()
	}
}
	
	
//	func CategoryIconView() -> some View {
//		ZStack {
//			RoundedRectangle(cornerRadius: 12)
//				.foregroundColor(.secondary)
//			Text("category")
//				.font(.headline)
//				.foregroundColor(.primary)
//				.padding(5)
//		}
//		.fixedSize()
//	}
	
//	private func showCurrency() -> Bool {
//		guard let prevItem = prevItem else {
//			return true
//		}
//		let isCurrencySame = item.currency != prevItem.currency
//		return isCurrencySame
//	}
	
//	func opacityForItem(_ item: Item, _ items: [Item]) -> Double {
//		let minOpacity: Double = 0.5
//		
//		if let index = items.firstIndex(of: item) {
//			let opacity = Double(index + 1) / Double(items.count)
//			return max(opacity, minOpacity)
//		}
//		return 1.0
//	}
	

