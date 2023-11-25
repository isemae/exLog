//
//  extensions.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/23/23.
//

import SwiftUI

struct FramePreference: PreferenceKey {
	static var defaultValue: [CGRect] = []
	
	static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
		value.append(contentsOf: nextValue())
	}
}

struct Sticky: ViewModifier {
	var stickyRects: [CGRect]
	@State var frame: CGRect = .zero
		
	var isSticking: Bool {
		frame.minY < 0
	}
		
	var offset: CGFloat {
		guard isSticking else { return 0 }
		var o = -frame.minY
		if let i = stickyRects.firstIndex(where: { $0.minY > frame.minY && $0.minY < frame.height }) {
			let other = stickyRects[i]
			o -= frame.height - other.minY
		}
		return o
	}
		
	func body(content: Content) -> some View {
		content
			.offset(y: isSticking ? -frame.minY : 0)
			.zIndex(isSticking ? .infinity : 0)
			.overlay(GeometryReader {
				geo in
				let f = geo.frame(in:
						.named("container"))
				Color.clear
					.onAppear { frame = f }
					.onChange(of: f) { frame = $0 }
					.preference(key: FramePreference.self, value: [frame])
			})
	}
}

extension View {
	func sticky(_ stickyRects: [CGRect]) -> some View {
		modifier(Sticky(stickyRects: stickyRects))
	}
}

extension String {
	
}

extension Array where Element == Item {
	func sortedByDate() -> [(Date, [Item])] {
		let groupedDictionary = Dictionary(grouping: self) { item in
			Calendar.current.startOfDay(for: item.timestamp)
		}
		
		let sortedGroups = groupedDictionary.sorted { $0.key > $1.key }
		
		let sortedItemsInGroups = sortedGroups.map { (date, items) in
			(date, items.sorted(by: { $0.timestamp > $1.timestamp }))
		}
		
		return sortedItemsInGroups
	}
	
//	func sortedByTime() -> [Item] {
//		let groupedDictionary = Dirtionary(grouping: self) { item in
//			calendar.current.startOfDay(for: item.timestamp)
//		}
//		return sortedItemsInGroups
//	}
}

extension Int {
	
}

#Preview {
	ScrollView {
		VStack {
			Text("1")
//				.sticky()
		Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
		}
	}
	.coordinateSpace(name:"container")
}
