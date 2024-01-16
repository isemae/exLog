//
//  CategoryCarousell.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/15/24.
//

import SwiftUI
import Foundation

struct CategoryCarouselView: View {
	@GestureState var translation: CGFloat = 0.0
	@State var lastOffset: CGFloat = .zero
	@State private var selectedCategory: String = "카"
	var categories = ["카", "테", "고", "리", "임"]

	var body: some View {
		//		ScrollView(.horizontal, showsIndicators: false) {
		Text("\(translation / 10)")
		Text("\(lastOffset)")
		HStack {
			ForEach(categories, id: \.self) { category in
				RoundedRectangle(cornerRadius: 10)
					.frame(width: Screen.width / 6.5, height: Screen.width / 6.5)
					.scaleEffect(category == selectedCategory ? 1.1 : 1.0)
					.onTapGesture {
						//							selectedCategory = category
					}
					.overlay(
						Text("\(category)")
							.foregroundColor( selectedCategory == category ? .blue : .white)
					)
			}
		}
		.padding()
		.gesture(
			DragGesture()
				.updating($translation) { value, state, _ in
					state = value.translation.width.rounded()
				}

				.onChanged { value in
					let threshold: CGFloat = 6
					let multiplier: CGFloat = 5
					let state = (value.translation.width / multiplier).rounded()
					let diff = state - (lastOffset / multiplier).rounded()

					// 임계의 배수일경우에 실행
					if state.truncatingRemainder(dividingBy: threshold) == 0 {
						lastOffset = value.translation.width
						handleSwipe(diff: diff)
						handleEdgeCases()
					}
				}
				.onEnded { _ in
					lastOffset = 0
				}
		)
		.animation(.spring())
	}

	func handleSwipe(diff: CGFloat) {
		if diff > 0 {
			handleRightSwipe()
		} else if diff < 0 {
			handleLeftSwipe()
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
		selectedCategory = categories[currentIndex - 1]
		print("left")
		UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
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

#Preview {
	CategoryCarouselView()
}
