//
//  GiveTakeTests.swift
//  GiveTakeTests
//
//  Created by Eric Kampman on 4/2/24.
//

import XCTest

class BorrowableItem: Available {
	var available: Availability
	let id: String
	let borrowDate: Date
	
	init(available: Availability, id: String, borrowDate: Date = Date.distantPast) {
		self.available = available
		self.id = id
		self.borrowDate = borrowDate
	}
}

final class GiveTakeTests: XCTestCase {
	
	let giverBB = "Bill Bruford"


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGTActorAppendDelete() throws {
		let gtActor = GTActor<String,BorrowableItem>(id: giverBB)
		
		gtActor.appendItem(BorrowableItem(available: .available, id: "Cymbal"))
		gtActor.appendItem(BorrowableItem(available: .available, id: "Tom Tom"))
		
		XCTAssert(gtActor.count == 2)
		
		gtActor.removeItems { item in
			item.id == "Cymbal"
		}
		XCTAssert(gtActor.count == 1)
    }
	
	func testGTManagerAddGetGTActor() throws {
		let gtManager = GTManager<String,BorrowableItem>()
		
		gtManager.addGTActor(giverBB, type: .give)

		let count = gtManager.gtActors[GTRecordType.give.rawValue].count
		XCTAssert(count == 1)
		
		let gtActor = gtManager.getGTActor(giverBB, type: .give)
		
		XCTAssert(gtActor != nil && gtActor!.id == giverBB, "getGTActor failed")
	}
	
	func testAddGTActorAndItems() throws {
		let gtManager = GTManager<String,BorrowableItem>()

		gtManager.addGTActor(giverBB, type: .give)
		
		let count = gtManager.getGTActorCount(type: .give)
		XCTAssert(count == 1)
		let cymbal = BorrowableItem(available: .available, id: "Cymbal")
		let tomTom = BorrowableItem(available: .available, id: "Tom Tom")

		gtManager.appendGTActorItem(giverBB, type: .give, item: cymbal)
		gtManager.appendGTActorItem(giverBB, type: .give, item: tomTom)
		
		let items = gtManager.getGTActorItems(giverBB, type: .give)
		
		XCTAssert(items != nil && items!.count == 2)
	}
	
	func testRemoveItems() throws {
		let gtManager = GTManager<String,BorrowableItem>()

		gtManager.addGTActor(giverBB, type: .give)
		
		let count = gtManager.getGTActorCount(type: .give)
		XCTAssert(count == 1)
		let cymbal = BorrowableItem(available: .available, id: "Cymbal")
		let tomTom = BorrowableItem(available: .available, id: "Tom Tom")
		let tomTomTom = BorrowableItem(available: .available, id: "Tom Tom Tom")

		gtManager.appendGTActorItem(giverBB, type: .give, item: cymbal)
		gtManager.appendGTActorItem(giverBB, type: .give, item: tomTom)
		gtManager.appendGTActorItem(giverBB, type: .give, item: tomTomTom)

		var items = gtManager.getGTActorItems(giverBB, type: .give)
		
		XCTAssert(items != nil && items!.count == 3)
		
		// new code here:
		
		gtManager.deleteMatchingItems(giverBB, type: .give) { item in
			let item = item as BorrowableItem
			return item.id.contains("Tom")
		}
		
		items = gtManager.getGTActorItems(giverBB, type: .give)

		XCTAssert(items != nil && items!.count == 1)
	}
	

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
