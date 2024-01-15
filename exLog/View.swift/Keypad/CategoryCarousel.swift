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
			Text("\(translation)")
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
						state = value.translation.width
					}
				
					.onChanged { value in
						let threshold: CGFloat = 50
						if value.translation.width > threshold {
							if let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex < categories.count - 1 {
								selectedCategory =  categories[currentIndex + 1]
								print("right")
								UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
							}
							if let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex == categories.count - 1 {
								selectedCategory = categories[categories.count - 1]
								print("right end")
								UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
							}
						} else if value.translation.width < -threshold {
							if let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex > 0 {
								selectedCategory = categories[currentIndex - 1]
								print("left")
								UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
							}
							if let currentIndex = categories.firstIndex(of: selectedCategory), currentIndex == 0 {
								selectedCategory = categories[0]
								print("left end")
								UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
							}
						}
					}
			)
		.animation(.spring())
		}
	}
// }

#Preview {
	CategoryCarouselView()
}
