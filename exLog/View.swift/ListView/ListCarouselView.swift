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
			//					Text("\(currentPage)")
			//						Text(dateRangeText(from: location.startDate ?? Date(), to: location.endDate ?? Date()))
			//						Text("\(translation)")
			//						Text("\(offset)")
			HStack {
				ForEach(dateRange, id: \.self) { date in
					Circle()
						.fill(dateRange.firstIndex(of: date) == currentPage ? Color.blue : Color.gray)
						.frame(width: 8, height: 8)
				}
			}
			.padding(5)
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
								ForEach(dateItems.sorted(by: { $0.date > $1.date }), id: \.id) { item in
									VStack(spacing: 5) {
										HHmmHeader(date: item.date)
										ListItem(item: item)
									}
								}
								.listRowInsets(EdgeInsets())
								.listRowSeparator(.hidden)
								.listRowSpacing(12)
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
				.onChanged { value in
					guard abs(value.translation.width) > abs(value.translation.height) else {
						return
					}
					offset = lastOffset + Int(translation)
				}
				.onEnded { value in
					withAnimation(.spring(duration: 0.5)) {
						offset = currentPage * -Int(Screen.width)
						let translation = value.translation
						let newIndex = currentPage + Int(translation.width / Screen.width)
						guard abs(translation.width) > Screen.width / 3 else {
							return
						}
						guard abs(translation.height) < abs(translation.width) else { return }
						if translation.width > Screen.width / 3 && currentPage > 0 {
							currentPage -= 1
							offset += Int(Screen.width)
							print("우스와이프")
							print(currentPage)

						} else if translation.width < -Screen.width / 3 && currentPage < dateRange.count - 1 {
							currentPage += 1
							offset -= Int(Screen.width)
							print("좌스와이프")
							print(currentPage)
						}
						lastOffset = offset
					}
				}
		)
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
