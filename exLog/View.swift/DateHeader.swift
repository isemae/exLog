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
		HeaderContentView()
			.transition(.move(edge: .top))
	}
	
	private func HeaderContentView() -> some View {
		HStack {
			HeaderDateView()
			Spacer()
			Text("₩\(sumForDate)")
				.font(.title3)
				.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
		}
		.padding(10)
		.contentShape(Rectangle())
		.background(.bar)
		.overlayDivider(alignment: .bottom)
		.animation(.spring(response: 0.3, dampingFraction: 0.9))
		.onTapGesture {
			withAnimation(.easeOut(duration: 0.15)) {
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
			Image(systemName: "chevron.right")
				.font(.body)
				.foregroundColor(.gray)
				.frame(minWidth: 40, minHeight: 40)
				.rotationEffect(Angle(degrees: dataModel.foldedItems[date, default: true] ? 0 : 90))
				.animation(.spring(response: 0.3, dampingFraction: 0.9))
		}
		.font(.title)
	}
}

//
//#Preview {
//	DateTitle(dataModel: DataModel(), items: createTestItems(), date: Date(), sumForDate: 10, onTap: {}, isFolded: )
//}

