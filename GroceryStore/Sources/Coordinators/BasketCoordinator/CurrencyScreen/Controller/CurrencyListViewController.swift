//
//  CurrencyListViewController.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class CurrencyListViewController: UIViewController, ViewModelInjectable, ViewConfigurable {
    
    // MARK: - Properties
    
    var viewModel: CurrencyListViewModel?
    var config: CurrencyListViewConfig?
    var tableDirector: TableDirector<CurrencyViewModel>?
    
    private var activityIndicator: UIActivityIndicatorView?
    private var tableView: UITableView?
    private var searchController: UISearchController?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView(with: config)
        setupViewModel()
        
        viewModel?.fetchData()
    }
    
    // MARK: - Action handlers
    
    private func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onError = { [weak self] error in
            self?.showError(with: error)
        }
        
        viewModel.onFinish = { [weak self] currencies in
            self?.tableDirector?.items = currencies
        }
        
        viewModel.onStartLoading = { [weak self] in
            self?.activityIndicator?.startAnimating()
        }
        
        viewModel.onFinishLoading = { [weak self] in
            self?.activityIndicator?.stopAnimating()
        }
    }
    
    // MARK: - View setup
    
    private func setupView(with config: CurrencyListViewConfig?) {
        guard let config = config else { return }
        
        view.backgroundColor = config.backgroundColor
        
        setupNavigation(with: config)
        setupTableView(with: config)
        setupTableDirector(with: config)
        setupLoadingIndicator()
    }
    
    private func setupLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.activityIndicator = activityIndicator
    }
    
    private func setupNavigation(with config: CurrencyListViewConfig) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocapitalizationType = .none
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = config.searchTitle
        navigationItem.searchController = searchController
        navigationItem.title = nil
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = false
        definesPresentationContext = true
        self.searchController = searchController
    }
    
    private func setupTableView(with config: CurrencyListViewConfig) {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        self.tableView = tableView
    }
    
    private func setupTableDirector(with config: CurrencyListViewConfig) {
        guard let tableView = tableView else {
            return
        }
        
        let configureCell: ((UITableViewCell, CurrencyViewModel) -> Void) = { cell, item in
            (cell as? CurrencyListViewCell)?.setup(with: CurrencyListViewCellConfig(), viewModel: item)
        }
        
        let selectedIndex: (CurrencyViewModel) -> () = { [weak self] item in
            self?.viewModel?.selectCurrency(currency: item.model)
        }
        
        tableDirector = TableDirector<CurrencyViewModel>(tableView: tableView,
                                                         cellIdentifier: config.cellIdentifier,
                                                         cellType: CurrencyListViewCell.self,
                                                         configureCell: configureCell,
                                                         selectedIndex: selectedIndex)        
    }
}

extension CurrencyListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.fetchData(with: searchBar.text)
    }
}
