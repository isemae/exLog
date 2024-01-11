//
//  LocationGridView.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/7/24.
//

import SwiftUI

struct LocationGridView: View {
	var locations: [Location]
	var items: [Item]
	var tapAction: () -> Void

    var body: some View {
		LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
			ForEach(locations.sorted(by: { $0.startDate ?? Date()  > $1.startDate ?? Date() }), id: \.self) { location in
				ZStack {
					ImagePickerView()
					VStack {
						NavigationLink(location.name, destination: ItemListView(items: items.filter { item in
							if let startDate = location.startDate, let endDate = location.endDate {
								return startDate <= item.date && item.date <= endDate
							}
							return false
						}, onTap: tapAction ))
						.font(.title)
						.foregroundColor(.primary)
						.bold()
						Text("\(formattedDate(date: location.startDate ?? Date())) ~ \(formattedDate(date: location.endDate ?? Date()))")
					}
				}
			}
		}
		.padding()
		.navigationTitle("main")
    }
}
//
// #Preview {
//	LocationGridView(locations: [], items: [])
// }
