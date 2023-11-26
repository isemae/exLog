//
//  SpendingItem.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct SpendingItem: View {
	@Binding var currentCurrency: String
	var item: Item
    var body: some View {
			HStack (alignment: .top){
				VStack(alignment: .leading) {
					Text("\(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))")
						.foregroundColor(.gray)
						.font(.title2)
					
					Text("\(currentCurrency) → ₩")
						.font(.title2)
				}
				VStack {
					HStack {
						Spacer()
						Text("₩\(item.calculatedBalance)")
							.font(.title)
						//										.opacity(opacityForItem(item))
					}
				}.padding([.top, .bottom], 5)
			}
		}
}
//
//#Preview {
//	SpendingItem()
//}
