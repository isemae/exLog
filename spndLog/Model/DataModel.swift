//
//  Currency.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import Foundation

class DataModel: ObservableObject {
	private let foldedItemsKey = "foldedItemsKey"
	private var currencyKey = "selectedCurrency"
	@Published var foldedItems: [Date: Bool] {
		didSet {
			UserDefaults.standard.set(try? PropertyListEncoder().encode(foldedItems), forKey: foldedItemsKey)
		}
	}
	
	@Published var currentCurrency: Currency = .USD {
		didSet {
			UserDefaults.standard.set(currentCurrency.rawValue, forKey: currencyKey)
		}
	}
	
	
	init() {
		if let savedFoldedItemsData = UserDefaults.standard.data(forKey: foldedItemsKey),
		   let savedFoldedItems = try? PropertyListDecoder().decode([Date: Bool].self, from: savedFoldedItemsData) {
			self.foldedItems = savedFoldedItems
		} else {
			self.foldedItems = [:]
		}
		
		fetchData(dataModel: self)
		DispatchQueue.global().async {
			if let savedCurrencyCode = UserDefaults.standard.string(forKey: self.currencyKey),
			   let savedCurrency = Currency(rawValue: savedCurrencyCode) {
				//				DispatchQueue.main.async {
				self.currentCurrency = savedCurrency
			}
		}
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
}

enum Category {
	case shopping
	case drink
	case food
	case liquor
	case entertainment
	case transportation
	case accommodation

	var symbol: String {
		switch self {
		case .shopping: return "🛒"
		case .drink: return "🍹"
		case .food: return "🥘"
		case .liquor: return "🍻"
		case .entertainment: return "🥳"
		case .transportation: return "🚋"
		case .accommodation: return "🛌🏻"
		}
	}
}


