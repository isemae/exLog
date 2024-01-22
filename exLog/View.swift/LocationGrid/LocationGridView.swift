//
//  LocationGridView.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/7/24.
//

import SwiftUI
import SwiftData

struct LocationGridView: View {
	@Environment(\.modelContext) private var modelContext
	@Query var locations: [Location]
	@State private var showImagePicker = false
	@State private var selectedImage: UIImage?
	@State private var selectedLocation: Location?
	var items: [Item]
	var tapAction: () -> Void

	var body: some View {
		NavigationView {
			ScrollView(.vertical) {
				NavigationLink("분류되지 않음", destination: ItemListView(items: items))
					.foregroundColor(Color(uiColor: .label))
				LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
					ForEach(locations.sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }), id: \.self) { location in

						NavigationLink(destination: destinationItemListView(location: location)
							.navigationTitle(location.name)) {
								LocationGridCell(location: location)
							}
							.contextMenu(ContextMenu(menuItems: {
								gridContextMenu(location: location)
							}))
							.sheet(isPresented: $showImagePicker) {
								ImagePicker(image: $selectedImage, location: $selectedLocation) { selectedImage in
									if let selectedLocation = selectedLocation {
										if let imageData = selectedImage?.pngData() {
											selectedLocation.imageData = imageData
											try? modelContext.save()
										}
									}
									showImagePicker = false
								}
							}
					}
				}
				.padding()
			}
			.navigationTitle("여행")
		}
	}

	func destinationItemListView(location: Location) -> some View {
		ItemListView(items: items.filter { item in
			if let startDate = location.startDate, let endDate = location.endDate {
				return startDate <= item.date && item.date <= endDate
			}
			return false
		})
	}

	func gridContextMenu(location: Location) -> some View {
		return Group {
			Button {
				selectedLocation = location
				print(location.imageData)
				print(location.name)
				showImagePicker.toggle()
			} label: {
				Label("배경이미지 설정", systemImage: "photo.badge.plus")
			}
			Button(role: .destructive) {
				modelContext.delete(location)
				try? modelContext.save()
			} label : {
				Label("여행계획 삭제", systemImage: "trash")
			}
		}
	}
}

// #Preview {
//	 LocationGridView(locations: [], items: [], tapAction: {})
// }
