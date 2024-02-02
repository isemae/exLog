//
//  extensions.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/23/23.
//

import SwiftUI

extension Color {
	static var primaryColor: Color {
		Color(UIColor { $0.userInterfaceStyle == .dark ? .white : .black })
	}
}
