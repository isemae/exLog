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
					Divider().frame(alignment: .top), alignment: .top)
			HStack {
					Text(currencies.currentCurrency.symbol)
					.frame(maxWidth: 50, maxHeight: 50)
					.background(RoundedRectangle(cornerRadius: 15)
						.foregroundColor(Color(uiColor: UIColor.systemBackground)))
					.contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15))
					.contextMenu(ContextMenu(menuItems: {
						ForEach(Currency.allCases) { curr in
							Button("\(curr.symbol) \(curr.name)") {
								currencies.currentCurrency = curr
								DispatchQueue.global().async {
									fetchData(currencySettings: currencies)
								}
							}
						}
					}))
					.padding(.leading)
				Spacer()
				Text(string)
					.padding(.trailing, 25)
			}
		}
		.onTapGesture(perform: {
			DispatchQueue.main.async {
				withAnimation(.spring(response: 0.2, dampingFraction: 1.0)) {
					isShowingKeypad.toggle()
				}
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
