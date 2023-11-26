//
//  DateTitle.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateTitle: View {
	var date: Date
	var sumForDate: Int
	var dateFrames: [CGRect]
	
    var body: some View {
		Group {
			HStack {
				Text("\(dateFormat(for: date, format: "mm/dd"))")
					.font(.title)
					.foregroundColor(dayColor(for: date))
				Spacer()
				Text("₩\(sumForDate)")
					.font(.title2)
					.foregroundColor(.gray)
			}
			Rectangle()
				.foregroundColor(.gray)
				.frame(height: 1)
		}
		.sticky(dateFrames)
		.padding(.top, 10)
    }
}
