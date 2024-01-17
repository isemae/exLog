//
//  SpendingItem.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct SpendingItem: View {
	var ampm: Bool
	var item: Item

	var body: some View {
		VStack {
			HStack(alignment: .center, spacing: 0) {
				categoryView()
				Spacer()
				Text("₩\(item.calculatedBalance)")
					.font(.title2)
			}
			.foregroundColor(Color(uiColor: .label))
			.padding(.vertical, 5)
			.padding(.horizontal, 10)
			.background(.green)
			.contextMenu(menuItems: {
				ForEach(Category.allCases, id: \.self) { category in
					Button {
						item.category = category
					} label: {
						Text("\(category.symbol)")
					}
				}
			})
		}
	}

	func localCurrencyValue() -> some View {
		HStack {
			Text("\(item.currency.symbol) \(item.balance.formatNumber()) ")
				.padding(5)
				.font(.body)
			Spacer()
			Image(systemName: "arrow.left.arrow.right")
				.font(.system(size: 15))
		}
	}

	func categoryView() -> some View {
		HStack(spacing: 0) {
			if (item.category != nil) {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundStyle(Color.accentColor)
					Text(item.category!.symbol)
						.padding(5)
				}
				.fixedSize()
			}
			localCurrencyValue()
		}
		.frame(width: UIScreen.main.bounds.size.width / 2.3, alignment: .leading)
	}
}

//// 여러 통화 사용시 통화기호를 구분
//	private func showCurrency() -> Bool {
//		guard let prevItem = prevItem else {
//			return true
//		}
//		let isCurrencySame = item.currency != prevItem.currency
//		return isCurrencySame
//	}

//// 시간순서에 따라 항목 투명도 조절
//	func opacityForItem(_ item: Item, _ items: [Item]) -> Double {
//		let minOpacity: Double = 0.5
//		
//		if let index = items.firstIndex(of: item) {
//			let opacity = Double(index + 1) / Double(items.count)
//			return max(opacity, minOpacity)
//		}
//		return 1.0
//	}

#Preview {
	SpendingItem(ampm: true, item: createTestItems().first!)
}
