//
//  HHmmHeader.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/11/23.
//

import SwiftUI

struct HHmmHeader: View {
	var date: Date

	var body: some View {
		HStack {
			Image(systemName: "clock")
			Text("\(dateFormatString(for: date, format: "aahhmm"))")
				.font(.body)
				.fixedSize()
			Spacer()
		}
		.foregroundColor(Color(uiColor: .secondaryLabel))
		.padding(10)
		.overlayDivider(alignment: .top)
	}
}
