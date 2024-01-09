//
//  ResponseData.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/23/23.

import Foundation
import SwiftData

class ResponseManager: ObservableObject {
	static let shared = ResponseManager()
	@Published var dealBasisRate : Double = 1.0
	@Published var filteredResponse: Response? {
		didSet {
			self.updateDealBasisRate()
		}
	}

	func updateDealBasisRate() {
		if let filteredResponse = filteredResponse {
			dealBasisRate = Double(filteredResponse.basePrice) / Double(filteredResponse.currencyUnit)
		} else {
			dealBasisRate = 1.0
		}
	}
}

// SwiftData fetch시 캐싱을 위해 사용할 예정
// class DataCache {
//	static var items: [Item] = []
// }

struct ResponseArray: Codable {
	var data: [Response] = []
}

struct Response: Codable {
	var id: Int
	var currencyCode: String
	var currencyName: String
	var basePrice: Double
	var currencyUnit: Int

	// 마지막으로 API를 받아온 후 일정 시간만큼 지났는지 조회하기 위한 변수
	//	var date: Date
	//	var time: Date
}
