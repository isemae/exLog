//
//  CategoryCarousell.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/15/24.
//

import SwiftUI
import Foundation

struct CategoryPickerView: View {
	@GestureState var translation: CGFloat = 0.0
	@State var lastTranslation: CGFloat = .zero
	@State var offset = 0
	@State var lastOffset = 0
	@Binding var selectedCategory: Category
	var categories = Category.allCases

	var body: some View {
		GeometryReader { geo in
			let itemWidth = geo.size.width / 7
			HStack {
				ForEach(categories, id: \.self) { category in
					if category != .nil {
						ZStack {
							RoundedRectangle(cornerRadius: 10)
								.frame(width: itemWidth, height:  itemWidth)
								.scaleEffect(category == selectedCategory ? 1.2 : 1.0)
								.foregroundColor(selectedCategory == category ? .accentColor : Color(uiColor: .secondarySystemBackground))
							Text("\(category.symbol)")
								.font(.title2)
								.transition(.scale)
						}
						.onTapGesture {
							if category != selectedCategory {
								withAnimation(.spring(duration: 0.2)) {
									selectedCategory = category
									UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
								}
							} else {
								withAnimation(.spring(duration: 0.2)) {
									selectedCategory = .nil
									UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
								}
							}
						}
					}
				}
			}
			.frame(width: geo.size.width, alignment: .leading)
			.padding()
			.offset(x: -CGFloat(categories.firstIndex(of: selectedCategory)! - 1) * (itemWidth + 8) - itemWidth / 1.25 + geo.size.width * 0.5)
			.background()
			.gesture(
				DragGesture()
					.updating($translation) { value, state, _ in
						state = value.translation.width
					}
					.onChanged { value in
						offset = lastOffset + Int(translation)
						let threshold: CGFloat = 5
						let state = (value.translation.width / 3).rounded(.toNearestOrEven)
						let diff = state - (lastTranslation).rounded(.toNearestOrEven)

						// 임계값의 배수일경우에 실행
						if state.truncatingRemainder(dividingBy: threshold).rounded(.toNearestOrEven) == 0 {
							withAnimation(.spring(duration: 0.15)) {
								lastTranslation = state
								handleSwipe(diff: diff)
								handleEdgeCases()
							}
						}
					}
					.onEnded { _ in
						lastOffset = offset
					}
			)
		}
		.frame(height: Screen.height / 8)
	}

	func handleSwipe(diff: CGFloat) {
		if diff > 0 {
			handleLeftSwipe()
		} else if diff < 0 {
			handleRightSwipe()
		}
	}

	func handleRightSwipe() {
		guard let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex < categories.count - 1 else {
			return
		}

		selectedCategory =  categories[currentIndex + 1]
		UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
	}

	func handleLeftSwipe() {
		guard let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex > 0 else {
			return
		}

		let previousIndex = currentIndex - 1
		if categories[previousIndex] != .nil {
			selectedCategory = categories[currentIndex - 1]
			UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
		}
	}

	func handleEdgeCases() {
		if categories.firstIndex(of: selectedCategory) == categories.count - 1 { }
		if categories.firstIndex(of: selectedCategory) == 0 { }
	}
}
//
// #Preview {
//	CategoryPickerView()
// }
