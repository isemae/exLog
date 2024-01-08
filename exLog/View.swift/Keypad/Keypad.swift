//
//  Keypad.swift
//  exLog
//
//  Created by Jiwoon Lee on 11/22/23.
//

import SwiftUI

struct Keypad: View {
	@Binding var string: String
	@Binding var isShowing: Bool
	var onSwipeUp: () -> Void
	var onSwipeDown: () -> Void
	var body: some View {
		LazyVStack(spacing: 0) {
			KeypadRow(keys: ["1","2","3"])
			KeypadRow(keys: ["4","5","6"])
			KeypadRow(keys: ["7","8","9"])
			KeypadRow(keys: [".","0","⌫"])
		}
		.contentShape(Rectangle())
		.frame(maxHeight: isShowing ? UIScreen.main.bounds.height / 3.0 : 0)
		.padding(.horizontal, 20)
		.overlayDivider(alignment: .top)
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
		.ignoresSafeArea(.all)
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
		HStack(spacing: 0) {
			ForEach(keys, id: \.self) { key in
				KeypadButton(key: key)
					.buttonStyle(.plain)
			}
		}
		.padding(.horizontal)
	}
}

struct KeypadButton: View {
	var key: String
	var onLongPress: () -> Void = {}
	var onLongPressRepeat: () -> Void = {}
	
	@State private var longPressTimer: Timer?
	var body: some View {
		Rectangle()
			.foregroundColor(Color.clear)
			.frame(minWidth: 90, minHeight: 55)
			.contentShape(RoundedRectangle(cornerRadius: 15))
			.onTapGesture {
				UIImpactFeedbackGenerator().impactOccurred(intensity: 0.7)
				self.action(self.key)
			}
			.overlay(Text(key))
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
			Keypad(string: $string, isShowing: $testBool, onSwipeUp: { string = "0" }, onSwipeDown: {})
		}
		.font(.largeTitle)
	}
}

#Preview {
	KpPreview()
}

