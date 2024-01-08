//
//  InputArea.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI

struct InputArea: View {
	@EnvironmentObject var dataModel: DataModel
	@ObservedObject private var sharedResponseManager = ResponseManager.shared
	@State private var contextMenuButtons: [Currency] = []
	@Binding var isShowingKeypad: Bool
	var string: String
	let onSwipeUp: () -> Void
	let onSwipeDown: () -> Void
	
	var body: some View {
		VStack(spacing: 0) {
			CalculatedPreview()
			HStack {
				CurrencySelectorButton()
					.onAppear {
						contextMenuButtons = Currency.allCases
					}
				Spacer()
				Text(string.formatNumber())
					.padding(.trailing, 20)
			}
			.frame(height: 65)
			.padding(.horizontal, 10)
			.font(.largeTitle)
		}
		.contentShape(Rectangle())
		.onTapGesture(perform: {
			withAnimation(.spring(response: 0.15, dampingFraction: 1.1)) {
				isShowingKeypad.toggle()
			}
		})
		.overlayDivider(alignment: .top)
		.GestureHandler(onSwipeUp: onSwipeUp, onSwipeDown: onSwipeDown)
	}
	
	private func CalculatedPreview() -> some View {
		VStack {
			HStack {
				Text("₩")
					.frame(width: 50)
				Spacer()
				Text("\(Int(round(Double(string) ?? 1.0) * sharedResponseManager.dealBasisRate))")
					.onChange(of: sharedResponseManager.dealBasisRate) { newDealBasisRate in
						let updatedValue = Int(round(Double(string) ?? 1.0) * newDealBasisRate)
					}
					.padding(.trailing, 25)
			}
			.foregroundColor(.secondary)
			.padding(.horizontal, 10)
			Divider()
				.padding(.horizontal, 10)
		}
		.opacity(isShowingKeypad ? 1 : 0)
		.frame(height: isShowingKeypad ? 40 : 0)
		
	}
	
	func CurrencySelectorButton() -> some View {
		VStack(spacing: 0) {
			Text(dataModel.currentCurrency.symbol)
			Text(dataModel.currentCurrency.code).font(.footnote)
		}
		.frame(width: 50, height: 50)
		.contentShape(RoundedRectangle(cornerRadius: 10))
		.contextMenu(menuItems: {
			ForEach(contextMenuButtons, id: \.self) { curr in
				Button {
					dataModel.currentCurrency = curr
					fetchAPIResponse(dataModel: dataModel)
				} label: {
					Label("\(curr.name)", systemImage: "\(curr.signName)sign")
				}
			}
		})
		.font(.title)
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
