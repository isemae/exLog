//
//  GestureHandler.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/5/23.

import Foundation
import SwiftUI

struct DragGestureHandler: ViewModifier {
	public let minDistance = 10.0

	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void

	func body(content: Content) -> some View {
		content.gesture(
			DragGesture()
				.onEnded { orientation in
					guard abs(orientation.translation.width) <= abs(orientation.translation.height) else { return }
					if orientation.translation.height > 10.0 {
						self.onSwipeDown() } else {
							self.onSwipeUp()
						}
				}
		)
	}
}

struct SwipeGestureHandler: ViewModifier {
	@GestureState var translation: CGFloat
	@Binding var currentIndex: Int
	@Binding var offset: Int
	@Binding var lastOffset: Int
	var range: [Date]

	func body(content: Content) -> some View {
		content.gesture(
			DragGesture()
				.updating($translation) { value, state, _ in
					state = value.translation.width.rounded()
				}
				.onChanged { value in
					guard abs(value.translation.width) > abs(value.translation.height) else {
						return
					}
					offset = lastOffset + Int(translation)
				}
				.onEnded { value in
					withAnimation(.spring(duration: 0.5)) {
						offset = currentIndex * -Int(Screen.width)
						let translation = value.translation
//						let _newIndex = currentIndex + Int(translation.width / Screen.width)
						guard abs(translation.width) > 50 else {
							return
						}
						guard abs(translation.height) < abs(translation.width) else { return }
						if translation.width > 50 && currentIndex > 0 {
							currentIndex -= 1
							offset += Int(Screen.width)
							print("우스와이프")
							print(currentIndex)

						} else if translation.width < -50 && currentIndex < range.count - 1 {
							currentIndex += 1
							offset -= Int(Screen.width)
							print("좌스와이프")
							print(currentIndex)
						}
						lastOffset = offset
					}
				}
		)
	}
}
