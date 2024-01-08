//
//  States.swift
//  exLog
//
//  Created by Jiwoon Lee on 1/7/24.
//

import Foundation

// View에서 사용되는 State를 관리
struct States {
	struct Keypad {
		var string = "0"
		var isShowingKeypad = false
		var height = CGFloat.zero
	}
	
	struct Location {
		var currentLocation: String = ""
		var selectedLocation: String = ""
	}
	
	struct Picker {
		var isDatePickerPresented = false
		var selectedDates: [Date] = []
		var addingLocationName: String = ""
	}
}
