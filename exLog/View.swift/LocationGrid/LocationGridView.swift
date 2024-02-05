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
	let columns = [
		GridItem(.fixed(160)),
		GridItem(.fixed(160))
	]
	var body: some View {
		ZStack(alignment: .bottom) {
			ScrollView(.vertical) {
				LazyVGrid(columns: columns) {
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
					ToolbarItem(placement: .navigationBarTrailing) {}
				}
				.sheet(isPresented: $pickerState.isDatePickerPresented, content: {

					LocationForm(isPresenting: $pickerState.isDatePickerPresented, selectedDates: $pickerState.selectedDates, addingLocationName: $pickerState.addingLocationName)

				})
				.padding()
			}
			ZStack {
				Circle()
					.foregroundColor(.accentColor)
				Image(systemName: "calendar.badge.plus")
					.foregroundColor(Color(uiColor: .label))
					.font(.title)
			}
			.frame(width: 65, height: 65)
			.onTapGesture {
				pickerState.isDatePickerPresented.toggle()
			}
			.padding()
		}
		.navigationTitle("여행")
	}
}

// #Preview {
//	 LocationGridView(locations: [], items: [])
// }
