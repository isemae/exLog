//
//  SpendingItem.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct SpendingItem: View {
	@Binding var ampm: Bool
	var item: Item
	var prevItem: Item?
	
	var body: some View {
		VStack(alignment: .leading) {
			if shouldDisplayTimeDifference() {
				Text(ampm ? "\(dateFormat(for: item.timestamp, format: "hhmm"))" : "\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
					.font(.callout)
					.frame(maxWidth: .infinity)
					.fixedSize(horizontal: true, vertical: false)
//					.padding(.top, 5)
					.onTapGesture {
						withAnimation(.linear(duration: 0.2)) {
							ampm.toggle()
						}
					}
			}
			HStack (alignment: .center) {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(.secondary)
					Text("\(item.currency) → ₩")
						.font(.headline)
						.foregroundColor(.primary)
						.padding(5)
				}
						.fixedSize()
				Spacer()
				Text("₩\(item.calculatedBalance)")
					.font(.title2)
			}
			
		}
		.padding([.leading, .trailing], 30)
	}
	
	private func shouldDisplayTimeDifference() -> Bool {
		guard let prevItem = prevItem else {
			return true
		}
		
		let isMinuteDifferent = !Calendar.current.isDate(item.timestamp, equalTo: prevItem.timestamp, toGranularity: .minute)
		return isMinuteDifferent
	}
}

