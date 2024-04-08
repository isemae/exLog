//
//  ContentView.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@EnvironmentObject var navigationFlow: NavigationFlow
	let modelContext: ModelContext

	@Query(sort: \Item.date, order: .reverse) private var items: [Item]
	@Query private var locations: [Location]

	@State var keypadState = States.Keypad()
	@State private var image: UIImage?

	var body: some View {
		NavigationStack(path: $navigationFlow.path) {
			InputView()
				.navigationDestination(for: LocationNavigation.self) { destination in
					LocationViewFactory.setViewForDestination(destination, location: navigationFlow.selectedLocation)
				}
		}
	}

//	func initialView() -> some View {
//		withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
//				Group {
//					ZStack {
//						VStack(spacing: 0) {
//							if keypadState.isShowingKeypad {
//								VStack(alignment: .leading) {
//									ForEach([
//										("arrow.up", "hand.tap.fill", " - 내역을 등록해요."),
//										("arrow.down", "hand.tap.fill", " - 가장 최근의 내역이 삭제돼요.")
//									], id: \.0) { icons in
//										HStack(spacing: 0) {
//											Image(systemName: icons.1)
//												.frame(height: 40)
//											Image(systemName: icons.0)
//											Text(icons.2)
//										}
//									}
//								}
//							}
//							Image(systemName: "pencil.and.list.clipboard")
//								.resizable()
//								.scaledToFit()
//								.padding(30)
//								.padding(.leading, 25)
//								.frame(width: 200, height: 200, alignment: .center)
//								.foregroundColor(Color(uiColor: .placeholderText))
//							Text("내역이 없어요.")
//							Text("하단의 입력창을 탭해보세요!")
//						}
//						.frame(maxHeight: .infinity)
//					}
//					Text("")
//						.frame(maxHeight: .infinity)
//						.safeAreaInset(edge: .bottom, spacing: 0) {
//							Keypad(string: $keypadState.string)
//								.transition(.move(edge: .bottom))
//						}
//				}
//		}
//	}

}

//
// #Preview {
//    ContentView()
//		.modelContainer(for: [Item.self], inMemory: true)
//		.environmentObject(DataModel())
// }
