//
//  DateTitle.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateTitle: View {
	@Binding var foldedDates: [Date: Bool]
	var date: Date
	var sumForDate: Int
	var dateFrames: [CGRect]
	
    var body: some View {
			ZStack {
				Rectangle()
					.ignoresSafeArea()
					.foregroundColor(Color(uiColor: UIColor.systemBackground))
				.overlay(
					Rectangle()
						.frame(width: nil, height: 1, alignment: .bottom)
						.foregroundColor(Color.gray),
					alignment: .bottom)
					HStack {
						HStack(spacing: 0) {
							Text("\(dateFormat(for: date, format: "mm"))/")
							Text("\(dateFormat(for: date, format: "dd"))")
								.foregroundColor(dayColor(for: date))
							Image(systemName: foldedDates[date, default: false] ? "chevron.right" : "chevron.down")
								.font(.title3)
								.foregroundColor(.gray)
								.frame(minWidth: 20)
								.padding([.leading, .trailing], 10)
							
						}
						.font(.title)
						Spacer()
						Text("₩\(sumForDate)")
							.font(.title2)
							.foregroundColor(.gray)
					}
					.padding(10)
//					.padding([.top, .bottom], 10)
			}
//			.padding([.leading, .trailing], 15)
		.sticky(dateFrames)
    }
}
//
//#Preview {
//	DateTitle(date: Date(), sumForDate: 1000, dateFrames: [])
//}
