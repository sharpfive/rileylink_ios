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
        
        pumpID = "350535"
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
    
    
    let firstFrame = "01030000001822892c15117b050b8a0c1511180a000300030003018a0c1511330028990d551100160128990d551133001fa30d55110016001fa30d55117b051fa3"
    
    let secondFrame = "820d1511180a0033001fb20d55110016011fb20d55113300208a0e5511001601208a0e55117b0520a80e1511180a007b060080101511200e007b07008013151126"
    
//    let thirdFrame = "0310007b08009e1415112915007b000080001611001000070000014635110000006e351105005e00000100000146013c61000a030005000a000000000000010000"
    
//    func hexadecimal(string: String) -> Data? {
//        
//        var data = Data(capacity: string.characters.count / 2)
//        
//        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
//        regex.enumerateMatches(in: string, options: [], range: NSMakeRange(0, string.characters.count)) { match, flags, stop in
//            
//            let swiftRange:Range = Range(0, string.characters.count)
//            let byteString = string.substring(with: match!.range)
//            var num = UInt8(byteString, radix: 16)!
//            data.append(&num, count: 1)
//        }
//        
//        guard data.count > 0 else {
//            return nil
//        }
//        
//        return data
//    }
    
    func dataWithHexString(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.characters.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }


    func testAsdfffff() {
//        asdfasdfasdf
        let address = pumpID!
        let firstFrameData: Data = dataWithHexString(hex: firstFrame) //hexidecimal(firstFrame)
        let date = Date()
        let pumpAckMessageBody = PumpAckMessageBody(rxData: Data())!
        let pumpAckMessage = PumpMessage(packetType: .carelink, address: address, messageType: .pumpAck, messageBody: pumpAckMessageBody)
        
        let secondFrameData: Data = dataWithHexString(hex: secondFrame)
        let secondFramePageMessageBody = GetHistoryPageCarelinkMessageBody(rxData: secondFrameData)!
        let secondGetHistoryPageMessage = PumpMessage(packetType: PacketType.carelink, address: address, messageType: .getHistoryPage, messageBody: secondFramePageMessageBody)
        
        
        
        
//        let messageData = Data(by)
        let getHistoryPageMessageBody = GetHistoryPageCarelinkMessageBody(rxData: firstFrameData)!
        let getHistoryPageMessage = PumpMessage(packetType: PacketType.carelink, address: address, messageType: .getHistoryPage, messageBody: getHistoryPageMessageBody)
        
        let pumpAckPageMessage = sut.makePumpMessage(to: .pumpAck)
        
        // pump will be called twice, normal operation will receive a pumpAck and getHistoryPageMessage
        pumpOpsCommunicationStub.responses[.getHistoryPage] = [pumpAckMessage, getHistoryPageMessage]
        pumpOpsCommunicationStub.responses[.pumpAck] = [secondGetHistoryPageMessage]
    
        do {

            try sut.getHistoryEvents(since: date)
            
        } catch {
            XCTFail()
        }
    }
    
    class PumpOpsCommunicationStub : PumpOpsCommunication {
        
        var responses: [MessageType : [PumpMessage]] = [MessageType : [PumpMessage]]()
        
        // internal tracking of how many times a response type has been received
        private var responsesHaveOccured: [MessageType: Int] = [MessageType : Int]()
        
        override func sendAndListen(_ msg: PumpMessage, timeoutMS: UInt16, repeatCount: UInt8 = 0, msBetweenPackets: UInt8 = 0, retryCount: UInt8 = 3) throws -> PumpMessage {
            
            if let responseArray = responses[msg.messageType] {
                let numberOfResponsesReceived: Int
                
                if let someValue = responsesHaveOccured[msg.messageType] {
                    numberOfResponsesReceived = someValue
                } else {
                    numberOfResponsesReceived = 0
                }
                
                let nextNumberOfResponsesReceived = numberOfResponsesReceived+1
                responsesHaveOccured[msg.messageType] = nextNumberOfResponsesReceived
                
                if numberOfResponsesReceived >= responseArray.count {
                    XCTFail()
                }
            
                return responseArray[numberOfResponsesReceived]
            }
            return PumpMessage(rxData: Data())!
        }
    }
}
