//
//  SpendingItem.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct SpendingItem: View {
	@Binding var ampm: Bool
	var date: Date
	var item: Item
	
	var body: some View {
		ItemContent()
			.padding(.horizontal, 10)
	}
	
	func ItemContent() -> some View {
			HStack (alignment: .center) {
				NativeCurrencyValue()
				Spacer()
				Text("₩ \(item.calculatedBalance)")
					.font(.title2)
			}
			.padding(.horizontal, 5)
			.transition(.move(edge: .top))
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
	
	func NativeCurrencyValue() -> some View {
		HStack {
//			RoundedRectangle(cornerRadius: 12)
//				.stroke(Color(uiColor: UIColor.secondarySystemBackground))
			Text("\(item.currency.symbol) \(item.balance.formatNumber())")
				.font(.headline)
				.foregroundColor(.gray)
			Image(systemName: "arrow.right.square.fill")
			Spacer()
				
			//					.opacity(opacityForItem(item))
		}
//		.fixedSize()
	}
	
	
	
	
	
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
	
}

