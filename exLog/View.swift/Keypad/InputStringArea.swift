//
//  InputArea.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import SwiftUI
import SwiftData

struct InputStringArea: View {
	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@EnvironmentObject var dataModel: DataModel
	@ObservedObject private var sharedResponseManager = ResponseManager.shared
	@State private var contextMenuButtons: [Currency] = []
	//	@Binding var isShowingKeypad: Bool
	var string: String
//	let onSwipeUp: () -> Void
//	let onSwipeDown: () -> Void

	var body: some View {

			VStack(spacing: 0) {
				calculatedPreview()
				HStack {
					currencySelectorButton()
						.onAppear {
							contextMenuButtons = Currency.allCases
						}
					Spacer()
					Text(string.formatNumber())
//						.padding(.trailing, 10)
			.padding(.horizontal, 10)
				}
				.frame(height: Screen.height / 12)
				.padding(.horizontal, 10)
				.font(.largeTitle)
			}
			.contentShape(Rectangle())
			//		.onTapGesture(perform: {
			//			withAnimation(.spring(response: 0.15, dampingFraction: 1.1)) {
			//				isShowingKeypad.toggle()
			//			}
			//		})
			.overlayDivider(alignment: .top)
	}

	private func calculatedPreview() -> some View {
		VStack(spacing: 0) {
			HStack {
				Text("₩")
					.font(.title2)
					.frame(width: Screen.width / 10, height: Screen.width / 10)
				Spacer()
				Text("\(Int(round(Double(string) ?? 1.0) * sharedResponseManager.dealBasisRate))")
					.font(.title)
					.onChange(of: sharedResponseManager.dealBasisRate) { newDealBasisRate in
						_ = Int(round(Double(string) ?? 1.0) * newDealBasisRate)
					}
					.padding(.horizontal, 10)
			}
			.foregroundColor(.secondary)
			.padding(.horizontal, 10)
			Divider()
		}
		//		.opacity(isShowingKeypad ? 1 : 0)
		//		.frame(height: isShowingKeypad ? 40 : 0)
	}

	func currencySelectorButton() -> some View {
		VStack(spacing: 0) {
			Text(dataModel.currentCurrency.symbol)
				.font(.title)
			Text(dataModel.currentCurrency.code)
				.font(.footnote)
		}
		.frame(width: Screen.width / 8, height: Screen.width / 8)
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

struct InputAreaPreview: View {
	@State var string: String = "0"
	@State var testBool: Bool = true
	var body: some View {
		VStack {
			InputStringArea(string: string)
				.environmentObject(DataModel())
		}
		.font(.largeTitle)
	}
}

#Preview {
	InputAreaPreview()
}
