//
//  ListsInDateView.swift
//  exLog
//
//  Created by Jiwoon Lee on 12/9/23.
//
//
//import SwiftUI
//
//struct ListsInDateView: View {
//	var body: some View {
////		ForEach(dateDict.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
//			ForEach(items)) { date in
//				let sumForDate = dateDict[date]?.reduce(0) { $0 + $1.calculatedBalance }
//				if let itemsForDate = dateDict[date] {
//					if shouldShow(.day, items: items, date: date) {
//						DateHeader(dataModel: dataModel, items: itemsForDate, date: date, sumForDate: sumForDate!, onTap: onTap, isFolded: dataModel.foldedItems[date, default: false])
//						if !dataModel.foldedItems[date, default: false] {
//							Text(dateFormat(for: dateDict[date]!.first!.date, format: "aahhmm"))    }
//					}
//				}
//			}
//		}
//	}
//}
//
//#Preview {
//    ListsInDateView()
//}
