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
	@State var showImagePicker = false
	var items: [Item]
	var tapAction: () -> Void

    var body: some View {
		LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
			ForEach(locations.sorted(by: { $0.startDate ?? Date()  > $1.startDate ?? Date() }), id: \.self) { location in
				ZStack {
					ImagePickerView(locations: locations, showImagePicker: $showImagePicker)
					VStack {
						NavigationLink(location.name, destination: destinationItemListView(location: location))
						.font(.title)
						.foregroundColor(.primary)
						.bold()
						Text("\(formattedDate(date: location.startDate ?? Date())) ~ \(formattedDate(date: location.endDate ?? Date()))")
					}
				}
				.contextMenu(ContextMenu(menuItems: {
					Button {
						showImagePicker.toggle()
					} label: {
						Label("배경이미지 설정", systemImage: "photo.badge.plus")
					}
					Button(role: .destructive) {
						if let index = locations.firstIndex(where: { $0.id == location.id }) {
							modelContext.delete(location)
							try? modelContext.save()
						}
					} label : {
						Label("여행계획 삭제", systemImage: "trash")
					}
				}))
			}
		}
		.padding()
		.navigationTitle("main")
    }

	func destinationItemListView(location: Location) -> some View {
		ItemListView(items: items.filter { item in
			if let startDate = location.startDate, let endDate = location.endDate {
				return startDate <= item.date && item.date <= endDate
			}
			return false
		}, onTap: tapAction )
	}
}
//
// #Preview {
//	LocationGridView(locations: [], items: [])
// }
