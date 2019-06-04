//
//  TableDirector.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

final class TableDirector<Item>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    public var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView
    private let cellIdentifier: String
    private let cellType: UITableViewCell.Type
    
    private let configureCell: ((UITableViewCell, Item) -> Void)
    private let selectedIndex: ((Item) -> Void)?

    // MARK: - Initializer
    
    init(tableView: UITableView,
         cellIdentifier: String,
         cellType: UITableViewCell.Type,
         configureCell: @escaping ((UITableViewCell, Item) -> Void),
         selectedIndex: ((Item) -> Void)? = nil) {
        
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier                
        self.cellType = cellType
        self.configureCell = configureCell
        self.selectedIndex = selectedIndex
        
        super.init()
        
        setupTableView()
    }
    
    // MARK: - Setups
    
    private func setupTableView() {
        tableView.register(cellType, forCellReuseIdentifier: cellIdentifier)
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let item = items[indexPath.row]        
        configureCell(cell, item)

        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        selectedIndex?(item)
    }
}
