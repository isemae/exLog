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
						if diff > 0 {
							// 우측스와이프
							if let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex < categories.count - 1 {
								selectedCategory =  categories[currentIndex + 1]
								print("right")
								UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
								lastOffset = value.translation.width
							}
							// 마지막항목일 경우
							if let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex == categories.count - 1 {
								selectedCategory = categories[categories.count - 1]
								print("right end")
							
								lastOffset = value.translation.width
							}
						}
						if diff < 0 {
							// 좌측스와이프
							if let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex > 0 {
								selectedCategory = categories[currentIndex - 1]
								print("left")
								UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
								lastOffset = value.translation.width
							}
							// 첫항목일경우
							if let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex == 0 {
								selectedCategory = categories[0]
								print("left end")
								
								lastOffset = value.translation.width
							}
						}
					}
				}
				.onEnded { _ in
					lastOffset = 0
				}
		)
		.animation(.spring())
	}
}
// }

#Preview {
	CategoryCarouselView()
}
