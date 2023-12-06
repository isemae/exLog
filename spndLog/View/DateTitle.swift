//
//  DateTitle.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateTitle: View {
	let dataModel: DataModel
	var items: [Item]
//	var item: Item
	var date: Date
	var prevItem: Item?
	var sumForDate: Int
	var onTap: () -> Void
	
	var body: some View {
		if shouldGroupBy(.day, item: items.first!) {
			HeaderContent()
				.onTapGesture { handleTapGesture() }
				.background(Color(uiColor: UIColor.systemBackground))
		}
	}
	
	private func HeaderContent() -> some View {
		HStack {
			HeaderDate()
			Spacer()
			Text("₩\(sumForDate)")
				.font(.title2)
				.foregroundColor(.gray)
				
		}
		.padding(10)
		.contentShape(Rectangle())
		.overlay(
			Divider()
				.foregroundColor(Color(uiColor: UIColor.lightGray)
					.opacity(dataModel.foldedItems[items.first!.date, default: false] ? 1 : 0.5))
			, alignment: .bottom)
				.padding(.horizontal, 10)

	}
	
	private func HeaderDate() -> some View {
		HStack(spacing: 0) {
			Text("\(dateFormat(for: date, format: "mm"))/")
			Text("\(dateFormat(for: date, format: "dd"))")
				.foregroundColor(dayColor(for: date))
			Image(systemName: "chevron.right")
				.font(.title3)
				.foregroundColor(.gray)
				.frame(minWidth: 40)
//				.padding(.horizontal, 10)
				.rotationEffect(.degrees(dataModel.foldedItems[date, default: false] ? 0.0 : 90.0))
		}
		.font(.title)
	}	
	
	private func handleTapGesture() {
		   DispatchQueue.main.async {
			   withAnimation(.easeOut(duration: 0.15)) {
				   dataModel.foldedItems[date, default: false].toggle()
//				   onTap()
			   }
		   }
	   }
	
	func shouldGroupBy(_ format: Calendar.Component, item: Item) -> Bool {
		guard let prevItem = prevItem else {
			return true
		}
		let isDaySame = !Calendar.current.isDate(item.date, equalTo: prevItem.date, toGranularity: format)
		return isDaySame
	}
}

//
//#Preview {
//	DateTitle(dataModel: DataModel(), item: Item(), onTap: {print("hello")})
//}
//
