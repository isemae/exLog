//
//  SpendingItem.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct SpendingItem: View {
	@Binding var currentCurrency: String
	@Binding var ampm: Bool
	var item: Item
	
	var body: some View {
		HStack (alignment: .center) {
			Text(ampm ? "\(dateFormat(for: item.timestamp, format: "hhmm"))" : "\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
				.font(.title2)
				.frame(maxWidth: .infinity)
				.fixedSize(horizontal: true, vertical: false)
				.onTapGesture {
					withAnimation(.linear(duration: 0.2)) {
						ampm.toggle()
						
					}
				}
//			Text("\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.foregroundColor(.secondary)
					.frame(maxWidth: .infinity)
				Text("\(currentCurrency) → ₩")
					.font(.headline)
					.padding(5)
			}
			.fixedSize()
			Spacer()
			Text("₩\(item.calculatedBalance)")
				.font(.title)
		}
		.padding([.leading, .trailing], 20)
	}
}

