//
//  ImagePickerView.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/27/23.
//

import SwiftUI
import SwiftData

struct LocationGridCell: View {
	var location: Location
//	@State var pickerState = States.Picker()
	@State private var showImagePicker = false
	@State private var selectedImage: UIImage?
	@State private var selectedLocation: Location?
	var modelContext: ModelContext
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
		.contextMenu(ContextMenu(menuItems: { gridContextMenu(location: location) }))
		.sheet(isPresented: $showImagePicker) {
			ImagePicker(image: $selectedImage, location: $selectedLocation) { selectedImage in
				if let location = selectedLocation {
					if let imageData = selectedImage?.pngData() {
						location.imageData = imageData
						try? modelContext.save()
					}
				}
				showImagePicker = false
			}
		}
	}

	func gridContextMenu(location: Location) -> some View {
		return Group {
			Button {
				selectedLocation = location
				showImagePicker.toggle()
			} label: {
				Label("배경이미지 설정", systemImage: "photo.badge.plus")
			}
			Button(role: .destructive) {
				withAnimation(.easeOut(duration: 0.2)) {
					modelContext.delete(location)
					try? modelContext.save()
				}
			} label : {
				Label("여행계획 삭제", systemImage: "trash")
			}
		}
	}
}

// #Preview {
//	ImagePickerView()
// }
