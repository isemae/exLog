//
//  NavigationFlow.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/22/24.
//

import Foundation
import SwiftUI

class NavigationFlow: ObservableObject {
	static let shared = NavigationFlow()

	@Published var path = NavigationPath()
	@Published var selectedLocation: Location = Location(name: "", startDate: Date(), endDate: Date(), items: [])

	func clear() {
		path = .init()
	}

	func navigateBackToRoot() {
		path.removeLast(path.count)
	}

	func backToPrevious() {
		path.removeLast()
	}

	func navigateToLocationGridView() {
		path.append(LocationNavigation.locationGrids)
	}

	func navigateToLocationListView(location: Location) {
		path.append(LocationNavigation.locationLists)
	}

	func done() {
		path = .init()
	}
}
