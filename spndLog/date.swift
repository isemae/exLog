//
//  date.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/24/23.
//

import Foundation

func getCurrentYYYYMMDD() -> String {
	let currentDate = Date()

	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyyMMdd"

	return dateFormatter.string(from: currentDate)
}

let calendar = Calendar.current
let currentData = Date()
let AM11 = DateComponents(hour: 11, minute: 0)




