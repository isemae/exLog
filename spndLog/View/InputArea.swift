//
//  InputArea.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct InputArea: View {
	@EnvironmentObject var dataModel: DataModel
	@ObservedObject private var sharedDataManager = DataManager.shared
	@Binding var isShowingKeypad: Bool
	var string: String
	let onSwipeUp: () -> Void
	let onSwipeDown: () -> Void
	
	var body: some View {
		VStack(spacing: 0) {
			if isShowingKeypad {
				CalculatedPreview()
			}
				HStack {
					VStack(spacing: 0) {
						Text(dataModel.currentCurrency.symbol)
						Text(dataModel.currentCurrency.code).font(.footnote)
					}
					.frame(width: 60, height: 60)
					.contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
					.contextMenu(menuItems: {
						ForEach(Currency.allCases, id: \.self) { curr in
							Button {
								dataModel.currentCurrency = curr
								DispatchQueue.global().async {
									fetchData(dataModel: dataModel)
								}
							} label: {
								Label("\(curr.name)", systemImage: "\(curr.signName)sign")
							}
						}
					})
					Spacer()
					Text(string.formatNumber())
						.padding(.trailing, 20)
				}
				
				.frame(height: 80)
				.padding(.horizontal, 10)
				.background(.bar)
//				.background(					Color(uiColor: UIColor.systemBackground)
//				, in: Rectangle())
				.overlay(
					Divider().frame(alignment: .bottom), alignment: .top)
				.font(.largeTitle)
		}
		
		.overlay(
			Divider().frame(alignment: .bottom),
			alignment:.top)
		.onTapGesture(perform: {
				withAnimation(.spring(response: 0.1, dampingFraction: 1.0)) {
					isShowingKeypad.toggle()
				}
		})
		.GestureHandler(onSwipeUp: onSwipeUp, onSwipeDown: onSwipeDown)
	}
	
	private func CalculatedPreview() -> some View {
				HStack {
					Text("₩ ")
					Spacer()
					Text("\(Int(round(Double(string) ?? 1.0) * sharedDataManager.dealBasisRate))")
						.onChange(of: sharedDataManager.dealBasisRate) { newDealBasisRate in
							let updatedValue = Int(round(Double(string) ?? 1.0) * newDealBasisRate)
							//							print("Updated Value: \(updatedValue)")
						}
				}
				.foregroundColor(.secondary)
				.frame(height: 40)
				.padding(.horizontal, 35)
				.background(.ultraThinMaterial, in: Rectangle())
				.transition(.opacity.combined(with: .move(edge: .bottom)))
					
			
		
	}
}
struct inputAreaPreview: View {
	@State var string: String = "0"
	@State var testBool: Bool = true
	var body: some View {
		VStack {
			InputArea(isShowingKeypad: $testBool, string: string, onSwipeUp: {}, onSwipeDown: {})
				.environmentObject(DataModel())
		}
		.font(.largeTitle)
	}
}

#Preview {
	inputAreaPreview()
}
