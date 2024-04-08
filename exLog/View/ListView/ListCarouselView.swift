//
//  ListCarouselView.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/30/24.
//

import SwiftUI
import SwiftData
import Foundation

struct ListCarouselView : View {
	var location: Location
	@GestureState private var translation: CGFloat = 0.0
	@State private var currentPage = 0
	@State private var offset = 0
	@State private var lastOffset = 0

	init(location: Location) {
		self.location = location
		let dateRange = dateRange(location: location, from: location.startDate ?? Date(), to: location.endDate ?? Date())
		let initialOffset = -Int(Screen.width) * (dateRange.count - 1)
		_offset = State(initialValue: initialOffset)
		_lastOffset = State(initialValue: initialOffset)
		_currentPage = State(initialValue: dateRange.count - 1)
	}

	var body: some View {
		let dateRange = dateRange(location: location, from: location.startDate ?? Date(), to: location.endDate ?? Date())
		VStack(spacing: 0) {
			CarouselIndicator(location: location, range: dateRange, currentIndex: currentPage)
				.padding(5)
			GeometryReader { _ in
				HStack(spacing: 0) {
					ForEach(dateRange, id: \.self) { date in
						VStack(spacing: 0) {
							let dateItems = location.items!.filter { item in
								let ymd = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: item.date))
								return ymd == date }
							let sumForDate = dateItems.reduce(0) { $0 + $1.calculatedBalance }
							DateHeader(date: date, sumForDate: sumForDate)
							List {
								ForEach(dateItems.sorted(by: { $0.date > $1.date }), id: \.id) { item in
									VStack(spacing: 5) {
										HHmmHeader(date: item.date)
										ListItem(item: item)
									}
								}
								.listRowInsets(EdgeInsets())
								.listRowSeparator(.hidden)
								.listRowSpacing(12)
								.environment(\.defaultMinListHeaderHeight, 0)
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
		.modifier(SwipeGestureHandler(translation: translation, currentIndex: $currentPage, offset: $offset, lastOffset: $lastOffset, range: dateRange))
		.navigationTitle(location.name)

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

extension ListCarouselView {
	struct CarouselIndicator: View {
		var location: Location
		var range: [Date]
		var currentIndex: Int

		var body: some View {
			HStack {
				ForEach(range, id: \.self) { date in
					Circle()
						.fill(range.firstIndex(of: date) == currentIndex ? Color.blue : Color.gray)
						.frame(width: 8, height: 8)
				}
			}
		}
	}
}
