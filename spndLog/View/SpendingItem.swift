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
		VStack(alignment: .leading, spacing: 0) {
			if !shouldGroupByMinute() {
				Text(ampm ? "\(dateFormat(for: item.timestamp, format: "hhmm"))" : "\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
					.font(.title3)
					.frame(maxWidth: .infinity)
					.fixedSize(horizontal: true, vertical: false)
					.onTapGesture {
						withAnimation(.linear(duration: 0.2)) {
							ampm.toggle()
						}
					}
					.padding(.top, 10)
			}
			HStack (alignment: .center) {
				ZStack {
					RoundedRectangle(cornerRadius: 12)
						.foregroundColor(.secondary)
					Text("\(item.currency) →")
						.font(.headline)
						.foregroundColor(.primary)
						.padding(5)
				}
				.fixedSize()
				Spacer()
				Text("₩\(item.calculatedBalance)")
					.font(.title2)
			}
			.padding([.top], 5)
			Divider()
		}
		.padding([.leading, .trailing], 25)
	}
	
	private func shouldGroupByMinute() -> Bool {
		guard let prevItem = prevItem else {
			return false
		}
		let isMinuteSame = Calendar.current.isDate(item.timestamp, equalTo: prevItem.timestamp, toGranularity: .minute)
		return isMinuteSame
	}
}

