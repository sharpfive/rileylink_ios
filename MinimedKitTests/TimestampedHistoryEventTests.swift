//
//  TimestampedHistoryEventTests.swift
//  RileyLink
//
//  Created by Jaim Zuber on 2/24/17.
//  Copyright © 2017 Pete Schwamb. All rights reserved.
//

import XCTest
@testable import MinimedKit

class TimestampedHistoryEventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEventIsntMutable() {
        let data = Data(bytes: Array<UInt8>([7,6,5,4,3,2,1,0]))
        let event = BatteryPumpEvent(availableData: data, pumpModel: PumpModel.Model523)!
        
        let sut = TimestampedHistoryEvent(pumpEvent:event, date:Date())
        
        XCTAssertFalse(sut.isMutable())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
