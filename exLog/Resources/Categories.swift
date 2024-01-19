//
//  Categories.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/16/24.
//

import Foundation

enum Category: String, Identifiable, Codable, CaseIterable {
	var id: Category { self }
	case `nil`
	case transportation
	case shopping
	case food
	case liquor
	case cafe
	case sweets
	case entertainment
	case souvenir
	case accommodation

	var symbol: String {
		switch self {
		case .nil: return ""
		case .transportation: return "🚋"
		case .shopping: return "🛒"
		case .food: return "🍝"
		case .liquor: return "🥃"
		case .cafe: return "☕"
		case .sweets: return "🍰"
		case .entertainment: return "🥳"
		case .souvenir: return "🛍️"
		case .accommodation: return "🛌🏻"
		}
	}
}
