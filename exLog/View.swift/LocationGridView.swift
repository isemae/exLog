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
			ForEach(locations, id: \.self) { location in
				ZStack {
					RoundedRectangle(cornerRadius: 15)
						.frame(width: 150, height: 150)
						.foregroundColor(.gray)
					VStack {
						Text("\(formattedDate(date: location.startDate ?? Date()) )~ \(formattedDate(date: location.endDate ?? Date()))")
						NavigationLink(location.name, 
									   destination: DayListView(items: items.filter { item in
							if let startDate = location.startDate, let endDate = location.endDate {
								return startDate <= item.date && item.date <= endDate
							}
							return false
						}, onTap: tapAction ))
					}
				}
			}
		}
		.padding()
		.navigationTitle("main")
    }
}
//
//#Preview {
//	LocationGridView(locations: [], items: [])
//}
