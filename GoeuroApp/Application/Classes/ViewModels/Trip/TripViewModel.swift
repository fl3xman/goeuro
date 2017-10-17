//
//  TripViewModel.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import Result
import ReactiveSwift
import ReactiveCocoa
import SwiftDate
import Alamofire

extension Trip {
    
    
    public class ListViewModel {
        
        unowned private let service:Service
        
        fileprivate let api:API
        fileprivate let getList:APIAction
        fileprivate let list = MutableProperty<[DataModel]>([])
        fileprivate var sort = Sort.duration
        
        public init(service:Service, api:API) {
            self.service = service
            self.api = api
            
            self.getList = self.service.reactive.getAll
            self.list <~ self.getList.values.map{
                [unowned self] in Trip.sorted(by: self.sort, sortable: $0)
            }.observe(on: UIScheduler())
        }
    }
}



extension Trip.DataModel: TripListItemViewProvider {
    
    public var logoUrl: URLConvertible {
        
        let path = self.logoPath?.replacingOccurrences(of: "{size}", with: "63")
        return path ?? ""
    }
    
    public var priceText: String {
        
        return "\((self.price ?? 0)) Euros"
    }
    
    public var durationText: String {
        
        let dur = Date(timeIntervalSince1970: self.calculatedDuration())
        return "\(dur.string(custom: "HH:mm"))"
    }
    
    public var dateText: String {
        
        let from =  self.departureAt.string(custom: "HH:mm")
        let to =    self.arrivalAt.string(custom: "HH:mm")
    
        return "\(from) - \(to) h"
    }
}


extension Trip.ListViewModel: TripListViewProvider {
 
    public var pending:Signal<Bool,NoError> {
        return getList.isExecuting.signal.observe(on: UIScheduler())
    }
    
    public var complete:Signal<Bool, NoError> {
        return getList.values.map{ !$0.isEmpty }.observe(on: UIScheduler())
    }
    
    public var errors:Signal<ServiceError,NoError> {
        return getList.errors.observe(on: UIScheduler())
    }
    
    public var count: Int {
        return self.list.value.count
    }
    
    public func item(at indexPath:IndexPath) -> TripListItemViewProvider {
        return self.list.value[indexPath.item]
    }
    
    public func sort(by sort:Trip.Sort) {
        self.sort = sort
        self.list.value = Trip.sorted(by: self.sort, sortable: self.list.value)
    }
    
    public func refresh(by force:Bool = false) {
        if (force || self.list.value.isEmpty) {
            getList.apply(self.api).start()
        }
    }
    
}
