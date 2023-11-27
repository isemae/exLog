//
//  DateTitle.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateTitle: View {
	@State private var isFolded = false
	var date: Date
	var sumForDate: Int
	var dateFrames: [CGRect]
	
    var body: some View {
			ZStack {
				Color.primary.colorInvert()
				VStack (spacing: 5) {
					Divider()
						.background(Color.gray)
					HStack {
						HStack(spacing: 0) {
							Text("\(dateFormat(for: date, format: "mm"))/")
							Text("\(dateFormat(for: date, format: "dd"))")
								.foregroundColor(dayColor(for: date))
						}
						.font(.title)
						Spacer()
						Text("₩\(sumForDate)")
							.font(.title2)
							.foregroundColor(.gray)
					}
					.padding([.leading, .trailing], 15)
					.padding([.top, .bottom], 10)
					Divider()
						.background(Color.gray)
				}
			}
		.sticky(dateFrames)
    }
}

#Preview {
	DateTitle(date: Date(), sumForDate: 1000, dateFrames: [])
}
