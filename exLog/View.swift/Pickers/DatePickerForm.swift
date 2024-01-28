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
		Text("일정 등록")
			.font(.headline)
			.padding()
		Divider()
			.padding(.horizontal)
		HStack {
			dateFromTo()
				.padding()
			Spacer()
		}
		Spacer()
		VStack(spacing: 0) {
			if selectedDates.count >= 1 {
				locationTextField()
			}
			Divider()
				.padding(.horizontal)
		}
		.padding(.trailing, Screen.width * 0.3)
		DatePickerView(selectedDates: $selectedDates)
			.ignoresSafeArea(.all)
			.padding()
		submitButtons()
	}

	func dateFromTo() -> some View {
		VStack(spacing: 5) {
			HStack {
				if selectedDates.count >= 1 {
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.foregroundStyle(.bar)
						Text(formattedDate(date: selectedDates.sorted().first))
							.padding(5)
					}
					.fixedSize()
					if selectedDates.count >= 2 {
						Text("에서")
					}
				}
			}

			HStack {
				if selectedDates.count >= 2 {
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.foregroundStyle(.bar)
						Text(formattedDate(date: selectedDates.sorted().last))
							.padding(5)
					}
					.fixedSize()
					Text("까지")
				}
			}
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
			.padding()
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
		DatePickerForm(isPresenting: $isPresenting, selectedDates: $selectedDates, addingLocationName: $addingLocationName)
	}
}

#Preview {
	DatePickerFormPreview()
}
