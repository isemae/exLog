//
//  GestureHandler.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/5/23.
//

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
					if abs(orientation.translation.width) > abs(orientation.translation.height) {
						return
					}
					if orientation.translation.height > 10.0 {
						self.onSwipeDown()
					}
					
					if orientation.translation.height < 10.0{
						self.onSwipeUp()
					}
					
				}
		)
	}
}

extension View {
	func GestureHandler(onSwipeUp: @escaping () -> Void, onSwipeDown: @escaping () -> Void) -> some View {
		self.modifier(DragGestureHandler(onSwipeUp: onSwipeUp, onSwipeDown: onSwipeDown))
	}
}
