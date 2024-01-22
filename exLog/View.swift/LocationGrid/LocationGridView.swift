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
	@EnvironmentObject var navigationFlow: NavigationFlow
	@Query var locations: [Location]
	@Query var items: [Item]
	@State private var showImagePicker = false
	@State private var selectedImage: UIImage?
	@State private var selectedLocation: Location?
	@State var pickerState = States.Picker()

	var body: some View {
		ScrollView(.vertical) {
			NavigationLink("분류되지 않음", destination: ItemListView(items: items.filter { item in
				item.location == nil }))
				.foregroundColor(Color(uiColor: .label))
			LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
				ForEach(locations.sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }), id: \.self) { location in
//					NavigationLink(destination: destinationItemListView(location: location)
//						.navigationTitle(location.name)) {
//							LocationGridCell(location: location)
//						}
//						.contextMenu(ContextMenu(menuItems: {
//							gridContextMenu(location: location)
//						}))
//						.sheet(isPresented: $showImagePicker) {
//							ImagePicker(image: $selectedImage, location: $selectedLocation) { selectedImage in
//								if let selectedLocation = selectedLocation {
//									if let imageData = selectedImage?.pngData() {
//										selectedLocation.imageData = imageData
//										try? modelContext.save()
//									}
//								}
//								showImagePicker = false
//							}
//						}
					Button {
//							LocationViewFactory.items = items.filter { item in
//								if let startDate = location.startDate, let endDate = location.endDate {
//									return startDate <= item.date && item.date <= endDate
//								}
//								return false
//							}
						LocationViewFactory.items = location.items ?? []
							navigationFlow.selectedLocation = location
							navigationFlow.navigateToLocationListView(location: location)

					} label: {
						LocationGridCell(location: location)
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
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						pickerState.isDatePickerPresented.toggle()
					} label: {
						Label("새 일정", systemImage: "calendar.badge.plus")
					}
				}
			}
			.sheet(isPresented: $pickerState.isDatePickerPresented, content: {
				DatePickerForm(isPresenting: $pickerState.isDatePickerPresented , selectedDates: $pickerState.selectedDates, addingLocationName: $pickerState.addingLocationName)
			})
			.padding()
		}
		.navigationTitle("여행")
	}

	func gridContextMenu(location: Location) -> some View {
		return Group {
			Button {
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
//	 LocationGridView(locations: [], items: [])
// }
