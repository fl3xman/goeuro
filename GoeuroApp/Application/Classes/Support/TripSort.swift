//
//  Enums.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import UIKit

extension Trip {
 
    public enum Sort: Int, CustomStringConvertible {
        case departure = 1
        case arrival = 2
        case duration = 3
        
        public static var all:[Sort] {
            return [.arrival, .departure, .duration]
        }
        
        public var description: String {
            switch self {
            case .arrival:
                return "Arrival"
            case .departure:
                return "Departure"
            case .duration:
                return "Duration"
            }
        }
    }
    
    public static func sorted(by sort:Sort, sortable:[DataModel]) -> [DataModel] {
        
        switch sort {
        case .arrival:  return sortable.sorted { $0.0.arrivalAt < $0.1.arrivalAt }
        case .departure:return sortable.sorted { $0.0.departureAt < $0.1.departureAt }
        case .duration: return sortable.sorted { $0.0.calculatedDuration() < $0.1.calculatedDuration() }
        }
    }

}



