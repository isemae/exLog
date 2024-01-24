//
//  DatePickerForm.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/17/24.
//

import SwiftUI
import SwiftData

struct DatePickerForm: View {
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@Environment(\.modelContext) private var modelContext
	@Query private var locations: [Location]
	@Binding var isPresenting: Bool
	@Binding var selectedDates: [Date]
	@Binding var addingLocationName: String
	var body: some View {
		VStack {
			DatePickerView(selectedDates: $selectedDates)
			TextField("위치...", text: $addingLocationName)
		}
		HStack {
			Button {
				isPresenting = false
				selectedDates = []
			} label : {
				Text("취소")
			}
			Button {
				let newLocation = Location(name: addingLocationName, startDate: selectedDates.first ?? Date(), endDate: selectedDates.last ?? Date(), items: [])
				isPresenting = false
				newLocation.name = addingLocationName
				newLocation.startDate = selectedDates.first
				newLocation.endDate = selectedDates.last
				newLocation.items = items.filter { item in
					if let startDate = newLocation.startDate, let endDate = newLocation.endDate {
						return startDate <= item.date && item.date <= endDate
					}
					return false
				}
				withAnimation(.easeOut(duration: 0.2)) {
					modelContext.insert(newLocation)
					saveContext()
				}

				addingLocationName = ""
				selectedDates = []
				for location in locations {
					print(location.name)
				}
			} label : {
				Text("확인")
			}
		}
	}

	func saveContext() {
		do {
			try modelContext.save()
			UISelectionFeedbackGenerator().selectionChanged()
		} catch {
			print("Error saving context: \(error)")
			UINotificationFeedbackGenerator().notificationOccurred(.warning)
		}
	}
}
//
// #Preview {
//	DatePickerForm(selectedDates: <#Binding<[Date]>#>)
// }
