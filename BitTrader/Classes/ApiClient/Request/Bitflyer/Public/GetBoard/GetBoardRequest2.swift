//
//  GetBoardRequest2.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import APIKit

struct GetBoardRequest2: BitflyerRequestProtocol {

    typealias Response = GetBoardResponse2

    var path: String {
        return "/v1/getboard"
    }
}
