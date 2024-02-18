//
//  DatePickerForm.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/17/24.
//

import SwiftUI
import SwiftData

struct LocationForm: View {
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@Environment(\.modelContext) private var modelContext
	@Query private var locations: [Location]
	@Binding var isPresenting: Bool
	@Binding var selectedDates: [Date]
	@Binding var addingLocationName: String
	var body: some View {
		NavigationStack {
			Divider()
			dateFromTo()
				.padding()
			VStack {
				if selectedDates.count >= 1 {
					locationTextField()
				}
				Spacer()
				DatePickerView(selectedDates: $selectedDates)
					.ignoresSafeArea(.all)
				submitButtons()
			}
			.padding()
			.navigationTitle("일정 등록")
			.navigationBarTitleDisplayMode(.inline)
		}
	}

	func dateFromTo() -> some View {
		HStack(spacing: 5) {
			VStack(alignment: .leading) {
				ForEach(selectedDates, id: \.self) { date in
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.foregroundStyle(.bar)
						Text(formattedDate(date: date))
							.padding(5)
					}
					.fixedSize()
				}
			}
			VStack {
				if selectedDates.count >= 2 {
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.foregroundStyle(.clear)
						Text("에서")
							.padding(5)
					}
					.fixedSize()
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.foregroundStyle(.clear)
						Text("까지")
							.padding(5)
					}
					.fixedSize()
				}
			}
			Spacer()
		}
	}

	func locationTextField() -> some View {
		let today = Calendar.current.startOfDay(for: Date())
		var placeholder = ""

		switch today {
		case ..<selectedDates.first!:
			placeholder = "어디로 떠날까요?"
		case selectedDates.first!...selectedDates.last!:
			placeholder = "어디를 여행중인가요?"
		default:
			placeholder = "어디에 다녀왔나요?"
		}
		return TextField(placeholder, text: $addingLocationName)
			.font(.title)
			.bold()
	}

	func submitButtons() -> some View {
		HStack {
			Button(role: .cancel) {
				isPresenting = false
			} label : {
				Text("취소")
			}
			Button {
				let calendar = Calendar.current
				if let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDates.last ?? Date()) {
					let newLocation = Location(name: addingLocationName, startDate: selectedDates.first ?? Date(), endDate: endDate, items: [])
					isPresenting = false

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
				}

				print(selectedDates)
				addingLocationName = ""
				selectedDates = []
				for location in locations {
					print(location.name)
				}
			} label : {
				Text("확인")
			}
			.buttonStyle(.borderedProminent)
			.disabled(selectedDates.isEmpty)
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

struct DatePickerFormPreview: View {
	@State var selectedDates: [Date] = []
	@State var isPresenting = true
	@State var addingLocationName = ""
	var body: some View {
		LocationForm(isPresenting: $isPresenting, selectedDates: $selectedDates, addingLocationName: $addingLocationName)
	}
}

#Preview {
	DatePickerFormPreview()
}
