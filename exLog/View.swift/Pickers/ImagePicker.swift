//
//  ImagePicker.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/27/23.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var mode
	@Binding var image: UIImage?
	@Binding var location: Location?
	var didFinishPicking: ((UIImage?) -> Void)?

	init(image: Binding<UIImage?>, location: Binding<Location?>, didFinishPicking: ((UIImage?) -> Void)? = nil) {
		self._image = image
		self._location = location
		self.didFinishPicking = didFinishPicking
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIViewController(context: Context) -> some UIViewController {
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

	}
}

extension ImagePicker {
	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		let parent: ImagePicker

		init(_ parent: ImagePicker) {
			self.parent = parent
		}
		func loadOriginalImage(_ uiImage: UIImage) async -> UIImage? {
			return uiImage
		}

		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			if let uiImage = info[.originalImage] as? UIImage {
				parent.image = uiImage
				parent.location?.imageData = uiImage.pngData()

				Task {
					let thumbnailImage = await uiImage.createThumbnail(scaleTo: 0.25)
					parent.image = thumbnailImage
					parent.location?.imageData = thumbnailImage?.pngData()
					parent.didFinishPicking?(thumbnailImage)
				}
			}

			parent.mode.wrappedValue.dismiss()
		}
	}
}
