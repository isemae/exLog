//
//  OverlayKeypad.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/12/24.
//

import SwiftUI
import SwiftData

struct OverlayKeypad: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@Binding var string: String
	@Binding var isShowingKeypad: Bool
	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void

	var body: some View {
		VStack(spacing: 0) {
			InputArea(isShowingKeypad: $isShowingKeypad,
					  string: string,
					  onSwipeUp: {
			},
					  onSwipeDown: {
			})
			.onChange(of: string, perform: { _ in
				if string.count > 9 {
					string = String(string.prefix(9)) }})

			Keypad(string: $string, isShowing: $isShowingKeypad,
				   onSwipeUp: {
				onSwipeUp()
			},
				   onSwipeDown: {
				onSwipeDown()
			})
			.font(.largeTitle)
			.disabled(!isShowingKeypad)
			.offset(y: isShowingKeypad ? 0 : Screen.height / 2)
		}
		.background(.bar)
	}
}
