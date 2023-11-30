//
//  InputArea.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct InputArea: View {
	@EnvironmentObject var dataModel: DataModel
	@Binding var isShowingKeypad: Bool
	var string: String
	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void
//	@State private var selectedCurrency: Currency

	var body: some View {
		ZStack {
			Rectangle()
				.foregroundColor(Color(uiColor: UIColor.systemBackground))
				.overlay(
						Divider().frame(alignment: .bottom)
				, alignment: .top)
				.overlay(
						Divider().frame(alignment: .top)
					, alignment: .bottom)
			HStack {
					Text(dataModel.currentCurrency.symbol)
					.frame(maxWidth: 60, maxHeight: 60)
					.background(RoundedRectangle(cornerRadius: 15)
						.foregroundColor(Color(uiColor: UIColor.systemBackground)))
					.contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15))
					.contextMenu(ContextMenu(menuItems: {
						ForEach(Currency.allCases) { curr in
							Button("\(curr.symbol) \(curr.name)") {
								dataModel.currentCurrency = curr
								DispatchQueue.global().async {
									fetchData(dataModel: dataModel)
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
		.font(.largeTitle)
		.frame(maxHeight: 80)
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
