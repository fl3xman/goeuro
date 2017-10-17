//
//  Base.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//


import Result
import ReactiveSwift
import Alamofire

public protocol TripListViewProvider {
    
    var count:Int { get }
    
    var pending:Signal<Bool,NoError> { get }
    var complete:Signal<Bool, NoError> { get }
    var errors:Signal<ServiceError,NoError> { get }
    
    func refresh(by force:Bool)
    func sort(by sort:Trip.Sort)
    
    func item(at indexPath:IndexPath) -> TripListItemViewProvider
}

public protocol TripListItemViewProvider {
    
    var logoUrl: URLConvertible { get }
    
    var dateText: String { get }
    var priceText: String { get }
    var durationText: String { get }
}

public protocol TripListItemViewBinding {
    func bind(using provider:TripListItemViewProvider)
}
