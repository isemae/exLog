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
				ZStack {
					Rectangle()
						.foregroundColor(Color(uiColor: UIColor.secondarySystemBackground))
						.overlay(
							Divider().frame(alignment: .bottom),
							alignment:.top)
						.frame(height: 40)
					HStack {
						Text("₩ ")
						Spacer()
						Text("\(Int(round(Double(string) ?? 1.0) * sharedDataManager.dealBasisRate))")
							.onChange(of: sharedDataManager.dealBasisRate) { newDealBasisRate in
								let updatedValue = Int(round(Double(string) ?? 1.0) * newDealBasisRate)
								//							print("Updated Value: \(updatedValue)")
							}
					}.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
						.padding(.horizontal, 35)
						.transition(.opacity.combined(with: .move(edge: .bottom)))
				}
			}
			
			ZStack {
				Rectangle()
					.foregroundColor(Color(uiColor: UIColor.systemBackground))
					.overlay(
						Divider().frame(alignment: .bottom), alignment: .top)
					.frame(height: 80)
				HStack {
					VStack(spacing: 0) {
						Text(dataModel.currentCurrency.symbol)
						Text(dataModel.currentCurrency.code).font(.footnote)
					}
					.frame(width: 60, height: 60)
					.background(RoundedRectangle(cornerRadius: 10)
						.foregroundColor(Color(uiColor: UIColor.systemBackground)))
					.contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15))
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
						.padding(.horizontal, 10)
			}
			.font(.largeTitle)
		}
		.onTapGesture(perform: {
			DispatchQueue.main.async {
				   withAnimation(.spring(response: 0.2, dampingFraction: 1.0)) {
					   isShowingKeypad.toggle()
				   }
			}
			
		   })
			.GestureHandler(onSwipeUp: onSwipeUp, onSwipeDown: onSwipeDown)
	}
}
