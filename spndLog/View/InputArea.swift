//
//  InputArea.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct InputArea: View {
	@EnvironmentObject var currencies: CurrencySettings
	@Binding var isShowingKeypad: Bool
	var string: String
	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void
	@State private var selectedCurrency: Currency = .USD

	var body: some View {
		HStack {
			Text(currencies.currentCurrency.symbol)
				.contentShape(Rectangle())
				.contextMenu(ContextMenu(menuItems: {
					ForEach(Currency.allCases, id:\.self) { curr in
						Button("\(curr.symbol) \(curr.name)") {
							currencies.currentCurrency = curr
							fetchData(currencySettings: currencies)
						}
					}
				}))
			Spacer()
			Text(string)
		}
		.contentShape(Rectangle())
		.padding([.leading, .trailing])
		.onTapGesture(perform: {
			withAnimation(.spring(response: 0.2, dampingFraction: 1.0)) {
				isShowingKeypad.toggle()
			}
		})
		.GestureHandler(
			onSwipeUp: onSwipeUp,
			onSwipeDown: onSwipeDown
		)
	}
}
//
//#Preview {
//    InputArea()
//}
