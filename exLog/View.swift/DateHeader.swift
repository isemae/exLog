//
//  DateTitle.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateHeader: View {
	@EnvironmentObject var dataModel: DataModel
	@State var isFolded = false
	var items: [Item]
	var date: Date
	var sumForDate: Int
	
	var body: some View {
		HStack {
			HeaderDateView()
			Spacer()
			Text("₩\(sumForDate)")
				.font(.title3)
				.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
		}
		.padding(8)
		.overlayDivider(alignment: .bottom, state: !dataModel.foldedItems[date, default: false])
		.contentShape(Rectangle())
		.onTapGesture {
			withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
				dataModel.foldedItems[date, default: false].toggle()
				isFolded.toggle()
			}
		}
	}
	
	private func HeaderDateView() -> some View {
		HStack(spacing: 0) {
			Text("\(dateFormatString(for: date, format: "mm"))/")
				.foregroundColor(Color(uiColor: UIColor.label))
			Text("\(dateFormatString(for: date, format: "dd"))")
				.foregroundColor(dayColor(for: date))
			Image(systemName: "chevron.down")
				.font(.body)
				.foregroundColor(.gray)
				.frame(minWidth: 40, minHeight: 40)
				.rotationEffect(Angle(degrees: dataModel.foldedItems[date, default: true] ? 0 : -180))
				.animation(.spring(response: 0.35, dampingFraction: 0.9))
		}
		.font(.title)
	}
}


#Preview {
	DateHeader(items: createTestItems(), date: Date(), sumForDate: 1000)
		.environmentObject(DataModel())
}

