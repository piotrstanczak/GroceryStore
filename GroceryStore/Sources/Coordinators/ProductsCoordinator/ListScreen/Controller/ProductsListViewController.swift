//
//  ProductsListViewController.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class ProductsListViewController: UIViewController, ViewModelInjectable, ViewConfigurable {
    
    // MARK: - Properties
    
    var viewModel: ProductsListViewModel?
    var config: ProductsListViewConfig?
    var tableDirector: TableDirector<ProductViewModel>?
    
    private var mainStackView: UIStackView?
    private var tableView: UITableView?
    private var checkoutButton: UIButton?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView(with: config)
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchProducts()
        viewModel?.fetchBasket()
    }
    
    // MARK: - Action & VM handlers
    
    @objc func basketCheckoutHandler() {
        viewModel?.showBasket?()
    }
    
    private func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onError = { [weak self] error in
            self?.showError(with: error)
        }
        
        viewModel.onFinish = { [weak self] products in            
            self?.tableDirector?.items = products
        }
        
        viewModel.onBasketUpdate = { [weak self] value in
            self?.updateBasketButton(with: value)
        }
    }
    
    // MARK: - View setup
    
    private func setupView(with config: ProductsListViewConfig?) {
        guard let config = config else { return }
        
        view.backgroundColor = config.backgroundColor
        
        setupNavigation(with: config)
        setupMainStackView()
        setupTableView(with: config)
        setupCheckoutButton(with: config)
        setupTableDirector(with: config)
    }
    
    private func setupNavigation(with config: ProductsListViewConfig) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocapitalizationType = .none
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = config.searchTitle
        navigationItem.searchController = searchController
        navigationItem.title = config.title
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
    }
    
    private func setupMainStackView() {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        self.mainStackView = stackView
    }
    
    private func setupTableView(with config: ProductsListViewConfig) {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        mainStackView?.addArrangedSubview(tableView)
        self.tableView = tableView
    }
    
    private func setupTableDirector(with config: ProductsListViewConfig) {
        guard let tableView = tableView else {
            return
        }
        
        let configureCell: ((UITableViewCell, ProductViewModel) -> Void) = { cell, item in
            (cell as? ProductsListViewCell)?.setup(with: ProductsListViewCellConfig(), viewModel: item)
        }
        
        tableDirector = TableDirector(tableView: tableView,
                                      cellIdentifier: config.cellIdentifier,
                                      cellType: ProductsListViewCell.self,
                                      configureCell: configureCell)
    }
    
    private func setupCheckoutButton(with config: ProductsListViewConfig) {
        let checkoutView = UIStackView()
        let button: UIButton = UIButton(frame: CGRect.zero)
        button.backgroundColor = .black
        checkoutView.addArrangedSubview(button)
        button.setTitle("Buy", for: .normal)
        button.addTarget(self, action:#selector(self.basketCheckoutHandler), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 64).isActive = true
        mainStackView?.addArrangedSubview(checkoutView)
        checkoutButton = button
    }
    
    private func updateBasketButton(with value: String?) {
        checkoutButton?.isHidden = value == nil
        checkoutButton?.setTitle(value, for: .normal)
    }
}

extension ProductsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.fetchProducts(with: searchBar.text)
    }
}
