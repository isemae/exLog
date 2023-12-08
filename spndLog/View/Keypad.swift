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
	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void
	var body: some View {
		LazyVStack(spacing: 0) {
		Divider()
			.frame(alignment: .top)
			KeypadRow(keys: ["1","2","3"])
			KeypadRow(keys: ["4","5","6"])
			KeypadRow(keys: ["7","8","9"])
			KeypadRow(keys: [".","0","⌫"])
		}
		.disabled(isFocused)
		.onAppear() { isFocused = true }
		.contentShape(Rectangle())
		.transition(.move(edge: .bottom))
		.gesture(
			DragGesture()
				.onEnded { orientation in
					if abs(orientation.translation.width) > abs(orientation.translation.height) {
						return
					}
					if orientation.translation.height > 10.0 {
						self.onSwipeDown()
					}
					
					if orientation.translation.height < 10.0{
						self.onSwipeUp()
					}
				}
		)
		.environment(\.keypadButtonAction, self.keyPressed(_:))
	}
	
	private func keyPressed(_ key: String) {
		switch key {
		case "." where string.contains("."): break
		case "." where string == "0" : string += key
		case "⌫": string.removeLast()
			if string.isEmpty { string = "0" }
		case _ where string == "0": string = key
		default: string += key
		}
	}
}

struct KeypadRow: View {
	var keys: [String]
	var body: some View {
		HStack(spacing: 5) {
			ForEach(keys, id: \.self) { key in
				KeypadButton(key: key)
					.buttonStyle(.plain)
			}
		}
	}
}

struct KeypadButton: View {
	var key: String
	var onLongPress: () -> Void = {}
	var onLongPressRepeat: () -> Void = {}
	
	@State private var longPressTimer: Timer?
	var body: some View {
		Button(action: {
			UIImpactFeedbackGenerator().impactOccurred(intensity: 0.7)
			self.action(self.key)
		})
		 {
			Color.clear
				.overlay(RoundedRectangle(cornerRadius: 10)
				)
				.foregroundColor(Color(uiColor: UIColor.systemBackground))
				.overlay(Text(key))
				.frame(minHeight: 60)
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



struct KpPreview: View {
	@State var string: String = "0"
	@State var testBool: Bool = true
	var body: some View {
		VStack {
			InputArea(isShowingKeypad: $testBool, string: string, onSwipeUp: {}, onSwipeDown: {})
				.environmentObject(DataModel())
			Keypad(string: $string, onSwipeUp: { string = "0" }, onSwipeDown: {})
		}
		.font(.largeTitle)
	}
}

#Preview {
	KpPreview()
}

