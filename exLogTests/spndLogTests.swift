//
//  exLogTests.swift
//  exLogTests
//
//  Created by Jiwoon Lee on 11/22/23.
//

import XCTest
import SwiftData
import Foundation

@testable import exLog
final class exLogTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
	
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
	
	
	var testItems: [Item] = []
	func generateTestItems() {
		let currentDate = Date()
		for i in 0..<20 {
			let newItem = Item(date: currentDate.addingTimeInterval(TimeInterval(i * 3600)), balance: "\(i * 10)", currency: .AUD)
			testItems.append(newItem)
		}
	}
	
	
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	
//	func testDictGroupingPerformance() throws {
//		let testItems: () = generateTestItems()
//		measure {
//			let testDict = Dictionary(grouping: testItems.flatMap { $0 }) { item in
//				Calendar.current.startOfDay(for: item.date)
//				
//				XCTAssertNotNil(testDict)
//			}
//		}
//	}
	
	func testManualGroupingPerformance() {
			measure {
				generateTestItems()
				var groupedDictionary: [Date: [Item]] = [:]

				for item in testItems {
					let key = Calendar.current.startOfDay(for: item.date)

					if var itemsForDate = groupedDictionary[key] {
						itemsForDate.append(item)
						groupedDictionary[key] = itemsForDate
					} else {
						groupedDictionary[key] = [item]
					}
				}
				let result = processData(items: testItems)
				XCTAssertNotNil(result)
			}
		}
	
	func processData(items: [Item]) -> String {
			return "Processed \(items.count) items"
		}
}
