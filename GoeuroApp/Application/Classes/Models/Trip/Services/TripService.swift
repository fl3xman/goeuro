//
//  TripService.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import ReactiveSwift
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

extension Trip {
    
    public typealias APIAction = Action<API,[DataModel],ServiceError>
    
    public class Service: ReactiveExtensionsProvider {
                
        fileprivate func dataRequest(using api:API, parameters:Parameters? = nil) -> DataRequest {
            
            let (url, method) = api.resolve()
            return Alamofire.request(url, method: method, parameters:parameters)
        }
    }
}

extension Reactive where Base: Trip.Service {
    
    public var getAll:Trip.APIAction {
        return Trip.APIAction { api in
            
            return SignalProducer<[Trip.DataModel], ServiceError> { observer, disposable in
                
                let queue = DispatchQueue.global(qos: .utility)
                let request = self.base.dataRequest(using: api)
                
                print("Request with api: \(api)")
                
                disposable.observeEnded {
                    request.cancel()
                }
                
                request
                    .validate(statusCode: API.statusCodes)
                    .validate(contentType: API.contentTypes)
                    .responseArray(queue: queue) { (response:DataResponse<[Trip.DataModel]>) in
                    
                        if let error = response.error {
                            print("Error \(error.localizedDescription)")
                            observer.send(error: .underlying(error:error))
                        } else {
                            
                            if case .success(let data) = response.result {
                                observer.send(value: data)
                                observer.sendCompleted()
                            } else {
                                observer.send(error: .noData)
                            }
                        }
                }
                
            }
        }
    }
}
