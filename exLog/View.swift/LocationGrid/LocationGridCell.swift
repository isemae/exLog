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
		VStack {
			RoundedRectangle(cornerRadius: 20)
				.foregroundColor(.gray)
				.frame(width: 160, height: 150)
				.overlay(
					ZStack {
						if let imageData = location.imageData, let uiImage = UIImage(data: imageData) {
							Image(uiImage: uiImage)
								.resizable()
								.scaledToFill()
								.frame(width: 160, height: 150)
								.overlay(
									RadialGradient(gradient: Gradient(colors: [.clear, .black]), center: .center, startRadius: 0, endRadius: 200))
						}
					}
						.cornerRadius(20)
				)

		}
		.overlay(
			VStack {
				Text(location.name)
					.font(.title)
					.bold()
				Text("""
\(formattedDate(date: location.startDate ?? Date()))
~ \(formattedDate(date: location.endDate ?? Date()))
""")
			}
				.foregroundColor(.primary)
		)

	}

	//	func loadImage() {
	//			guard let selectedImage = selectedUIImage else { return }
	//			image = Image(uiImage: selectedImage)
	//		}
}
//
// #Preview {
//	ImagePickerView()
// }
