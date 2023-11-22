//
//  Keypad.swift
//  spndLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import SwiftUI

struct Keypad: View {
	@Binding var string: String
	@FocusState private var isFocused: Bool
	
    var body: some View {
		VStack {
			KeypadRow(keys: ["1","2","3"])
			KeypadRow(keys: ["4","5","6"])
			KeypadRow(keys: ["7","8","9"])
			KeypadRow(keys: [".","0","<"])
		}.environment(\.keypadButtonAction, self.keyPressed(_:))
			.disabled(isFocused)
			.onAppear() {
				isFocused = true
			}
    }
	
	private func keyPressed(_ key: String) {
		switch key {
		case "." where string.contains("."): break
		case "." where string == "0" : string += key
		case "<": string.removeLast()
			if string.isEmpty { string = "0" }
		case _ where string == "0": string = key
		default: string += key
		}
	}
}

struct KeypadRow: View {
	var keys: [String]
	var body: some View {
		HStack {
			ForEach(keys, id: \.self) { key in
				KeypadButton(key: key)
			}
		}
	}
}

struct KeypadButton: View {
	var key: String
	var body: some View {
		Button(action: { self.action(self.key)}) {
			Color.clear
				.overlay(RoundedRectangle(cornerRadius: 10)
					.stroke(Color.accentColor))
				.overlay(Text(key))
		}
	}
	enum ActionKey: EnvironmentKey {
		static var defaultValue: (String) -> Void {{_ in}}
	}
	
	@Environment(\.keypadButtonAction) var action: (String) -> Void
}

extension EnvironmentValues {
	var keypadButtonAction: (String) -> Void {
		get { self[KeypadButton.ActionKey.self] }
		set { self[KeypadButton.ActionKey.self] = newValue }
	}
}
//
//#Preview {
//	Keypad(string: $string)
//}
//
