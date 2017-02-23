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
    
    let secondFrame = "020d1511180a0033001fb20d55110016011fb20d55113300208a0e5511001601208a0e55117b0520a80e1511180a007b060080101511200e007b07008013151126"
    
    let frameResponses =
    [
        "01030000001822892c15117b050b8a0c1511180a000300030003018a0c1511330028990d551100160128990d551133001fa30d55110016001fa30d55117b051fa3",
        "020d1511180a0033001fb20d55110016011fb20d55113300208a0e5511001601208a0e55117b0520a80e1511180a007b060080101511200e007b07008013151126",
        "0310007b08009e1415112915007b000080001611001000070000014635110000006e351105005e00000100000146013c61000a030005000a000000000000010000",
        "04000000000000000000005e5e00000000000000007b010080011611020c007b020080041611080d007b0300800616110c100033001e800656110016011e800656",
        "05117b031e9e0616110c100033001e9e0856110016011e9e08561133001da80856110016001da80856117b031da80816110c100033001eb20856110016011eb208",
        "06561133001d8a0956110016011d8a09561133001d990956110016001d990956117b031d990916110c100033001da30956110016011da309561133001ead095611",
        "070016001ead0956117b031ead0916110c10007b0400800a1611140b007b0500800c1611180a007b060080101611200e007b0700801316112610007b08009e1416",
        "08112915007b000080001711001000070000014136110000006e361105000000000000000141014164000000000000000000000000000000000000000000000000",
        "090000000000000000000000007b010080011711020c007b020080041711080d007b0300800617110c10007b0400800a1711140b007b0500800c1711180a000000",
        "0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "0c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000258b"
    ]
    
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

    var framePumpMessages: [PumpMessage] {
        
        var messages = [PumpMessage]()
        for frameString in frameResponses {
            let frameData: Data = dataWithHexString(hex: frameString)
            let getHistoryPageMessageBody = GetHistoryPageCarelinkMessageBody(rxData: frameData)!
            let getHistoryPageMessage = PumpMessage(packetType: PacketType.carelink, address: pumpID, messageType: .getHistoryPage, messageBody: getHistoryPageMessageBody)

            messages.append(getHistoryPageMessage)
        }
        return messages
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
        pumpOpsCommunicationStub.responses[.getHistoryPage] = [pumpAckMessage, framePumpMessages[0]]
        
//        framePumpMessages.sl
        pumpOpsCommunicationStub.responses[.pumpAck] = Array(framePumpMessages.suffix(from: 1))
    
        do {

            try sut.getHistoryEvents(since: date)
            
        } catch {
            NSLog("testError:\(error)")
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