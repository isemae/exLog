//
//  SpendingItem.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct SpendingItem: View {
	@State var isShowingPicker: Bool = false
	var item: Item
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				categoryView()
				VStack(alignment: .leading, spacing: 0) {
					item.desc.map { Text($0).font(.body) }
					localCurrencyValue()
				}
				Spacer()
				Image(systemName: "arrow.left.arrow.right")
					.font(.system(size: 15))
				Spacer()
				Text("₩\(item.calculatedBalance)")
					.font(.title3)
			}
		}
		.padding(10)
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

	func localCurrencyValue() -> some View {
		HStack {
			Text("\(item.currency.symbol) \(item.balance.formatNumber()) ")
				.padding(5)
				.font(.body)
		}
	}

	func categoryView() -> some View {
		HStack(spacing: 0) {
			if (item.category != .nil && item.category != nil) {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundStyle(.fill)
					Text(item.category?.symbol ?? "")
						.font(.title)
						.padding(5)
				}
				.fixedSize()

			}
		}
//		.onTapGesture {
//			isShowingPicker = true
//		}
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
	Group {
		SpendingItem(item: createTestItems().first!)
		List(createTestItems(), id: \.self) { item in
			SpendingItem(item: item)
		}
	}
}
