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

struct ExchangeURL {
	var urlComponents = URLComponents()
	var url: URL? {
		return urlComponents.url
	}

	init(authKey: String, date: String) {
		urlComponents.scheme = "https"
		urlComponents.host = "www.koreaexim.go.kr"
		urlComponents.path = "/site/program/financial/exchangeJSON"
		urlComponents.queryItems = [
			URLQueryItem(name: "authkey", value: authKey),
			URLQueryItem(name: "searchdate", value: date),
			URLQueryItem(name: "data", value: "AP01"),
		]
	}
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
			
			let currencyNameToFind = "일본 옌"
			filteredResponse = output.first { $0.cur_nm == currencyNameToFind }!
			
			if let response = filteredResponse {
				let curNmValue = response.cur_nm
				let dealBasR = response.deal_bas_r
				print("cur_nm Value: \(curNmValue)")
				print("deal_bar_r: \(dealBasR)")
			} else {
				print("No result found for \(currencyNameToFind)")
			}
			completionHandler(.success(filteredResponse?.result ?? 0))
		} catch {
			print("Error: JSON Data Parsing failed")
			completionHandler(.failure(error))
		}
	}.resume()
	
}

func fetchData() {
	let isAfter11AM = calendar.date(from: AM11).map { Date() > $0 } ?? false
	UserDefaults.standard.set(Date(), forKey: "LastFetchTime")
	
	if isAfter11AM {
		if let lastFetchTime = UserDefaults.standard.value(forKey: "LastFetchTime") as? Date,
		   calendar.isDateInToday(lastFetchTime) {
			print("Already fetched the data for today")
		} else {
			fetchDataForDate(date: Date())
		}
	} else {
		let yesterdayDate = yesterday()
		fetchDataForDate(date: yesterdayDate)
		print("not 11am yet")
	}
	print(filteredResponse?.result)
}

func fetchDataForDate(date: Date) {
	let exchangeURL = ExchangeURL(authKey: authKey, date: dateFormat(for: date, format: "yyyymmdd"))
	request(url: exchangeURL.url!.absoluteString, method: .get) { result in
		switch result {
		case .success(let data):
			print("Received data: \(data)")
		case .failure(let error):
			print("Error: \(error)")
		}
	}
}

func yesterday() -> Date {
	let calendar = Calendar.current
	return calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
}
