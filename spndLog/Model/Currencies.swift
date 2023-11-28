//
//  Currency.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/26/23.
//

import Foundation

class CurrencySettings: ObservableObject {
	private var currencyKey = "selectedCurrency"

	@Published var currentCurrency: Currency = .USD {
		didSet {
			UserDefaults.standard.set(currentCurrency.rawValue, forKey: currencyKey)
		}
	}
	
	init() {
//		fetchData(currencySettings: self)
//		DispatchQueue.global().async {
//			if let savedCurrencyCode = UserDefaults.standard.string(forKey: self.currencyKey),
//			   let savedCurrency = Currency(rawValue: savedCurrencyCode) {
//				DispatchQueue.main.async {
//					self.currentCurrency = savedCurrency
//				}
//			}
//		}
	}
	
	func getCurrentCurrencyCode() -> String {
		return currentCurrency.rawValue
	}
}

enum Currency: String, CaseIterable, Identifiable {
	var id: Currency { self }

	case KRW
	case USD
	case EUR
	case JPY
	case GBP
	case AUD
	case CAD
	
	var symbol: String {
		switch self {
		case .KRW: return "₩"
		case .USD: return "$"
		case .EUR: return "€"
		case .JPY: return "¥"
		case .GBP: return "£"
		case .AUD: return "$"
		case .CAD: return "$"
		}
	}
	
	var code: String {
		switch self {
		case .KRW: return "KRW"
		case .USD: return "USD"
		case .EUR: return "EUR"
		case .JPY: return "JPY"
		case .GBP: return "GBP"
		case .AUD: return "AUD"
		case .CAD: return "CAD"
		}
	}
	
	var name: String {
		switch self {
		case .KRW: return "대한민국 원"
		case .USD: return "미국 달러"
		case .EUR: return "유로"
		case .JPY: return "일본 엔"
		case .GBP: return "영국 파운드"
		case .AUD: return "호주 달러"
		case .CAD: return "캐나다 달러"
		}
	}
}

