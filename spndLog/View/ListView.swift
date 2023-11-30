//
//  SpendingList.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/30/23.
//

import SwiftUI

struct SpendingList: View {
	@EnvironmentObject private var dataModel: DataModel
	@ObservedObject private var viewModel: SpendingListViewModel
	@State private var ampm: Bool = false

	var onTap: () -> Void
	
	init(items: [Item], onTap: @escaping () -> Void) {
		self.viewModel = SpendingListViewModel(items: items)
		self.onTap = onTap
	}

    var body: some View {
		let groupedByDate = viewModel.items.sortedByDate()
		
		ScrollView {
			ForEach(groupedByDate.sorted(by: { $0.0 > $1.0}), id: \.0) { date, itemsInDate in
				let sortedItems = itemsInDate.sorted { $0.timestamp > $1.timestamp }
				let sumForDate = sortedItems.reduce(0) { $0 + $1.calculatedBalance }
				
				LazyVStack(alignment: .leading, spacing: 0) {
					DateTitle(dataModel: dataModel, date: date, sumForDate: sumForDate, onTap: onTap)
					if !dataModel.foldedItems[date, default: false] {
						LazyVStack(alignment: .center, spacing: 0) {
							ForEach(sortedItems, id: \.self) { item in
								let currentIndex = sortedItems.firstIndex(of: item)!
								let previousItem = currentIndex > 0 ? sortedItems[currentIndex - 1] : nil
								SpendingItem(ampm: $ampm, item: item, prevItem: previousItem)
							}
						}.padding(.top)
					}
				}
			}
			.frame(width: UIScreen.main.bounds.width)
		}
		//			.coordinateSpace(name: "container")
		//			.onPreferenceChange(FramePreference.self, perform: {
		//				dateFrames = $0.sorted(by: { $0.minY < $1.minY })
		//			})
    }
}

#Preview {
	SpendingList(items: createTestItems() , onTap: {print("hello")})
		.environmentObject(DataModel())
}
