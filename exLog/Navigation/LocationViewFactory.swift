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
	@EnvironmentObject private var dataModel: DataModel
	static var items: [Item] = []
	static func setViewForDestination(_ destination: LocationNavigation, location: Location) -> AnyView {
		switch destination {
		case .inputView:
			return AnyView(InputView())
		case .locationGrids:
			return AnyView(LocationGridView()
				.navigationTitle("여행"))
		case .locationLists:
			return AnyView(ListCarouselView(location: location))
		}

	}
}
