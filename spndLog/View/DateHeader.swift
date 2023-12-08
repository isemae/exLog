//
//  DateTitle.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateHeader: View {
	let dataModel: DataModel
	var items: [Item]
	var date: Date
	var prevItem: Item?
	var sumForDate: Int
	var onTap: () -> Void
	@State var isFolded: Bool
	
	var body: some View {
		
		HeaderContent()
			.onTapGesture {
				isFolded.toggle()
				handleTapGesture()
			}
			.background(Color(uiColor: UIColor.systemBackground))
			.transition(.move(edge: .top).combined(with: .opacity))
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
		.contentShape(Rectangle()
		)
		.overlay(
			Divider()
				.foregroundColor(dataModel.foldedItems[date, default: false] ? Color(uiColor: UIColor.secondaryLabel) : Color(uiColor: UIColor.tertiaryLabel))
				.padding(.trailing, 10)
			, alignment: .bottom)
		
	}
	
	private func HeaderDate() -> some View {
		HStack(spacing: 0) {
			Text("\(dateFormat(for: items.first!.date, format: "mm"))/")
				.foregroundColor(Color(uiColor: UIColor.label))
			Text("\(dateFormat(for: items.first!.date, format: "dd"))")
				.foregroundColor(dayColor(for: date))
			Image(systemName: "chevron.right")
				.font(.title3)
				.foregroundColor(.gray)
				.frame(minWidth: 40, minHeight: 40)
				.rotationEffect(Angle(degrees: isFolded ? 0 : 90))
				.animation(.spring(response: 0.3, dampingFraction: 0.9))
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
//	DateTitle(dataModel: DataModel(), items: createTestItems(), date: Date(), sumForDate: 10, onTap: {}, isFolded: )
//}

