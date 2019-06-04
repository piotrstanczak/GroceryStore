//
//  RepoListViewCell.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

protocol CurrencyListCellConfigurable {
    var fonts: [UIFont] { get set }
    var colors: [UIColor] { get set }
    var backgroundColor: UIColor { get set }    
}

final class CurrencyListViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var backgroundColorView: UIView?
    private var mainView: UIView?
    private var contentStackView: UIStackView?
    private var titleLabel: UILabel?
    private var priceLabel: UILabel?
    
    private var viewModel: CurrencyViewModel?
    private var config: CurrencyListCellConfigurable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel?.text = nil
        priceLabel?.text = nil
    }
    
    // MARK: Setup view
    
    public func setup(with config: CurrencyListCellConfigurable, viewModel: CurrencyViewModel) {
        self.config = config
        self.viewModel = viewModel
        
        prepareView(with: config)
        setupView(with: viewModel, and: config)
    }
    
    private func setupView(with viewModel: CurrencyViewModel, and config: CurrencyListCellConfigurable) {
        mainView?.backgroundColor = config.backgroundColor.alpha(from: viewModel.identity)
        titleLabel?.text = viewModel.name
        priceLabel?.text = viewModel.priceString
    }
    
    private func prepareView(with config: CurrencyListCellConfigurable) {
        guard mainView == nil else {
            return
        }
        
        selectionStyle = .none
        prepareShadow()
        prepareBackground()
        prepareContent(with: config)
    }
    
    // MARK: - Helpers
    
    private func prepareContent(with config: CurrencyListCellConfigurable) {
        let stackView = UIStackView()
        self.contentView.addSubview(stackView)
        self.contentStackView = stackView
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 30.0
        
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -35).isActive = true
        
        let titleLabel = label(font: config.fonts[0], color: config.colors[0])
        let priceLabel = label(font: config.fonts[1], color: config.colors[1])
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceLabel)
        
        self.titleLabel = titleLabel
        self.priceLabel = priceLabel
    }
    
    private func prepareShadow() {
        let shadowView = ShadowView()
        self.contentView.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0).isActive = true
        shadowView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        shadowView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
    }
    
    private func prepareBackground() {        
        let mainView = UIView()
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 6
        mainView.layer.masksToBounds = true
        self.contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0).isActive = true
        mainView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        mainView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        self.mainView = mainView
    }
    
    private func label(font: UIFont, color: UIColor) -> UILabel {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = font
        textLabel.textColor = color
        textLabel.textAlignment = .left
        return textLabel
    }
}
