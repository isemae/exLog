//
//  ImagePickerView.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/27/23.
//

import SwiftUI

struct LocationGridCell: View {
	var location: Location
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20)
				.foregroundColor(.gray)
				.frame(width: 160, height: 150)
			if let imageData = location.imageData, let uiImage = UIImage(data: imageData) {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFill()
					.frame(width: 160, height: 150)
					.cornerRadius(20)
			}
			RadialGradient(gradient: Gradient(colors: [.clear, .black]), center: .center, startRadius: 0, endRadius: 200)
			VStack {
				Text(location.name)
					.font(.title)
					.bold()
				Text(
"""
\(formattedDate(date: location.startDate ?? Date()))
~ \(formattedDate(date: location.endDate ?? Date()))
"""
				)
			}
			.foregroundColor(.primary)
		}
	}
}

// #Preview {
//	ImagePickerView()
// }
