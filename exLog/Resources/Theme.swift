//
//  Theme.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/24/23.
//

import Foundation
import SwiftUI

struct Theme {
	static func bgColor(_ scheme: ColorScheme) -> Color {
		let light = Color.white
		let dark = Color.black
		
		switch scheme {
		case .light:
			return light
		case .dark:
			return dark
		@unknown default:
			return light
		}
	}
}
