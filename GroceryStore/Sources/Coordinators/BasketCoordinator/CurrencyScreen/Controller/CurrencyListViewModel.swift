//
//  CurrencyListViewModel.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

class CurrencyListViewModel {
    
    // MARK: - Properties
    
    private let dataProvider: CurrencyProvidable
    private var viewModels: [CurrencyViewModel]?
    
    public var onStartLoading: (() -> Void)?
    public var onFinishLoading: (() -> Void)?
    public var onError: ((String) -> Void)?
    public var onFinish: (([CurrencyViewModel]) -> Void)?    
    public var onSelectCurrency: ((Currency) -> Void)?
    
    // MARK: - Initilizer
    
    init(dataProvider: CurrencyProvidable) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - Public methods
    
    public func fetchData(with phrase: String? = nil) {
        guard let viewModels = viewModels else {
            loadData(with: phrase)
            return
            
        }
        
        filterData(viewModels: viewModels, with: phrase)
    }
    
    public func selectCurrency(currency: Currency) {
        onSelectCurrency?(currency)
    }
    
    // MARK: - Private methods
    
    private func loadData(with phrase: String?) {
        onStartLoading?()
        
        self.dataProvider.loadProducts { [weak self] result in
            DispatchQueue.main.async {
                self?.onFinishLoading?()
                
                switch result {
                case .success(let currencies):
                    let viewModels = currencies.currencies
                        .sorted(by: { $0.currency < $1.currency })
                        .map { CurrencyViewModel(model: $0) }
                    
                    self?.viewModels = viewModels
                    
                    self?.filterData(viewModels: viewModels, with: phrase)
                    
                    
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func filterData(viewModels: [CurrencyViewModel], with phrase: String?) {
        guard let phrase = phrase, phrase.count > 0 else {
            onFinish?(viewModels)
            return
        }
        
        let filtered = viewModels.filter { $0.name.lowercased().contains(phrase.lowercased()) }
        onFinish?(filtered)
    }
    
}
