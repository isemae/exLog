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
	var prevItem: Item?
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if /*showCurrency() ||*/ shouldGroupBy(.minute, item: item) {
				ItemMinuteView()
				Divider()
					.padding(.bottom, 10)
			}
			ItemContent()
		}
//		.padding(.top, 10)
		.padding(.horizontal, 10)
		
	}
	func ItemContent() -> some View {
		HStack (alignment: .center) {
//				CategoryIcon()
//				if showCurrency() {
				CurrencyIconView()
//				}
			Spacer()
			Text("₩\(item.calculatedBalance)")
				.font(.title2)
		}
	}
	
	func ItemMinuteView() -> some View {
		HStack {
			if shouldGroupBy(.minute, item: item) {
				Text(ampm ? "\(date, format: Date.FormatStyle(date: .none, time: .shortened))" : "\(dateFormat(for: date, format: "hhmm"))" )
					.font(.title3)
					.frame(maxWidth: .infinity)
					.fixedSize(horizontal: true, vertical: false)
					.onTapGesture {
						ampm.toggle()
						UserDefaults.standard.set(ampm, forKey: "ampm")}
			}
			Spacer()

		}
		.padding(.top, 10)
	}
	
	func CategoryIconView() -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 12)
				.foregroundColor(.secondary)
			Text("category")
				.font(.headline)
				.foregroundColor(.primary)
				.padding(5)
		}
		.fixedSize()
	}
	
	func CurrencyIconView() -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color(uiColor: UIColor.secondarySystemBackground))
			Text("\(item.currency) → ₩")
				.font(.headline)
				.foregroundColor(.gray)
				.padding(5)
			//					.opacity(opacityForItem(item))
		}
		.fixedSize()
	}
	
	func shouldGroupBy(_ time: Calendar.Component, item: Item) -> Bool {
		guard let prevItem = prevItem else {
			return true
		}
		let isDaySame = !Calendar.current.isDate(date, equalTo: prevItem.date, toGranularity: time)
		return isDaySame
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

