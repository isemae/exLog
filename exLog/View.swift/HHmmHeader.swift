//
//  HHmmHeader.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/11/23.
//

import SwiftUI

struct HHmmHeader: View {
	@EnvironmentObject var dataModel: DataModel
	var date: Date
	
	var body: some View {
		HStack {
			Image(systemName: "clock")
			Text(dataModel.ampm ? "\(dateFormatString(for: date, format: "aahhmm"))" : "\(dateFormatString(for: date, format: "hhmm"))")
				.font(.body)
				.fixedSize()
				.animation(.spring(response: 0.3, dampingFraction: 0.9))
			Spacer()
		}
		.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
		.padding(10)
		.overlayDivider(alignment: .top)
		.onTapGesture {
			dataModel.ampm.toggle()
		}
	}
}
