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

	init(dataModel: DataModel) {
		urlComponents.scheme = "https"
		urlComponents.host = "quotation-api-cdn.dunamu.com"
		urlComponents.path = "/v1/forex/recent"
		urlComponents.queryItems = [
			URLQueryItem(name: "codes", value: "FRX.KRW\(dataModel.getCurrentCurrencyCode())"),
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

func request(url: String, method: HTTPMethod, dataModel: DataModel, param: [String: Any]? = nil, completionHandler: @escaping (Result<Int, Error>) -> Void) {
	
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
			
			DispatchQueue.main.async {
				DataManager.shared.filteredResponse = output.first {
					$0.currencyCode == dataModel.getCurrentCurrencyCode()
				}
				if let response = DataManager.shared.filteredResponse {
					let curNmValue = response.currencyCode
					let dealBasR = response.basePrice
					print("currency_name: \(curNmValue)")
					print("deal_basis_rate: \(dealBasR)")
				} else {
					print("No result found for \(dataModel.getCurrentCurrencyCode())")
				}
			}
			completionHandler(.success(DataManager.shared.filteredResponse?.id ?? 0))
			
			print("Data fetched")
			
		} catch {
			print("Error: JSON Data Parsing failed")
			completionHandler(.failure(error))
		}
	}.resume()
	
}

func fetchData(dataModel: DataModel) {
	DispatchQueue.global().async {
		let exchangeURL = ExchangeURL(dataModel: dataModel)
		request(url: exchangeURL.url!.absoluteString, method: .get, dataModel: dataModel) { result in
			switch result {
			case .success(let data):
				print("Data id: \(data)")
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}
}

