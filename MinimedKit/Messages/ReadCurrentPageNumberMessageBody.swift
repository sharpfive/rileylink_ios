//
//  ReadCurrentPageNumberMessageBody.swift
//  RileyLink
//
//  Created by Jaim Zuber on 2/17/17.
//  Copyright © 2017 Pete Schwamb. All rights reserved.
//

import Foundation

class ReadCurrentPageNumberMessageBody : MessageBody {
    static var length: Int = 30

    
    public required init?(rxData: Data) {
        return nil
    }
    
    var txData: Data {
        return Data()
    }
}
