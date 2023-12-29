//
//  ImagePickerView.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/27/23.
//

import SwiftUI

struct ImagePickerView: View {
	@State var date: String
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
						.frame(width: UIScreen.main.bounds.width * 0.8, height: 120)
						.cornerRadius(20)
				} else {
					RoundedRectangle(cornerRadius: 20)
						.foregroundColor(.clear)
						.frame(width: UIScreen.main.bounds.width * 0.8, height: 120)
				}
				
				Text(String(date))
					.font(.title)
					.foregroundColor(.primary)
					.bold()
			}
		}
		.sheet(isPresented: $showImagePicker,
			   onDismiss: {
			loadImage()
		}) {
			ImagePicker(image: $selectedUIImage)
		}
		.onLongPressGesture(perform: {
			showImagePicker.toggle()
		})
	}
	
	
	func loadImage() {
		guard let selectedImage = selectedUIImage else { return }
		image = Image(uiImage: selectedImage)
	}
}

#Preview {
	ImagePickerView(date: "2023")
}
