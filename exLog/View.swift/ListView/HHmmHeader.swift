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
			Spacer()
		}
		.foregroundColor(Color(uiColor: .secondaryLabel))
		.padding(10)
		.overlayDivider(alignment: .top)
		.onTapGesture {
			dataModel.ampm.toggle()
		}
	}
}
