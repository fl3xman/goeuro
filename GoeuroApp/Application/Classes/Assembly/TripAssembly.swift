//
//  TripAssembly.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import SwinjectAutoregistration
import Swinject
import SwinjectStoryboard

@objc
public class Assembly: NSObject {
    
    public static func resolve() -> UIViewController? {
        
        let container = register()
        let bundle = Bundle(for: TripListViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Trip", bundle: bundle, container: container)
        
        return storyboard.instantiateInitialViewController()
    }
    
    private static func register() -> Container {
        return Container { container in
            // Models
            
            container
                .autoregister(Trip.Service.self, initializer: Trip.Service.init)
            
            
            // View models
            
            container
                .register(TripListViewProvider.self, name: API.flights.name) { r in
                    Trip.ListViewModel(service: r.resolve(Trip.Service.self)!, api: API.flights)
            }
            
            container
                .register(TripListViewProvider.self, name: API.trains.name) { r in
                    Trip.ListViewModel(service: r.resolve(Trip.Service.self)!, api: API.trains)
            }
            
            container
                .register(TripListViewProvider.self, name: API.buses.name) { r in
                    Trip.ListViewModel(service: r.resolve(Trip.Service.self)!, api: API.buses)
            }
            
            
            // Views
            
            
            container.storyboardInitCompleted(UITabBarController.self) { _, _ in }
            container.storyboardInitCompleted(UINavigationController.self) { _, _ in }
        
            container.storyboardInitCompleted(TripListViewController.self, name: API.flights.name) { r, c in
                c.viewModel = r.resolve(TripListViewProvider.self, name: API.flights.name)
            }
            
            container.storyboardInitCompleted(TripListViewController.self, name: API.trains.name) { r, c in
                c.viewModel = r.resolve(TripListViewProvider.self, name: API.trains.name)
            }
            
            container.storyboardInitCompleted(TripListViewController.self, name: API.buses.name) { r, c in
                c.viewModel = r.resolve(TripListViewProvider.self, name: API.buses.name)
            }
        }
    }
}
