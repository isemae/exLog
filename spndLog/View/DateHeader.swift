//
//  DateTitle.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateHeader: View {
//	let dataModel: DataModel
	var items: [Item]
	var date: Date
	var prevItem: Item?
	var sumForDate: Int
	@State var isFolded: Bool = false
	
	var body: some View {
		HeaderContentView()
			.transition(.move(edge: .top).combined(with: .opacity))
	}
	
	private func HeaderContentView() -> some View {
		HStack {
			HeaderDateView()
			Spacer()
			Text("₩\(sumForDate)")
				.font(.title2)
				.foregroundColor(.gray)
		}
		.padding(10)
		.contentShape(Rectangle())
		.background()
		.overlayDividers(state: isFolded, role: .main)
		.onTapGesture {
			isFolded.toggle()
			handleTapGesture()
		}
	}
	
	private func HeaderDateView() -> some View {
		HStack(spacing: 0) {
			Text("\(dateFormatString(for: items.first!.date, format: "mm"))/")
				.foregroundColor(Color(uiColor: UIColor.label))
			Text("\(dateFormatString(for: items.first!.date, format: "dd"))")
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
//				   dataModel.foldedItems[date, default: false].toggle()
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

