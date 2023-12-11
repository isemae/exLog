//
//  HHmmHeader.swift
//  spndLog
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
		.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
		.padding(10)
		.background()
		.overlayDivider(alignment: .bottom)
		.onTapGesture {
			dataModel.ampm.toggle()
			UserDefaults.standard.set(dataModel.ampm, forKey: "ampm")
		}
	}
}
