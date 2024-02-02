//
//  View.swift
//  exLog
//
//  Created by Jiwoon Lee on 2/2/24.
//

import Foundation
import SwiftUI

enum UIRole: String {
	case main
	case secondary
	case unknown
}

extension View {
	func gestureHandler(onSwipeUp: @escaping () -> Void, onSwipeDown: @escaping () -> Void) -> some View {
		self.modifier(DragGestureHandler(onSwipeUp: onSwipeUp, onSwipeDown: onSwipeDown))
	}

	func safeAreaOverlay(alignment: Alignment, edges: Edge.Set) -> some View {
		self.overlay(alignment: alignment) {
			Color(uiColor: .systemBackground)
				.ignoresSafeArea(edges: edges)
				.frame(height: 0)
		}
	}
	func overlayDivider(alignment: Alignment, state: Bool? = nil) -> some View {
		self.overlay(
			Divider()
				.opacity(state == true ? 0 : 1)
				.foregroundColor(Color(uiColor: .systemGray))
			,
			alignment: alignment
		)
	}
	func overlayDividers(state: Bool? = nil, role: UIRole = .unknown) -> some View {
		return self
			.overlayDivider(alignment: .top, state: state)
			.overlayDivider(alignment: .bottom, state: state)
	}
}
