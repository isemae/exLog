//
//  extensions.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/23/23.
//

import SwiftUI

extension Int {
	
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
			.offset(y: offset)
			.zIndex(isSticking ? .infinity : 0)
			.overlay(GeometryReader { geo in
				let f = geo.frame(in: .named("container"))
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




struct StickyView: View {
	@State private var frames: [CGRect] = []
	
	var body: some View {
		ScrollView {
			contents
		}
		.coordinateSpace(name: "container")
		.onPreferenceChange(FramePreference.self, perform: {
			frames = $0.sorted(by: { $0.minY < $1.minY })
		})
}
	@ViewBuilder var contents: some View {
		Image(systemName: "globe")
			.imageScale(.large)
			.foregroundColor(.accentColor)
			.padding()
		
		ForEach(0..<50) { ix in
			Text("Heading \(ix)")
				.font(.headline)
				.frame(maxWidth: .infinity)
				.background(.regularMaterial)
				.sticky(frames)
			
			Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut turpis tempor, porta diam ut, iaculis leo. Phasellus condimentum euismod enim fringilla vulputate. Suspendisse sed quam mattis, suscipit ipsum vel, volutpat quam. Donec sagittis felis nec nulla viverra, et interdum enim sagittis. Nunc egestas scelerisque enim ac feugiat.")
				.padding()
		}
	}
}

#Preview {
	StickyView()
}
