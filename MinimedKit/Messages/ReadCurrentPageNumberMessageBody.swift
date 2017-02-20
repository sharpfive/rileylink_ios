//
//  ReadCurrentPageNumberMessageBody.swift
//  RileyLink
//
//  Created by Jaim Zuber on 2/17/17.
//  Copyright © 2017 Pete Schwamb. All rights reserved.
//

import Foundation

public class ReadCurrentPageNumberMessageBody : MessageBody {
    public static var length: Int = 64
    public let pageNum: Int

    let rxData: Data
    
    public var txData: Data {
        return rxData
    }
 
    public required init?(rxData: Data) {
        
        var page = 0
        
        if rxData.count > 1 {
            page = Int(rxData[0])
        }// else if rxData.count > 3 {
//            page = Int(bigEndianBytes: rxData.subdata(in: 0..<4))
//        }
        
        if page < 0 || page > 36 {
            page = 36
        }
        
        pageNum = page
        self.rxData = rxData
    }
    
//    public var txData: Data {
//        return Data()
//    }
}
