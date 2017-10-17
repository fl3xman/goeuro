//
//  Mapping.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import ObjectMapper
import SwiftDate

public func CustomDateTransform() -> TransformOf<Date, String> {
    return TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        return value?.date(format: .custom("HH:mm"))?.absoluteDate
    }, toJSON: { (value: Date?) -> String? in
        return nil
    })
}

public func CustomPriceTransform() -> TransformOf<Decimal, Any> {
    return TransformOf<Decimal, Any>(fromJSON: { (value: Any?) -> Decimal? in
        
        return Decimal(string: ((value as? String) ?? "\((value ?? "0"))"))
        
    }, toJSON: { (value: Decimal?) -> Any? in
        return nil
    })
}
