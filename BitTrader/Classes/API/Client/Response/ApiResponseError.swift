//
//  ApiResponseError.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct ApiResponseError: Error {
    let status: Int
    let message: String
    let data: Any?
}
