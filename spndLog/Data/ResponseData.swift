//
//  ResponseData.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/23/23.


import Foundation
import SwiftData

struct ResponseArray: Codable {
	var data: [Response] = []
}
struct Response: Codable {
	var id: Int
	var currencyCode: String
	var currencyName: String
//	var date: Date
//	var time: Date
	var basePrice: Double

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

var filteredResponse: Response?


var groupedResponses: [String: Response] = [:]
//
//func returnEXCData() -> Response? {
//	if let currencyName = Response.cur_nm {
//			print("Result for \(currencyName): \(response)")
//			return response
//		} else {
//			print("No result found for \(currencyName)")
//			if let responseToAdd = ResponseArray.first(where: { $0.cur_nm == currencyNameToFind }) {
//				groupedResponses[currencyName] = responseToAdd
//				return responseToAdd
//			} else {
//				return nil
//			}
//		}
//}
//
//func addResponse(result: Int, cur_unit: String, ttb: String, tts: String, deal_bas_r: String, bkpr: String, yy_efee_r: String, ten_dd_efee_r: String, kftc_bkpr: String, kftc_deal_bas_r: String, cur_nm: String) {
//	let newResponse = Response(result: result, cur_unit: cur_unit, cur_nm: cur_nm, deal_bas_r: deal_bas_r)
//	ResponseArray.append(newResponse)
//}

