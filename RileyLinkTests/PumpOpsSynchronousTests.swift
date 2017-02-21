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
    var pumpOpsCommunicationStub: PumpOpsCommunicationStub!
    
    override func setUp() {
        super.setUp()
        
        pumpID = "23"
        pumpRegion = .worldWide
        pumpState = PumpState(pumpID: pumpID, pumpRegion: pumpRegion)
        pumpState.awakeUntil = Date(timeIntervalSinceNow: 100) // pump is awake
        
        pumpModel = PumpModel.Model523
        pumpState.pumpModel = pumpModel
        
        rileyLinkCmdSession = RileyLinkCmdSession()
        pumpOpsCommunicationStub = PumpOpsCommunicationStub(session: rileyLinkCmdSession)
        
        
        sut = PumpOpsSynchronous(pumpState: pumpState, session: rileyLinkCmdSession)
        sut.communication = pumpOpsCommunicationStub
    }
    
    func testAsdf() {
        let date = Date()
        let pumpAckMessageBody = PumpAckMessageBody(rxData: Data())!
        let pumpAckMessage = PumpMessage(packetType: .carelink, address: "1234", messageType: .pumpAck, messageBody: pumpAckMessageBody)
        do {
            
            let messageBody = GetHistoryPageCarelinkMessageBody(pageNum: 3)
            let getHistoryPageMessage = PumpMessage(packetType: PacketType.carelink, address: "1234", messageType: .pumpAck, messageBody: messageBody)
            
            
            pumpOpsCommunicationStub.responses[.getHistoryPage] = [pumpAckMessage, getHistoryPageMessage]
            //
        try sut.getHistoryEvents(since: date)
            
        } catch {
            XCTFail()
        }
    }
    
    class PumpOpsCommunicationStub : PumpOpsCommunication {
        var responses: [MessageType : [PumpMessage]] = [MessageType : [PumpMessage]]()
        
        var responsesHaveOccured: [MessageType: Int] = [MessageType : Int]()
        override func sendAndListen(_ msg: PumpMessage, timeoutMS: UInt16, repeatCount: UInt8 = 0, msBetweenPackets: UInt8 = 0, retryCount: UInt8 = 3) throws -> PumpMessage {
            
            if let response = responses[msg.messageType] {
                let numberOfResponses
                
                if let 
                return response
            }
            return PumpMessage(rxData: Data())!
        }
    }
}
