//
//  PumpOpsSynchronousTests.swift
//  RileyLink
//
//  Created by Jaim Zuber on 2/21/17.
//  Copyright © 2017 Pete Schwamb. All rights reserved.
//

import XCTest

@testable import RileyLinkKit
import MinimedKit
import RileyLinkBLEKit

class PumpOpsSynchronousTests: XCTestCase {
    
    var sut: PumpOpsSynchronous!
    var pumpState: PumpState!
    var pumpID: String!
    var pumpRegion: PumpRegion!
    var rileyLinkCmdSession: RileyLinkCmdSession!
    var pumpModel: PumpModel!
    
    override func setUp() {
        super.setUp()
        
        pumpID = "17738"
        pumpRegion = .worldWide
        pumpState = PumpState(pumpID: pumpID, pumpRegion: pumpRegion)
        pumpModel = PumpModel.Model523
        pumpState.pumpModel = pumpModel
        pumpState.awakeUntil = Date(timeIntervalSinceNow: 100) // pump is awake
        
        sut = PumpOpsSynchronous(pumpState: pumpState, session: rileyLinkCmdSession)
    }
    
    func testAsdf() {
        let date = Date()
        do {
        try sut.getHistoryEvents(since: date)
            
        } catch {
            XCTFail()
        }
    }
}
