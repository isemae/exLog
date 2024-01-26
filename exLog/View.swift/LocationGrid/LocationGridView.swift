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
	@Query private var locations: [Location]
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@State var pickerState = States.Picker()

	var body: some View {
		ScrollView(.vertical) {
			NavigationLink("분류되지 않음", destination: ItemListView(items: items.filter { item in item.location == nil }))
				.foregroundColor(Color(uiColor: .label))
			LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
				ForEach(locations.sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }), id: \.self) { location in
					Button {
						LocationViewFactory.items = location.items ?? []
						navigationFlow.selectedLocation = location
						navigationFlow.navigateToLocationListView(location: location)
					} label: {
						LocationGridCell(location: location)
					}
					.buttonStyle(PlainButtonStyle())
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
				DatePickerForm(isPresenting: $pickerState.isDatePickerPresented, selectedDates: $pickerState.selectedDates, addingLocationName: $pickerState.addingLocationName)
			})
			.padding()
		}
		.navigationTitle("여행")
	}
}

// #Preview {
//	 LocationGridView(locations: [], items: [])
// }
