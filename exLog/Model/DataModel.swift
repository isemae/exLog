//
//  Currency.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import Foundation
import SwiftUI

class DataModel: ObservableObject {
	private let foldedItemsKey = "foldedItemsKey"
	@AppStorage("currencyKey") var currentCurrency: Currency = .KRW
	@AppStorage("ampmKey") var ampm: Bool = true
	@Published var foldedItems: [Date: Bool] {
		didSet {
			UserDefaults.standard.set(try? PropertyListEncoder().encode(self.foldedItems), forKey: self.foldedItemsKey)
			objectWillChange.send()
		}
	}
	init() {
		if let savedFoldedItemsData = UserDefaults.standard.data(forKey: foldedItemsKey),
		   let savedFoldedItems = try? PropertyListDecoder().decode([Date: Bool].self, from: savedFoldedItemsData) {
			self.foldedItems = savedFoldedItems
		} else {
			self.foldedItems = [:]
		}
		guard self.currentCurrency != .KRW else {
			return
		}
//		fetchAPIResponse(dataModel: self)
	}
	func getCurrentCurrencyCode() -> String {
		return currentCurrency.rawValue
	}
}

enum Currency: String, Identifiable, Hashable, CaseIterable, Codable {
	var id: Currency { self }
	case KRW
	case CAD
	case AUD
	case GBP
	case EUR
	case USD
	case JPY
	var symbol: String {
		switch self {
		case .KRW: return "₩"
		case .CAD: return "$"
		case .AUD: return "$"
		case .GBP: return "£"
		case .EUR: return "€"
		case .USD: return "$"
		case .JPY: return "¥"
		}
	}
	var code: String {
		switch self {
		case .KRW: return "KRW"
		case .CAD: return "CAD"
		case .AUD: return "AUD"
		case .GBP: return "GBP"
		case .EUR: return "EUR"
		case .USD: return "USD"
		case .JPY: return "JPY"
		}
	}
	var name: String {
		switch self {
		case .KRW: return "대한민국 원"
		case .USD: return "미국 달러"
		case .CAD: return "캐나다 달러"
		case .AUD: return "호주 달러"
		case .EUR: return "유로"
		case .GBP: return "영국 파운드"
		case .JPY: return "일본 엔"
		}
	}
	var signName: String {
		switch self {
		case .KRW: return "won"
		case .USD: return "dollar"
		case .CAD: return "dollar"
		case .AUD: return "australiandollar"
		case .EUR: return "euro"
		case .GBP: return "sterling"
		case .JPY: return "yen"
		}
	}
}
