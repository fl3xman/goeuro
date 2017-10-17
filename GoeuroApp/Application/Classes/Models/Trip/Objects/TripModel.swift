//
//  Trip.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import ObjectMapper
import SwiftDate

extension Trip {
    public struct DataModel {
  
        public var id: Int?
        public var logoPath: String?
        public var price: Decimal?
        public var departureAt:Date = Date()
        public var arrivalAt:Date = Date()
        
        public var stops: Int?
        public var duration: Int = 0
        
        
        public func calculatedDuration() -> TimeInterval {
            guard self.duration == 0 else { return TimeInterval(self.duration) }
            
            return arrivalAt.timeIntervalSince(departureAt)
        }
    }
}

extension Trip.DataModel: Mappable {
    
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        id              <- map["id"]
        logoPath        <- map["provider_logo"]
        price           <- (map["price_in_euros"], CustomPriceTransform())
        departureAt     <- (map["departure_time"], CustomDateTransform())
        arrivalAt       <- (map["arrival_time"], CustomDateTransform())
        stops           <- map["number_of_stops"]
        duration        <- map["duration"]
    }
}
