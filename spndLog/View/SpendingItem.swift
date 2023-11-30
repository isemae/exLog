//
//  SpendingItem.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct SpendingItem: View {
	@Binding var ampm: Bool
	var item: Item
	var prevItem: Item?
	
	var body: some View {
		LazyVStack(alignment: .leading, spacing: 0) {
				HStack {
			if !shouldGroupByMinute() {
					Text(ampm ? "\(dateFormat(for: item.timestamp, format: "hhmm"))" : "\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
						.font(.title3)
						.frame(maxWidth: .infinity)
						.fixedSize(horizontal: true, vertical: false)
						.onTapGesture {
							withAnimation(.linear(duration: 0.2)) {
								ampm.toggle()}}
			}		
					Spacer()
					if !shouldGroupByCurrency() {
						ZStack {
							RoundedRectangle(cornerRadius: 12)
								.stroke(Color(uiColor: UIColor.secondarySystemBackground))
							Text("\(item.currency) → ₩")
								.font(.headline)
								.foregroundColor(.primary)
								.padding(5)
						}
						//					.opacity(opacityForItem(item))
						.fixedSize()
					}
				}
			
			HStack (alignment: .center) {
				ZStack {
					RoundedRectangle(cornerRadius: 12)
						.foregroundColor(.secondary)
					Text("category")
						.font(.headline)
						.foregroundColor(.primary)
						.padding(5)
				}
				.fixedSize()
				Spacer()
				Text("₩\(item.calculatedBalance)")
					.font(.title2)
			}
			.padding([.top], 5)
			Divider()
		}
//		.padding(.top, 10)
		.padding([.leading, .trailing], 25)
	}
	
	private func shouldGroupByMinute() -> Bool {
		guard let prevItem = prevItem else {
			return false
		}
		let isMinuteSame = Calendar.current.isDate(item.timestamp, equalTo: prevItem.timestamp, toGranularity: .minute)
		return isMinuteSame
	}
	
	private func shouldGroupByCurrency() -> Bool {
		guard let prevItem = prevItem else {
			return false
		}
		let isCurrencySame = item.currency == prevItem.currency
		return isCurrencySame
	}
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

