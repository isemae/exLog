//
//  ImagePickerView.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/27/23.
//

import SwiftUI

struct ImagePickerView: View {
	@State var locations : [Location]
	@Binding var showImagePicker: Bool
	@State var selectedUIImage: UIImage?
	@State var image: Image?

	var body: some View {
		VStack {
			RoundedRectangle(cornerRadius: 20)
				.foregroundColor(.gray)
				.frame(width: 160, height: 150)
				.overlay(
					ZStack {
						image?
							.resizable()
							.scaledToFill()
							.frame(width: 160, height: 150)
							.overlay(
								RadialGradient(gradient: Gradient(colors: [.clear, .black]), center: .center, startRadius: 0, endRadius: 200))
					}
						.cornerRadius(20)
				)
		}

		.sheet(isPresented: $showImagePicker, onDismiss: { loadImage() }) { ImagePicker(image: $selectedUIImage) }

	}

	func loadImage() {
		guard let selectedImage = selectedUIImage else { return }
		image = Image(uiImage: selectedImage)
	}
}
//
// #Preview {
//	ImagePickerView()
// }
