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
    
    let fetchPageZeroFrames = [
        "01030000001822892c15117b050b8a0c1511180a000300030003018a0c1511330028990d551100160128990d551133001fa30d55110016001fa30d55117b051fa3",
        "020d1511180a0033001fb20d55110016011fb20d55113300208a0e5511001601208a0e55117b0520a80e1511180a007b060080101511200e007b07008013151126",
        "0310007b08009e1415112915007b000080001611001000070000014635110000006e351105005e00000100000146013c61000a030005000a000000000000010000",
        "04000000000000000000005e5e00000000000000007b010080011611020c007b020080041611080d007b0300800616110c100033001e800656110016011e800656",
        "05117b031e9e0616110c100033001e9e0856110016011e9e08561133001da80856110016001da80856117b031da80816110c100033001eb20856110016011eb208",
        "06561133001d8a0956110016011d8a09561133001d990956110016001d990956117b031d990916110c100033001da30956110016011da309561133001ead095611",
        "070016001ead0956117b031ead0916110c10007b0400800a1611140b007b0500800c1611180a007b060080101611200e007b0700801316112610007b08009e1416",
        "08112915007b000080001711001000070000014136110000006e361105000000000000000141014164000000000000000000000000000000000000000000000000",
        "090000000000000000000000007b010080011711020c007b020080041711080d007b0300800617110c10007b0400800a1711140b007b0500800c1711180a007b06",
        "0a0080101711200e007b0700801317112610007b08009e1417112915007b000080001811001000070000015737110000006e371105000000000000000157015764",
        "0b0000000000000000000000000000000000000000000000000000000000000000000000007b010080011811020c007b020080041811080d007b0300800618110c",
        "0c100033001d9e0858110016011d9e08581133001dad0858110016001dad0858117b031dad0818110c10007b0400800a1811140b00000000000000000000000000",
        "0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cbf5"
    ]
    
    let fetchPageOneFrames = [
        "016e3011050000000000000005c601821a04444a000000000000000004440000000b000000000000000000000000000000000000007b010080011111020c007b02",
        "020080041111080d007b0300800611110c1000010050005000000025a12951117b0400800a1111140b007b0500800c1111180a000100780078000a0032bb2b5111",
        "037b060080101111200e007b0700801311112610007b08009e1411112915007b000080001211001000070000021f31110000006e31110500000000000000021f01",
        "04573f00c825000000000000000000c800000002000000000000000000000000000000000000007b010080011211020c007b020080041211080d007b0300800612",
        "05110c10007b0400800a1211140b007b0500800c1211180a007b060080101211200e007b0700801312112610007b08009e1412112915007b000080001311001000",
        "06070000015732110000006e3211050000000000000001570157640000000000000000000000000000000000000000000000000000000000000000000000007b01",
        "070080011311020c007b020080041311080d007b0300800613110c10007b0400800a1311140b007b0500800c1311180a007b060080101311200e007b0700801313",
        "08112610007b08009e1413112915007b000080001411001000070000015733110000006e3311050000000000000001570157640000000000000000000000000000",
        "09000000000000000000000000000000000000000000007b010080011411020c007b020080041411080d00346417b70514117b0300800614110c10007b0400800a",
        "0a1411140b007b0500800c1411180a007b060080101411200e0033002a931254110016012a931254117b062ab1121411200e007b0700801314112610007b08009e",
        "0b1414112915003432198b1514117b000080001511001000070000015034110000006e341105000000000000000150015064000000000000000000000000000000",
        "0c0000000000000000000000000000000000000000007b010080011511020c007b020080041511080d007b0300800615110c1000330021a206551100160121a206",
        "0d5511330026a706551100160026a70655117b0326a70615110c1000330021bb06551100160121bb0655113300248407551100160024840755117b032584071511",
        "0e0c1000330021a708551100160121a7085511330021b108551100160021b10855117b0321b10815110c1000330021bb08551100160121bb085511330020930955",
        "0f110016012093095511330022a709551100160122a7095511330021ac09551100160021ac0955117b0322ac0915110c10007b0400800a1511140b000a5e06a32b",
        "9015115b5e0ea30b7511055000b4555a00000a000000000a8c01000a000a0000000ea32b75117b0500800c1511180a00210030880c151100000000000000004e9d"
    ]
    
    let fetchPageTwoFrames = [
        "016e2d110500000000000000016c016c640000000000000000000000000000000000000000000000000000000000000000000000007b010080010e11020c007b02",
        "020080040e11080d007b030080060e110c10007b0400800a0e11140b0033531c840a4e110016011c840a4e1133001d890a4e110016001d890a4e117b041e890a0e",
        "0311140b00334a1d930a4e110016011d930a4e1133001c980a4e110016001c980a4e117b041d980a0e11140b007b0500800c0e11180a007b060080100e11200e00",
        "047b070080130e112610007b08009e140e112915007b000080000f1100100007000001632e110000006e2e11050000000000000001630163640000000000000000",
        "05000000000000000000000000000000000000000000000000000000007b010080010f11020c007b020080040f11080d007b030080060f110c10007b0400800a0f",
        "0611140b007b0500800c0f11180a00330017ae0c4f1100160117ae0c4f117b0518900d0f11180a007b060080100f11200e007b070080130f112610007b08009e14",
        "070f112915007b00008000101100100007000001522f110000006e2f11050000000000000001520152640000000000000000000000000000000000000000000000",
        "08000000000000000000000000007b010080011011020c007b020080041011080d007b0300800610110c100033473bb10950110016013bb109501133003bb60950",
        "09110016003bb60950117b033bb60910110c10007b0400800a1011140b000100500050000000228a2a501101005000500050000c8d2a5011330000940a50110016",
        "0a0100940a501133003b990a50110016013b990a501101005800580097000ea12a50117b043bb70a1011140b000100500050007d000ea92b5011330020ae0b5011",
        "0b00160120ae0b50113338218d0c5011001601218d0c5011335934a60c501100160134a60c50117b0534880d1011180a00010050005000250007932d50110100d0",
        "0c00d00071000e982d501101010001000130000ca22d5011330007a90d501100160107a90d501101005000500222000da92d5011330003b90d501100160103b90d",
        "0d501133002c800e50110016012c800e501133003a8e0e50110016013a8e0e501133003a930e50110016003a930e50117b053a930e1011180a00330039990e5011",
        "0e00160139990e50113300169e0e5011001600169e0e50117b05169e0e1011180a00330000b20e501100160100b20e5011330001b70e501100160001b70e50117b",
        "0f0501b70e1011180a0001002800280085000aa12f50110100500050009d001aa62f5011010014001400ce0038b12f50117b060080101011200e007b0700801310",
        "90112610007b08009e1410112915007b00008000111100100007000005c63011000000000000000000000000000000000000000000000000000000000000008e53"
    ]
    
    let fetchPageThreeFrames = [
        "017b0700801309112610007b08009e1409112915007b000080000a11001000070000029429110000006e291105000000000000000294015634013e300000000000",
        "02000000013e00000003000000000000000000000000000000000000007b010080010a11020c007b020080040a11080d007b030080060a110c10007b0400800a0a",
        "0311140b000100c800c80000003abb294a11830106980a0a11010012001200ba00309a2a0a113310229c0a0a11001603229c0a0a117b0423ba0b0a11140b007b05",
        "0400800c0a11180a007b060080100a11200e007b070080130a112610007b08009e140a112915007b000080000b1100100007000002392a110000006e2a11050000",
        "0500000000000239015f3e00da26000000000000000000da00000002000000000000000000000000000000000000007b010080010b11020c007b020080040b1108",
        "060d007b030080060b110c10007b0400800a0b11140b007b0500800c0b11180a00333b348e0d4b11001601348e0d4b1133001c930d4b110016001c930d4b117b05",
        "071c930d0b11180a007b060080100b11200e007b070080130b112610007b08009e140b112915007b000080000c11001000070000015a2b110000006e2b11050000",
        "080000000000015a015a640000000000000000000000000000000000000000000000000000000000000000000000007b010080010c11020c007b020080040c1108",
        "090d007b030080060c110c10007b0400800a0c11140b00335b1dac0a4c110016011dac0a4c1133001db10a4c110016001db10a4c117b041db10a0c11140b003349",
        "0a1db60a4c110016011db60a4c1133001ebb0a4c110016001ebb0a4c117b041ebb0a0c11140b007b0500800c0c11180a007b060080100c11200e007b070080130c",
        "0b112610007b08009e140c112915007b000080000d1100100007000001632c110000006e2c11050000000000000001630163640000000000000000000000000000",
        "0c000000000000000000000000000000000000000000007b010080010d11020c007b020080040d11080d007b030080060d110c100033551d9d084d110016011d9d",
        "0d084d1133001ca2084d110016001ca2084d117b031da2080d110c100033531cb6084d110016011cb6084d1133001dbb084d110016001dbb084d117b031dbb080d",
        "0e110c100033421d89094d110016011d89094d1133001c8e094d110016001c8e094d117b031c8e090d110c1000334b1d93094d110016011d93094d1133001e9809",
        "0f4d110016001e98094d117b031e98090d110c10007b0400800a0d11140b007b0500800c0d11180a007b060080100d11200e007b070080130d112610007b08009e",
        "90140d112915007b000080000e11001000070000016c2d110000000000000000000000000000000000000000000000000000000000000000000000000000000a4e"
    ]
    
    let fetchPageFourFrames = [
        "010615036800406001070636036f0040600107062f1dfc004020c107062f0e77004020c107062f0e88004020c107062f0e99004020c107062f0eaa004020c10706",
        "022f0ebb004020c107062f0ee1004020c107062f0ef4004020c107062f0f05004020c10706110f12004020c10706150411004040a1070c151f4300010764000f40",
        "0300010764001e400001076400024100010717002241000107180000a20c0211070000000001870000006e01870500000000000000000000000000000000000000",
        "04000000000000000000000000000000000000000000000000000000000021001a9e0d02112100219f0d0211210031a10d02111a0024b30d02111a0138b30d0211",
        "05210028ba0d02112100018a0f0211064202742a8a4f42110c420a8b0f021121000e8b0f02110300000000338b2f02117b05088c0f0211180a007b051b8c0f0211",
        "06180a000300030003118c0f021181010e8e0f021100a27b87767d020e8e0f021100a2ce8aa000a27b877600000000000000000000000000000000000000007b06",
        "070080100211200e001a002a80100211060303682a807002110c03384000010764003b400001076400214100010717000942000107180000a50703110700000008",
        "08221100220c6e2211050000000000000000080008640000000000000000000000000000000000200000000000000000000000000080000000607b0301a5070311",
        "090c10000a63258d2903115b632a8d0963110050006e555a00000000000000008c7b0400800a0311140b007b0500800c0311180a007b060080100311200e001a00",
        "0a38b21003110603036838b27003110c03174000010764011c4000010717001141000107180000ad0b0811070000007023110125076e2311150063000001000000",
        "0b700070640000000000000000000000000000000000500000000000000000636300000080000000387b0400ad0b0811140b007d0208b70b081100a2ce8aa000a2",
        "0c7b877600000000000000000000000000000000000000007b0500800c0811180a007b060080100811200e007d0224b710081100a2ce8aa000a27b877600000000",
        "0d000000000000000000000000000000007b0700801308112610007b08009e1408112915007b00008000091100100007000000b52811002d0b6e28110500000000",
        "0e00000000b500b5640000000000000000000000000000000000d00000000000000000000000000080000000587b010080010911020c007b020080040911080d00",
        "0f7b0300800609110c10007b0400800a0911140b007b0500800c0911180a0001011801180000000a812f4911010006000601160030882f091133001d890f491100",
        "9016011d890f491133002d8e0f49110016002d8e0f49117b052d8e0f0911180a007b060080100911200e000100200020002a0018963109110000000000000095fb"
    ]
    
    func buildPumpMessagesFromFrameArray(_ frameArray: [String]) -> [PumpMessage] {
        return frameArray.map { self.buildPumpMessageFromFrame($0) }
    }
    
    func buildPumpMessageFromFrame(_ frame: String) -> PumpMessage {
        let frameData: Data = self.dataFromHexString(frame)
        let getHistoryPageMessageBody = GetHistoryPageCarelinkMessageBody(rxData: frameData)!
        let getHistoryPageMessage = PumpMessage(packetType: PacketType.carelink, address: self.pumpID, messageType: .getHistoryPage, messageBody: getHistoryPageMessageBody)
        return getHistoryPageMessage
    }
    
    let dateComponents2007 = DateComponents(calendar: Calendar.current, year: 2007, month: 1, day: 1)
    let dateComponents2017 = DateComponents(calendar: Calendar.current, year: 2017, month: 1, day: 1)
    
    lazy var datePast2007: Date = {
        return self.dateComponents2017.date!.addingTimeInterval(60*60)
    }()
    
    lazy var datePast2017: Date = {
        return self.dateComponents2017.date!.addingTimeInterval(60*60)
    }()
    
    lazy var bolusEvent2010: BolusNormalPumpEvent = {
        //2010-08-01 05:00:16 +000
        return BolusNormalPumpEvent(
            availableData: Data(hexadecimalString: "01009000900058008a344b1010")!,
            pumpModel: self.pumpModel
            )!
    }()
    
    lazy var bolusEvent2009: BolusNormalPumpEvent = {
        //2009-07-31 09:00:00 +0000
        return BolusNormalPumpEvent(
            availableData: Data(hexadecimalString: "010080008000240009a24a1510")!,
            pumpModel: self.pumpModel
            )!
    }()
    
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
    
    func testErrorIsntThrown() {
        pumpOpsCommunicationStub.responses = buildResponsesDictionary()
        
        assertNoThrow(try _ = sut.getHistoryEvents(since: Date()))
    }
    
    func testUnexpectedResponseThrowsError() {
        var responseDictionary = buildResponsesDictionary()
        var pumpAckArray = responseDictionary[.getHistoryPage]!
        pumpAckArray.insert(sut.makePumpMessage(to: .buttonPress), at: 0)
        responseDictionary[.getHistoryPage]! = pumpAckArray
        
        pumpOpsCommunicationStub.responses = responseDictionary
        
        // Didn't receive a .pumpAck short reponse so throw an error
        assertThrows(try _ = sut.getHistoryEvents(since: Date()))
    }
    
    func testUnexpectedPumpAckResponseThrowsError() {
        var responseDictionary = buildResponsesDictionary()
        var pumpAckArray = responseDictionary[.getHistoryPage]!
        pumpAckArray.insert(sut.makePumpMessage(to: .buttonPress), at: 1)
        responseDictionary[.getHistoryPage]! = pumpAckArray
        
        pumpOpsCommunicationStub.responses = responseDictionary
        
        // Didn't receive a .getHistoryPage as 2nd response so throw an error
        assertThrows(try _ = sut.getHistoryEvents(since: Date()))
    }

    func testAllEventsReturned() {
        pumpOpsCommunicationStub.responses = buildResponsesDictionary()
        
        let date = Date(timeIntervalSince1970: 0)
        do {
            let eventsTuple = try sut.getHistoryEvents(since: date)
            let historyEvent = eventsTuple.0
            
            // Ends because of out of order
            XCTAssertEqual(historyEvent.count, 62)
        } catch {
            XCTFail()
        }
    }
    
    func testEventsReturnedAfterTime() {
        pumpOpsCommunicationStub.responses = buildResponsesDictionary()
        
        //02/11/2017 @ 12:00am (UTC)
        let date = Date(timeIntervalSince1970: 1486771200)
        do {
            let eventsTuple = try sut.getHistoryEvents(since: date)
            let historyEvent = eventsTuple.0
            
            // Ends because of out of order
            XCTAssertEqual(historyEvent.count, 62)
        } catch {
            XCTFail()
        }
    }
    
    func testUnexpectedResponse() {
        pumpOpsCommunicationStub.responses = buildResponsesDictionary()
        //pumpOpsCommunicationStub.responses[
    }
    
    func testBatteryEventDoesntCancel() {
        let pumpEvents: [PumpEvent] = [createBatteryEvent()]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: pumpEvents, startDate: Date.distantPast, checkDate: Date.distantPast, pumpModel: pumpModel)
        
        XCTAssertFalse(result.cancelled)
    }
    
    func testBatteryEventIsCreated() {
        let pumpEvents: [PumpEvent] = [createBatteryEvent()]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: pumpEvents, startDate: Date.distantPast, checkDate: Date.distantPast, pumpModel: pumpModel)
        
        XCTAssertEqual(result.events.count, 1)
    }
    
    func testMultipleBatteryEvent() {
        
        let batteryEvent2007 = createBatteryEvent(withDateComponent: dateComponents2017)
        let batteryEvent2017 = createBatteryEvent(withDateComponent: dateComponents2007)
        let pumpEvents: [PumpEvent] = [batteryEvent2007, batteryEvent2017]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: pumpEvents, startDate: Date.distantPast, checkDate: Date(), pumpModel: pumpModel)
        
        XCTAssertEqual(result.events.count, 2)
    }

    func testOldBatteryEventIsFiltered() {
        
        let datePast2007 = dateComponents2007.date!.addingTimeInterval(60*60)
        let datePassed2017 = dateComponents2017.date!.addingTimeInterval(60*60)
        
        let batteryEvent2007 = createBatteryEvent(withDateComponent: dateComponents2017)
        let batteryEvent2017 = createBatteryEvent(withDateComponent: dateComponents2007)
        let pumpEvents: [PumpEvent] = [batteryEvent2007, batteryEvent2017]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: pumpEvents, startDate: datePast2007, checkDate: datePassed2017, pumpModel: pumpModel)
        
        XCTAssertEqual(result.events.count, 1)
    }
    
    func testOutOfOrderEventReturnsCancel() {
        let datePassed2017 = dateComponents2017.date!.addingTimeInterval(60*60)
        
        let batteryEvent2007 = createBatteryEvent(withDateComponent: dateComponents2017)
        let batteryEvent2017 = createBatteryEvent(withDateComponent: dateComponents2007)
        let outOfOrderPumpEvents: [PumpEvent] = [batteryEvent2017, batteryEvent2007]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: outOfOrderPumpEvents, startDate: Date.distantPast, checkDate: datePassed2017, pumpModel: pumpModel)
        
        XCTAssertTrue(result.cancelled)
    }
    
    func testOutOfOrderEventDoesntIncludeOutOfOrderEvent() {
        let datePast2017 = dateComponents2017.date!.addingTimeInterval(60*60)
        
        let batteryEvent2007 = createBatteryEvent(withDateComponent: dateComponents2017)
        let batteryEvent2017 = createBatteryEvent(withDateComponent: dateComponents2007)
        let outOfOrderPumpEvents: [PumpEvent] = [batteryEvent2017, batteryEvent2007]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: outOfOrderPumpEvents, startDate: Date.distantPast, checkDate: datePast2017, pumpModel: pumpModel)
        
        XCTAssertEqual(result.events.count, 1)
    }
    
    func testMultipleBolusEvents() {
        let pumpModel = PumpModel.Model522
        
        let firstBolusEvent = BolusNormalPumpEvent(
            availableData: Data(hexadecimalString: "01009000900058008a344b1010")!,
            pumpModel: pumpModel
            )!
        
        // set up multiple non-mutable Bolus event
        let bolusEvent2009 = BolusNormalPumpEvent(
            availableData: Data(hexadecimalString: "010080008000240009a24a1510")!,
            pumpModel: pumpModel
            )!
        
        let events = [firstBolusEvent, bolusEvent2009]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: events, startDate: Date.distantPast, checkDate: datePast2017, pumpModel: pumpModel)
        
        XCTAssertEqual(result.events.count, 2)
    }
    
    func testMultipleBolusEventsContainsFirstBolus() {
        pumpModel = PumpModel.Model522
        
        let events = [bolusEvent2010, bolusEvent2009]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: events, startDate: Date.distantPast, checkDate: datePast2017, pumpModel: pumpModel)
        
        assertArray(result.events, containsPumpEvent: bolusEvent2010)
    }
    
    func testMultipleBolusEventsContainsSecondBolus() {
        pumpModel = PumpModel.Model522
        
        let events = [bolusEvent2010, bolusEvent2009]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: events, startDate: Date.distantPast, checkDate: datePast2017, pumpModel: pumpModel)
        
        assertArray(result.events, containsPumpEvent: bolusEvent2009)
    }
    
    //aiai VERIFY EVENTS ARE BEING RETREIVED the same way
    //aiai Finalize tests for IoB functionality
    
    
    func testMutableBolusEventFor522() {
        // device that can have out of order events
        pumpModel = PumpModel.Model522
        
        // 2009-07-31 09:00:00 +0000
        // 120 minute duration
        let regularBolus = BolusNormalPumpEvent(availableData: Data(hexadecimalString: "010080048000240009a24a1510")!, pumpModel: pumpModel)!
        
        let hourAfterRegularBolusDate = regularBolus.timestamp.date!.addingTimeInterval(TimeInterval(minutes: 60))
        let events:[PumpEvent] = [regularBolus]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: events, startDate: Date.distantPast, checkDate: hourAfterRegularBolusDate, pumpModel: pumpModel)
        
        // It should not be counted for IoB (how to measure)
        XCTAssertFalse(array(result.events, containsPumpEvent: regularBolus))
    }
    
    func testNonMutableBolusEventFor522() {
        // device that can have out of order events
        pumpModel = PumpModel.Model523
        
        // 2009-07-31 09:00:00 +0000
        // 120 minute duration
        let regularBolus = BolusNormalPumpEvent(availableData: Data(hexadecimalString: "010080048000240009a24a1510")!, pumpModel: pumpModel)!
        
        let hourAfterRegularBolusDate = regularBolus.timestamp.date!.addingTimeInterval(TimeInterval(minutes: 60))
        let events:[PumpEvent] = [regularBolus]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: events, startDate: Date.distantPast, checkDate: hourAfterRegularBolusDate, pumpModel: pumpModel)
        
        // It should be counted for IoB (how to measure)
        XCTAssertTrue(array(result.events, containsPumpEvent: regularBolus))
    }

    func testMutableEventFor522() {
        // device that can have out of order events
        pumpModel = PumpModel.Model522
        
        let data = Data(hexadecimalString:"338c4055145d1000")!
        
        // Create event like Temp Bolus (priming pump
        let tempEventBolus = TempBasalPumpEvent(availableData: data, pumpModel: pumpModel)!
        
        let events:[PumpEvent] = [bolusEvent2010, bolusEvent2009, tempEventBolus]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: events, startDate: Date.distantPast, checkDate: datePast2017, pumpModel: pumpModel)
        
        // It should not be counted for IoB (how to measure)
        XCTAssertFalse(array(result.events, containsPumpEvent: tempEventBolus))
    }
    
    func testMutableEventIsCounted() {
        // device that can have out of order events
        pumpModel = PumpModel.Model522
        
        //2016-05-30 01:21:00 +0000
        let data = Data(hexadecimalString:"338c4055145d1000")!
        let tempEventBolus = TempBasalPumpEvent(availableData: data, pumpModel: pumpModel)!
        
        let afterTempEventBolusDateComponent = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: 2016, month: 5, day: 29, hour: 21, minute: 1, second: 0)
        let afterTempEventBolusDate = afterTempEventBolusDateComponent.date!
        
        let events:[PumpEvent] = [tempEventBolus, bolusEvent2010, bolusEvent2009]
        
        //bolus should be complete, but within the Insulin action time
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: events, startDate: Date.distantPast, checkDate: afterTempEventBolusDate, pumpModel: pumpModel)
        
        // It should be counted for IoB (how to measure)
        XCTAssertTrue(array(result.events, containsPumpEvent: tempEventBolus))
    }
    
    func testMultipleBolusEventsWith523() {
        pumpModel = PumpModel.Model523
        
        let events = [bolusEvent2010, bolusEvent2009]
        
        let result = sut.convertPumpEventToTimestampedEvents(pumpEvents: events, startDate: Date.distantPast, checkDate: datePast2017, pumpModel: pumpModel)
        
        assertArray(result.events, containsPumpEvent: bolusEvent2009)
    }
    
    func createBatteryEvent(withDateComponent dateComponents: DateComponents) -> BatteryPumpEvent {
        return createBatteryEvent(atTime: dateComponents.date!)
    }
    
    func createBatteryEvent(atTime date: Date = Date()) -> BatteryPumpEvent {
     
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date) - 2000
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        let secondByte = UInt8(second) & 0b00111111
        let minuteByte = UInt8(minute) & 0b00111111
        let hourByte = UInt8(hour) & 0b00011111
        let dayByte = UInt8(day) & 0b00011111
        let monthUpperComponent = (UInt8(month) & 0b00001100) << 4
        let monthLowerComponent = (UInt8(month) & 0b00000011) << 6
        let secondMonthByte = secondByte | monthUpperComponent
        let minuteMonthByte = minuteByte | monthLowerComponent
        let yearByte = UInt8(year) & 0b01111111

        let batteryData = Data(bytes: [0,0, secondMonthByte, minuteMonthByte, hourByte, dayByte, yearByte])
        let batteryPumpEvent = BatteryPumpEvent(availableData: batteryData, pumpModel: PumpModel.Model523)!
        return batteryPumpEvent
    }
    
    func buildResponsesDictionary() -> [MessageType : [PumpMessage]] {
        
        var dictionary = [MessageType : [PumpMessage]]()
        
        // Build array of Messages for each frame
        let frameZeroMessages = buildPumpMessagesFromFrameArray(fetchPageZeroFrames)
        let frameOneMessages = buildPumpMessagesFromFrameArray(fetchPageOneFrames)
        let frameTwoMessages = buildPumpMessagesFromFrameArray(fetchPageTwoFrames)
        let frameThreeMessages = buildPumpMessagesFromFrameArray(fetchPageThreeFrames)
        let frameFourMessages = buildPumpMessagesFromFrameArray(fetchPageFourFrames)
        
        let pumpAckMessage = sut.makePumpMessage(to: .pumpAck)
        
        let emptyHistoryPageMessage = sut.makePumpMessage(to: .emptyHistoryPage)
        
        var getHistoryPageArray = [pumpAckMessage, frameZeroMessages[0]]
        getHistoryPageArray.append(contentsOf: [pumpAckMessage, frameOneMessages[0]])
        getHistoryPageArray.append(contentsOf: [pumpAckMessage, frameTwoMessages[0]])
        getHistoryPageArray.append(contentsOf: [pumpAckMessage, frameThreeMessages[0]])
        getHistoryPageArray.append(contentsOf: [pumpAckMessage, frameFourMessages[0]])
        getHistoryPageArray.append(emptyHistoryPageMessage)
        
        // pump will be called twice, normal operation will receive a pumpAck and getHistoryPageMessage
        dictionary[.getHistoryPage] = getHistoryPageArray
        
        var pumpAckArray = Array(frameZeroMessages.suffix(from: 1))
        pumpAckArray.append(contentsOf: Array(frameOneMessages.suffix(from: 1)))
        pumpAckArray.append(contentsOf: Array(frameTwoMessages.suffix(from: 1)))
        pumpAckArray.append(contentsOf: Array(frameThreeMessages.suffix(from: 1)))
        pumpAckArray.append(contentsOf: Array(frameFourMessages.suffix(from: 1)))
        // Pump sends more data after we send a .pumpAck
        dictionary[.pumpAck] = pumpAckArray
        
        return dictionary
    }
    
    //TODO write tests around existing functionality and time filtering
    //TODO add events with bolus
    
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
    
    func dataFromHexString(_ hexString: String) -> Data {
        var data = Data()
        var hexString = hexString
        while(hexString.characters.count > 0) {
            let c: String = hexString.substring(to: hexString.index(hexString.startIndex, offsetBy: 2))
            hexString = hexString.substring(from: hexString.index(hexString.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}

func array(_ timestampedEvents: [TimestampedHistoryEvent], containsPumpEvent pumpEvent: PumpEvent) -> Bool {
    let event = timestampedEvents.first { $0.pumpEvent.rawData == pumpEvent.rawData }
    
    return event != nil
}

func assertArray(_ timestampedEvents: [TimestampedHistoryEvent], containsPumpEvent pumpEvent: PumpEvent) {
    XCTAssertNotNil(timestampedEvents.first { $0.pumpEvent.rawData == pumpEvent.rawData})
}

func assertArray(_ timestampedEvents: [TimestampedHistoryEvent], containsPumpEvents pumpEvents: [PumpEvent]) {
    pumpEvents.forEach { assertArray(timestampedEvents, containsPumpEvent: $0) }
}

func assertArray(_ timestampedEvents: [TimestampedHistoryEvent], doesntContainPumpEvent pumpEvent: PumpEvent) {
    XCTAssertNil(timestampedEvents.first { $0.pumpEvent.rawData == pumpEvent.rawData })
}

// from http://jernejstrasner.com/2015/07/08/testing-throwable-methods-in-swift-2.html - transferred to Swift 3
func assertThrows<T>(_ expression: @autoclosure  () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        let _ = try expression()
        XCTFail("No error to catch! - \(message)", file: file, line: line)
    } catch {
    }
}

func assertNoThrow<T>(_ expression: @autoclosure  () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        let _ = try expression()
    } catch let error {
        XCTFail("Caught error: \(error) - \(message)", file: file, line: line)
    }
}
