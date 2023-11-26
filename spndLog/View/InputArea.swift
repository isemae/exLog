//
//  InputArea.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct InputArea: View {
	var currentCurrency: String
	var string: String
	@Binding var isShowingKeypad: Bool
	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void
	
	var body: some View {
		HStack {
			Text(currentCurrency)
				.contentShape(Rectangle())
				.onLongPressGesture(perform: {
					UIImpactFeedbackGenerator().impactOccurred()
				})
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
