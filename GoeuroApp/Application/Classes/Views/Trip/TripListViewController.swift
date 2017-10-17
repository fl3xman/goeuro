//
//  TripListViewController.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import ESPullToRefresh

class TripListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toobar: UIToolbar!
    
    var viewModel:TripListViewProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "\(TripListItem.self)", bundle: nil), forCellReuseIdentifier: TripListItem.Identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 115.0;
        self.tableView.es.addPullToRefresh { [weak self] in
            
            self?.refresh(by: true)
        }
        
        guard let vm = self.viewModel else { fatalError("Forgot to inject VM!") }
        vm.pending
            .take(duringLifetimeOf: self)
            .observeValues { [unowned self] pending in
                self.handle(withPending: pending)
        }
        
        vm.complete
            .take(duringLifetimeOf: self)
            .observeValues { [unowned self] complete in
                self.handle(withComplete: complete)
        }
        
        vm.errors
            .take(duringLifetimeOf: self)
            .observeValues { [unowned self] error in
                self.handle(withError: error)
        }
        
        if let items = self.toobar.items {
            items.forEach{ vm.bindListSort(to: $0.reactive ) }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func refresh(by force:Bool = false) {
        
        guard let vm = self.viewModel else { fatalError("Forgot to inject VM!") }
        vm.refresh(by: force)
    }
    
    func handle(withComplete complete:Bool) {
        
        if complete {
            self.tableView.reloadData()
        }
    }
    
    func handle(withPending pending:Bool) {
        
        if pending {
            self.tableView.es.startPullToRefresh()
        } else {
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    
    func handle(withError error:ServiceError) {
        
        self.tableView.es.stopPullToRefresh()
        
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}


extension TripListViewController: UITableViewDelegate {}

extension TripListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let vm = self.viewModel else { return 0 }
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TripListItem.Identifier, for: indexPath)
        
        if let binding = cell as? TripListItemViewBinding, let vm = self.viewModel {
            binding.bind(using: vm.bindListItem(at: indexPath))
        }
        
        return cell
    }
}
