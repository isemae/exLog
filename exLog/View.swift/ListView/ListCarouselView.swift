//
//  ListCarouselView.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/30/24.
//

import SwiftUI
import Foundation

struct ListCarouselView : View {
	var location: Location
	@GestureState private var translation: CGFloat = 0.0
	@State private var currentPage = 0
	@State private var offset = 0

	var body: some View {
		let dateRange = dateRange(location: location, from: location.startDate ?? Date(), to: location.endDate ?? Date())
		VStack {
			//		Text("\(currentPage)")
			//			Text(dateRangeText(from: location.startDate ?? Date(), to: location.endDate ?? Date()))
			//			Text("\(translation)")
			//			Text("\(offset)")
			HStack {
				ForEach(dateRange, id: \.self) { date in
					Circle()
						.fill(dateRange.firstIndex(of: date) == currentPage ? Color.blue : Color.gray)
						.frame(width: 8, height: 8)
				}
			}
			.padding()
			GeometryReader { _ in
				HStack(spacing: 0) {
					ForEach(dateRange, id: \.self) { date in
						VStack(spacing: 0) {
							let dateItems = location.items!.filter { item in
								let ymdDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: item.date))
								return ymdDate == date }
							let sumForDate = dateItems.reduce(0) { $0 + $1.calculatedBalance }
							DateHeader(date: date, sumForDate: sumForDate)
								.frame(width: Screen.width)
							List {
								ForEach(dateItems, id: \.id) { item in
									HHmmHeader(date: item.date)
									ListItem(item: item)
								}
							}
							.frame(width: Screen.width)
						}
					}
				}
				.offset(x: CGFloat(offset))
				.animation(.easeInOut, value: currentPage)
			}
		}
		.background()
		.gesture(
			DragGesture()
				.updating($translation) {
					value, state, _ in
					state = value.translation.width.rounded()
				}
				.onChanged { _ in
				}
				.onEnded { value in
					withAnimation {
						var translation = value.translation.width
						let newIndex = Int(-translation / UIScreen.main.bounds.width)
						guard abs(translation) > Screen.width / 2 else {
							offset = 0
							return
						}

						if currentPage > 0 {
							if translation > Screen.width / 2 {
								currentPage -= 1
								offset += Int(Screen.width)
							} else {
								return
							}
						}
						if currentPage < dateRange.count {
							if translation < -Screen.width / 2 {
								currentPage += 1
								offset -= Int(Screen.width)
							} else {
								return
							}
						}

					}
				}
		)
	}

	func dateRange(location: Location, from startDate: Date, to endDate: Date) -> [Date] {
		var dates: Set<Date> = Set()

		if let items = location.items {
			for item in items {
				if let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: item.date)) {
					dates.insert(date)
				}
			}
		}
		return Array(dates.sorted())
	}

	func dateRangeText(from startDate: Date, to endDate: Date) -> String {
		let dates = dateRange(location: location, from: startDate, to: endDate)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"

		let dateStrings = dates.map { dateFormatter.string(from: $0) }
		let text = dateStrings.joined(separator: ", ")

		return text
	}
}
