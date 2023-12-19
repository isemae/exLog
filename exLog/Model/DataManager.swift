//
//  ResponseData.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/23/23.


import Foundation
import SwiftData
import Combine

class DataManager: ObservableObject {
		
	static let shared = DataManager()
	
	@Published var filteredResponse: Response? {
		didSet {
			self.updateDealBasisRate()
		}
	}
	
	@Published var dealBasisRate : Double = 1.0
	
	func updateDealBasisRate() {
		dealBasisRate = (Double(self.filteredResponse?.basePrice ?? 100) ) / Double(self.filteredResponse?.currencyUnit ?? 100)
	}
}

class DataCache {
	static var items: [Item] = []
}

struct ResponseArray: Codable {
	var data: [Response] = []
}

struct Response: Codable {
	var id: Int
//	var date: Date
//	var time: Date
	var currencyCode: String
	var currencyName: String
	var basePrice: Double
	var currencyUnit: Int
}



//struct Response: Codable {
//	var result: Int
//	var cur_unit: String
//	var cur_nm: String
//	var deal_bas_r: String
////	var ttb: String
////	var tts: String
////	var bkpr: String
////	var yy_efee_r: String
////	var ten_dd_efee_r: String
////	var kftc_bkpr: String
////	var kftc_deal_bas_r: String
//}

//func addResponse(result: Int, cur_unit: String, ttb: String, tts: String, deal_bas_r: String, bkpr: String, yy_efee_r: String, ten_dd_efee_r: String, kftc_bkpr: String, kftc_deal_bas_r: String, cur_nm: String) {
//	let newResponse = Response(result: result, cur_unit: cur_unit, cur_nm: cur_nm, deal_bas_r: deal_bas_r)
//	ResponseArray.append(newResponse)
//}

