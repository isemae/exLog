//
//  ListViewFactory.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/22/24.
//

import Foundation
import SwiftUI
import SwiftData

class LocationViewFactory {
	static var items: [Item] = []
	static func setViewForDestination(_ destination: LocationNavigation, location: Location? = nil, string: Binding<String>) -> AnyView {
		switch destination {
		case .inputView:
			return AnyView(InputView(string: string, onSwipeUp: {}, onSwipeDown: {}))
		case .locationGrids:
			return AnyView(LocationGridView())
		case .locationLists:
			return AnyView(ItemListView(items: items, location: location))
		}

	}
}
