import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query var items: [Item]
	@Query var groups: [Group]
	private var itemsArray: [Item] = []
	
	var body: some View {
		VStack {
			List {
				ForEach(groupeditems.indices, id: \.self) { index in
					let group = groupeditems[index]
					Section(header: Text(formattedHeaderDate(group.first!.addedTime))) {
						ForEach(group.reversed()) { item in
							VStack(alignment: .leading) {
								Text(": \(item.text)")
								Text("추가된 시간: \(formattedDate(item.addedTime))")
									.font(.caption)
									.foregroundColor(.gray)
							}
						}
					}
				}
			}
			
			Button(action: {
				// 버튼을 누를 때 현재 시간의 아이템을 추가
				addItem()
				// 새로운 아이템을 추가한 후에 그룹화 로직 적용
				// Save the context to persist the changes
				try? modelContext.save()
			}) {
				Text("메시지 추가")
					.padding()
					.foregroundColor(.white)
					.background(Color.blue)
					.cornerRadius(10)
			}
			.padding()
		}
	}
	
	private func addItem() {
		let currentTime = Date()
		let newItem = Item(text: "none", time: currentTime, addedTime: currentTime)
		self.modelContext.insert(newItem)
		try? modelContext.save() // 저장
	}
	
	private var groupedItems: [[Item]] {
		return Dictionary(grouping: itemsArray) { item in // itemsArray로 변경
			formattedHeaderDate(item.time)
		}
		.values
		.sorted(by: { $0.first!.time > $1.first!.time })
	}
	
	// Date를 특정 형식의 문자열로 변환하는 함수
	private func formattedDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return dateFormatter.string(from: date)
	}

	// 날짜를 헤더로 표시하기 위한 함수
	private func formattedHeaderDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		return dateFormatter.string(from: date)
	}

	// 새로운 아이템을 그룹화하는 함수
	private func groupItems(items: inout [Item]) {
		guard items.count > 1 else { return }

		let lastIndex = items.count - 1
		var currentItem = items[lastIndex]

		for (index, item) in items.enumerated().reversed() {
			if index > 0 {
				let previousItem = items[index - 1]
				let calendar = Calendar.current
				let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: previousItem.time, to: currentItem.time)
				
				// 이전 아이템과 현재 아이템이 같은 분 내에 추가된 경우 그룹화
				if let minutes = components.minute, minutes == 0 {
					currentItem.group = Group(pos: (previousItem.group?.pos ?? -1) + 1)
					break
				}
			}
		}
	}

	// 아이템을 분 단위로 그룹화하여 반환하는 계산된 속성
	private var groupeditems: [[Item]] {
		Dictionary(grouping: items) { item in
			formattedHeaderDate(item.addedTime)
		}
		.values
		.sorted(by: { $0.first!.addedTime > $1.first!.addedTime })
	}
}


#Preview {
	ContentView()
}
