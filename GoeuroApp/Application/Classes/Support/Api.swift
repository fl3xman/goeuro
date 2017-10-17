//
//  Api.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import Alamofire

public enum API: CustomStringConvertible, Hashable {
    
    public static let statusCodes = 200..<400
    public static let contentTypes = ["application/json"]
    
    private static let root = "https://api.myjson.com/bins"
    
    case flights
    case trains
    case buses
    
    public var name: String {
        switch self {
        case .flights:  return "flights"
        case .trains:   return "trains"
        case .buses:    return "buses"
        }
    }
    
    public var description: String {
        switch self {
        case .flights:
            return API.root + "/w60i"
        case .trains:
            return API.root + "/3zmcy"
        case .buses:
            return API.root + "/37yzm"
        }
    }
    
    public var hashValue: Int {
        return self.description.hashValue
    }
    
    public func resolve() -> (url:URLConvertible, method:HTTPMethod) {
        
        switch self {
        case .flights:  return (url:self.description, method: .get)
        case .trains:   return (url:self.description, method: .get)
        case .buses:    return (url:self.description, method: .get)
        }
    }
}

public func ==(lhs:API, rhs:API) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

