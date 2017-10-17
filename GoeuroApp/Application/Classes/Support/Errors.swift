//
//  Errors.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

public enum ServiceError: Error, CustomStringConvertible {
    
    case noData
    case disabled
    case underlying(error:Error)
    
    public var description: String {
        switch self {
        case .noData:
            return "There is not data!"
        case .disabled:
            return "Your action is currently disabled!"
        case .underlying(let error):
            return "There was an error \(error)"
        }
    }
}
