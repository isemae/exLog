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
	@Binding var selectedCategory: Category
	var categories = Category.allCases

	var body: some View {
		//		ScrollView(.horizontal, showsIndicators: false) {
		var itemWidth = Screen.width / 7
		GeometryReader { geo in
			let categoryWidth =  itemWidth
			let centerX = CGFloat(categories.firstIndex(of: selectedCategory)!) * categoryWidth

			HStack {
				ForEach(categories, id: \.self) { category in
					if category != .nil {
						RoundedRectangle(cornerRadius: 10)
							.frame(width: itemWidth, height:  itemWidth)
							.scaleEffect(category == selectedCategory ? 1.1 : 1.0)
							.foregroundColor( selectedCategory == category ? .accentColor : .white)
							.overlay(
								Text("\(category.symbol)")
							)
							.onTapGesture {
								withAnimation(.spring(duration: 0.2)) {
									selectedCategory = category
									UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
								}
							}
					}
				}
			}
			.frame(width: geo.size.width, alignment: .leading)
			.padding()
			.offset(x: -CGFloat(categories.firstIndex(of: selectedCategory)! - 1) * categoryWidth)
			.gesture(
				DragGesture()
					.updating($translation) { value, state, _ in
						state = value.translation.width.rounded()
					}
					.onChanged { value in
						let threshold: CGFloat = 5
						let multiplier: CGFloat = 5
						let state = (value.translation.width / multiplier).rounded()
						let diff = state - (lastTranslation / multiplier).rounded()

						// 임계값의 배수일경우에 실행
						if state.truncatingRemainder(dividingBy: threshold) == 0 {
							withAnimation(.spring(duration: 0.2)) {
								lastTranslation = value.translation.width
								handleSwipe(diff: diff)
								handleEdgeCases()
							}
						}
					}
					.onEnded { _ in
						lastTranslation = 0
					}
			)
		}
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
		print("right")
		UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
	}

	func handleLeftSwipe() {
		guard let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex > 0 else {
			return
		}

		let previousIndex = currentIndex - 1
			if categories[previousIndex] != .nil {
			selectedCategory = categories[currentIndex - 1]
			print("left")
			UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
		}
	}

	func handleEdgeCases() {
		if categories.firstIndex(of: selectedCategory) == categories.count - 1 {
			print("right end")
		}
		if categories.firstIndex(of: selectedCategory) == 0 {
			print("left end")
		}
	}
}
//
// #Preview {
//	CategoryPickerView()
// }
