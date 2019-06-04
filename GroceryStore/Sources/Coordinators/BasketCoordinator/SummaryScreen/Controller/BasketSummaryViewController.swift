//
//  BasketSummaryViewController.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class BasketSummaryViewController: UIViewController, ViewModelInjectable, ViewConfigurable {
    
    // MARK: - Properties
    
    var viewModel: BasketSummaryViewModel?
    var config: BasketSummaryViewConfig?
    
    private var mainStackView: UIStackView?
    private var tableDirector: TableDirector<ProductViewModel>?
    private let tableView = UITableView()
    private var checkoutButton: UIButton?
    private var closeButton: UIButton?
    private var changeCurrencyButton: UIButton?
        
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        setupView(with: config)
        setupViewModel()
        
        viewModel?.fetchProducts()
        viewModel?.fetchBasket()
    }
    
    // MARK: - Action handlers
    
    @objc func basketPaymentHandler() {
        // TODO: Make payment
    }
    
    @objc func closeSummaryHandler() {
        viewModel?.dismissSummary?()
    }
    
    @objc func changeCurrencyHandler() {
        viewModel?.showCurrenciec?()
    }
    
    // MARK: - View setup
    
    private func setupView(with config: BasketSummaryViewConfig?) {
        guard let config = config else { return }
        
        view.backgroundColor = config.backgroundColor
        
        setupMainStackView()
        setupHeaderInfoButton()
        setupTableView(with: config)
        setupFooterButtons()
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
    
    private func setupHeaderInfoButton() {
        let button: UIButton = prepareButton()
        button.setTitle("Buy", for: .normal)
        button.addTarget(self, action:#selector(self.basketPaymentHandler), for: .touchUpInside)
        mainStackView?.addArrangedSubview(button)
        checkoutButton = button
    }
    
    private func setupTableView(with config: BasketSummaryViewConfig) {
        tableView.backgroundColor = .white
        mainStackView?.addArrangedSubview(tableView)
        
        let configureCell: ((UITableViewCell, ProductViewModel) -> Void) = { cell, item in
            (cell as? ProductsListViewCell)?.setup(with: BasketSummaryViewCellConfig(), viewModel: item)
        }
        
        tableDirector = TableDirector(tableView: tableView,
                                              cellIdentifier: config.cellIdentifier,
                                              cellType: ProductsListViewCell.self,
                                              configureCell: configureCell)
        
    }
    
    private func setupFooterButtons() {
        let checkoutView = UIStackView()
        checkoutView.axis = NSLayoutConstraint.Axis.vertical
        checkoutView.distribution = .equalSpacing
        checkoutView.alignment = .fill
        checkoutView.spacing = 8
        mainStackView?.addArrangedSubview(checkoutView)
        
        let currency: UIButton = prepareButton()
        currency.setTitle(config?.changeCurrencyButtonTitle, for: .normal)
        currency.addTarget(self, action:#selector(self.changeCurrencyHandler), for: .touchUpInside)
        checkoutView.addArrangedSubview(currency)
        
        let close: UIButton = prepareButton()
        close.setTitle(config?.closeButtonTitle, for: .normal)
        close.addTarget(self, action:#selector(self.closeSummaryHandler), for: .touchUpInside)
        checkoutView.addArrangedSubview(close)
        
        changeCurrencyButton = currency
        closeButton = close
    }
    private func prepareButton() -> UIButton {
        let button: UIButton = UIButton(frame: CGRect.zero)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
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
    
    private func updateBasketButton(with price: Price?) {
        checkoutButton?.isHidden = price == nil
        
        let buttonTitle: String
        if let value = price?.priceString {
            buttonTitle = "Total: \(value)"
        } else {
            buttonTitle = "Total: 0"
        }
        
        checkoutButton?.setTitle(buttonTitle, for: .normal)
    }
}
