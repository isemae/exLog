//
//  Currency.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import Foundation
//import Combine

class DataModel: ObservableObject {
	private let foldedItemsKey = "foldedItemsKey"
	private var currencyKey = "selectedCurrency"
	@Published var foldedItems: [Date: Bool] {
		didSet {
			UserDefaults.standard.set(try? PropertyListEncoder().encode(self.foldedItems), forKey: self.foldedItemsKey)
			objectWillChange.send()
		}
	}
		
	@Published var currentCurrency: Currency = Currency(rawValue: (UserDefaults.standard.value(forKey: "selectedCurrency") as? String ?? "nullKey")) ?? .KRW {
		didSet {
			UserDefaults.standard.set(self.currentCurrency.rawValue, forKey: self.currencyKey)
		}
	}
	
	@Published var ampm: Bool = true {
		didSet {
			UserDefaults.standard.set(ampm, forKey: "ampm")
		}
	}
	
//	var cancellable: AnyCancellable?

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
		
		fetchData(dataModel: self)
			if let savedCurrencyCode = UserDefaults.standard.string(forKey: self.currencyKey),
			   let savedCurrency = Currency(rawValue: savedCurrencyCode) {
				//				DispatchQueue.main.async {
				self.currentCurrency = savedCurrency
				
				
				/// hang
//				self.$currentCurrency
//					.sink { newValue in
//						DataManager.shared.updateDealBasisRate()
//						print("Currency changed to \(newValue)")
//					}
//					.store(in: &self.cancellables)
			}
	}
	
//	deinit {
//		cancellable?.cancel()
//	}
	
	func formattedHeaderDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		return dateFormatter.string(from: date)
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


