//
//  DateTitle.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct DateTitle: View {
	let dataModel: DataModel
	var date: Date
	var sumForDate: Int
	//	var dateFrames: [CGRect]
	var onTap: () -> Void
	var body: some View {
		ZStack {
			HeaderBackground()
			HeaderContent()
		}
		.padding([.leading, .trailing], 15)
		.transition(.move(edge: .top).combined(with: .opacity))
		.onTapGesture {
			handleTapGesture()
		}
	}
	//		.sticky(dateFrames)
	
	
	private func HeaderContent() -> some View {
		HStack {
			HeaderDate()
			Spacer()
			Text("₩\(sumForDate)")
				.font(.title2)
				.foregroundColor(.gray)
				.padding(.trailing, 10)
		}
		.padding([.top, .bottom], 10)
	}
	
	private func HeaderDate() -> some View {
		HStack(spacing: 0) {
			Text("\(dateFormat(for: date, format: "mm"))/")
			Text("\(dateFormat(for: date, format: "dd"))")
				.foregroundColor(dayColor(for: date))
			Image(systemName: dataModel.foldedItems[date, default: false] ? "chevron.right" : "chevron.down")
				.font(.title3)
				.foregroundColor(.gray)
				.frame(minWidth: 20)
				.padding([.leading, .trailing], 10)
		}
		.font(.title)
	}	
	
	private func HeaderBackground() -> some View {
		Rectangle()
			.ignoresSafeArea()
			.foregroundColor(Color(uiColor: UIColor.systemBackground))
			.overlay(
				Rectangle()
					.frame(width: nil, height: 1, alignment: .bottom)
					.foregroundColor(dataModel.foldedItems[date, default: false] ? Color(uiColor: UIColor.darkGray) : Color(uiColor: UIColor.darkGray)),
				alignment: .bottom)
	}
	
	private func handleTapGesture() {
		   DispatchQueue.main.async {
			   withAnimation(.easeOut(duration: 0.25)) {
				   onTap()
				   dataModel.foldedItems[date, default: false].toggle()
			   }
		   }
	   }
}

//
//#Preview {
//	DateTitle(date: Date(), sumForDate: 1000, dateFrames: [])
//}

