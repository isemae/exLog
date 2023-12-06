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
		VStack(spacing: 0) {
			if /*showCurrency() ||*/ shouldGroupBy(.minute, item: item) {
				ItemMinuteView()
				Divider()
					.padding(.bottom, 15)
			}
			ItemContent()
		}
		.padding(.horizontal, 5)
		
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
		.padding(.horizontal, 5)
	}
	
	func ItemMinuteView() -> some View {
		HStack {
			if shouldGroupBy(.minute, item: item) {
				Image(systemName: "clock")
				Text(ampm ? "\(date, format: Date.FormatStyle(date: .none, time: .shortened))" : "\(dateFormat(for: date, format: "hhmm"))" )
					.font(.title3)
					.foregroundColor(Color(uiColor: UIColor.systemGray))
					.frame(maxWidth: .infinity)
					.fixedSize(horizontal: true, vertical: false)
			}
			Spacer()
		}
		.onTapGesture {
			ampm.toggle()
			UserDefaults.standard.set(ampm, forKey: "ampm")}
		.padding(.vertical, 5)
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
			Text("\(item.currency.code)")
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

