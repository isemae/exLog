//
//  DateTitle.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateTitle: View {
	let dataModel: DataModel
//	var items: [Item]
	var item: Item
	var prevItem: Item?
//	var sumForDate: Int
	var onTap: () -> Void
	var body: some View {
		if shouldGroupBy(.day, item: item) {
			ZStack {
				HeaderBackground()
				HeaderContent()
			}
			.transition(.move(edge: .top).combined(with: .opacity))
			.onTapGesture {
				handleTapGesture()
			}
		}
	}
	
	
	private func HeaderContent() -> some View {
		HStack {
			HeaderDate()
			Spacer()
//			Text("₩\(sumForDate)")
			Text("test")
				.font(.title2)
				.foregroundColor(.gray)
				.padding(.trailing, 10)
		}
	}
	
	private func HeaderDate() -> some View {
		HStack(spacing: 0) {
			Text("\(dateFormat(for: item.date, format: "mm"))/")
			Text("\(dateFormat(for: item.date, format: "dd"))")
				.foregroundColor(dayColor(for: item.date))
			Image(systemName: dataModel.foldedItems[item.date, default: false] ? "chevron.right" : "chevron.down")
				.font(.title3)
				.foregroundColor(.gray)
				.frame(minWidth: 20)
				.padding(.horizontal, 10)
		}
		.font(.title)
	}	
	
	private func HeaderBackground() -> some View {
		Rectangle()
			.ignoresSafeArea()
			.padding(15)
			.foregroundColor(Color(uiColor: UIColor.systemBackground))
			.overlay(
				Rectangle()
					.frame(width: nil, height: 1, alignment: .bottom)
					.foregroundColor(dataModel.foldedItems[item.date, default: false] ? Color(uiColor: UIColor.darkGray) : Color(uiColor: UIColor.lightGray))
				, alignment: .bottom)
	}
	
	private func handleTapGesture() {
		   DispatchQueue.main.async {
			   withAnimation(.easeOut(duration: 0.25)) {
				   onTap()
				   dataModel.foldedItems[item.date, default: false].toggle()
			   }
		   }
	   }
	
	func shouldGroupBy(_ time: Calendar.Component, item: Item) -> Bool {
		guard let prevItem = prevItem else {
			return true
		}
		let isDaySame = !Calendar.current.isDate(item.date, equalTo: prevItem.date, toGranularity: time)
		return isDaySame
	}
}

//
//#Preview {
//	DateTitle(dataModel: DataModel(), item: Item(), onTap: {print("hello")})
//}
//
