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
		ZStack {
			Rectangle()
				.foregroundColor(Color(uiColor: UIColor.systemBackground))
				.frame(maxHeight: 100)
				.overlay(
					Rectangle()
						.foregroundColor(Color.gray)
						.frame(width: nil, height: 1, alignment: .top),
					alignment: .top)
			HStack {
				Text(currencies.currentCurrency.symbol)
					.contentShape(Rectangle())
					.contextMenu(ContextMenu(menuItems: {
						ForEach(Currency.allCases) { curr in
							Button("\(curr.symbol) \(curr.name)") {
								currencies.currentCurrency = curr
								DispatchQueue.main.async {
									fetchData(currencySettings: currencies)
								}
							}
						}
					}))
				Spacer()
				Text(string)
			}
			.contentShape(Rectangle())
			.padding([.leading, .trailing], 20)
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
}
//
//#Preview {
//    InputArea()
//}
