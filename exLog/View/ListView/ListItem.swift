//
//  SpendingItem.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct ListItem: View {
	@State var isShowingPicker: Bool = false
	var item: Item
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				categoryView()
				VStack(alignment: .leading, spacing: 0) {
				if (item.desc != "" && item.desc != nil) {
					Text(item.desc!)
					.font(.body)
				}
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
				Button { item.category = category
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
	}
}

#Preview {
	Group {
		ListItem(item: createTestItems().first!)
		List(createTestItems(), id: \.self) { item in
			ListItem(item: item)
		}
	}
}
