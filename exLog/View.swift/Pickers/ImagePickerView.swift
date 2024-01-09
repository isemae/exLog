//
//  ImagePickerView.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/27/23.
//

import SwiftUI

struct ImagePickerView: View {
	@State var showImagePicker = false
	@State var selectedUIImage: UIImage?
	@State var image: Image?

	var body: some View {
		VStack {
			ZStack {
				if let image = image {
					image
						.resizable()
						.scaledToFill()
						.frame(width: 150, height: 150)
						.cornerRadius(20)
				} else {
					RoundedRectangle(cornerRadius: 20)
						.foregroundColor(.gray)
						.frame(width: 150, height: 150)
				}
			}
		}
		.sheet(isPresented: $showImagePicker, onDismiss: { loadImage() }) {
			ImagePicker(image: $selectedUIImage) }
		.onLongPressGesture(perform: {
			showImagePicker.toggle()
		})
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
