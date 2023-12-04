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
		VStack(alignment: .leading, spacing: 0) {
				if showCurrency() || showMinute() {
				HStack {
					if showMinute() {
						Text(ampm ? "\(item.date, format: Date.FormatStyle(date: .none, time: .shortened))" : "\(dateFormat(for: item.date, format: "hhmm"))" )
							.font(.title3)
							.foregroundColor(.gray)
							.frame(maxWidth: .infinity)
							.fixedSize(horizontal: true, vertical: false)
							.onTapGesture {
								ampm.toggle()
								UserDefaults.standard.set(ampm, forKey: "ampm")}
					}
					Spacer()
//					if showCurrency() {
						ZStack {
							RoundedRectangle(cornerRadius: 12)
								.stroke(Color(uiColor: UIColor.secondarySystemBackground))
							Text("\(item.currency) → ₩")
								.font(.headline)
								.foregroundColor(.primary)
								.padding(5)
							//					.opacity(opacityForItem(item))
						}
						.fixedSize()
//					}
				}
				.padding(.top, 10)
			
					Divider()
						.padding(.bottom, 10)
				}
				HStack (alignment: .center) {
					//				ZStack {
					//					RoundedRectangle(cornerRadius: 12)
					//						.foregroundColor(.secondary)
					//					Text("category")
					//						.font(.headline)
					//						.foregroundColor(.primary)
					//						.padding(5)
					//				}
					//				.fixedSize()
					
					Spacer()
					Text("₩\(item.calculatedBalance)")
						.font(.title2)
				}
				.padding([.top, .bottom], 5)
			
//			.background(.blue)
			
		}
//		.padding(.top, 10)
		.padding([.leading, .trailing], 25)
		
	}
	
	func shouldGroupByDay() -> Bool {
		guard let prevItem = prevItem else {
			return true
		}
		let isDaySame = !Calendar.current.isDate(item.date, equalTo: prevItem.date, toGranularity: .day)
		return isDaySame
	}
	
	private func showMinute() -> Bool {
		guard let prevItem = prevItem else {
			return true
		}
		let isMinuteSame = !Calendar.current.isDate(item.date, equalTo: prevItem.date, toGranularity: .minute)
		return isMinuteSame
	}
	
	private func showCurrency() -> Bool {
		guard let prevItem = prevItem else {
			return true
		}
		let isCurrencySame = item.currency != prevItem.currency
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

