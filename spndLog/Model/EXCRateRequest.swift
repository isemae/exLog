//
//  EXCRateResponse.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/23/23.


import Foundation
import SwiftData


enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
}
var currencyCode = "JPY"
struct ExchangeURL {
	var urlComponents = URLComponents()
	var url: URL? {
		return urlComponents.url
	}

	init() {
		urlComponents.scheme = "https"
		urlComponents.host = "quotation-api-cdn.dunamu.com"
		urlComponents.path = "/v1/forex/recent"
		urlComponents.queryItems = [
			URLQueryItem(name: "codes", value: "FRX.KRWJPY"),
		]
	}
//	init(authKey: String, date: String) {
//		urlComponents.scheme = "https"
//		urlComponents.host = "www.koreaexim.go.kr"
//		urlComponents.path = "/site/program/financial/exchangeJSON"
//		urlComponents.queryItems = [
//			URLQueryItem(name: "authkey", value: authKey),
//			URLQueryItem(name: "searchdate", value: date),
//			URLQueryItem(name: "data", value: "AP01"),
//		]
//	}
	
}

func request(url: String, method: HTTPMethod, param: [String: Any]? = nil, completionHandler: @escaping (Result<Int, Error>) -> Void) {
	
	guard let url = URL(string: url) else {
		print("Error: Cannot create URL")
		completionHandler(.failure(NSError(domain: "URLCreationError", code: 0, userInfo: nil)))
		return
	}

	var request = URLRequest(url: url)
	request.httpMethod = method.rawValue

	if let param = param {
		let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = sendData
	}
	
	let session = URLSession.shared
	
	session.dataTask(with: request) { data, response, error in
		guard error == nil else {
			print("Error: \(error!)")
			completionHandler(.failure(error!))
			return
		}
		
		guard let data = data else {
			print("Error: Could not receive data")
			completionHandler(.failure(NSError(domain: "NoDataError", code: 0, userInfo: nil)))
			return
		}
		
		guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
			print("Error: HTTP request failed")
			completionHandler(.failure(NSError(domain: "HTTPError", code: 0, userInfo: nil)))
			return
		}
		
		do {
			let decoder = JSONDecoder()
			let output = try decoder.decode([Response].self, from: data)
			
			let currencyCodeToFind = "JPY"
			filteredResponse = output.first { $0.currencyCode == currencyCodeToFind }
			
			if let response = filteredResponse {
				let curNmValue = response.currencyCode
				let dealBasR = response.basePrice
				print("cur_nm Value: \(curNmValue)")
				print("deal_bar_r: \(dealBasR)")
			} else {
				print("No result found for \(currencyCodeToFind)")
			}
			completionHandler(.success(filteredResponse?.id ?? 0))
		} catch {
			print("Error: JSON Data Parsing failed")
			completionHandler(.failure(error))
		}
	}.resume()
	
}

func fetchData() {
	let exchangeURL = ExchangeURL()
//	let exchangeURL = ExchangeURL(authKey: authKey, date: dateFormat(for: Date(), format: "default"))
//	for key in UserDefaults.standard.dictionaryRepresentation().keys {
//		UserDefaults.standard.removeObject(forKey: key.description)
//	}
//	UserDefaults.standard.set(Date(), forKey: "LastFetchTime")
	
//	if let AM11 = calendar.date(from: AM11), Date() > AM11 {
//		if let lastFetchTime = UserDefaults.standard.value(forKey: "LastFetchTime") as? Date,
//		   calendar.isDateInToday(lastFetchTime) {
//			print("maybe tomorrow")
//		} else {
	request(url: exchangeURL.url!.absoluteString, method: .get) { result in
				switch result {
				case .success(let data):
					print("Received data: \(data)")
					
				case .failure(let error):
					print("Error: \(error)")
				}
			}
		}
