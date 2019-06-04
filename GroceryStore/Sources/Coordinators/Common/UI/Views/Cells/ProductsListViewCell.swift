//
//  RepoListViewCell.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

protocol ProductListCellConfigurable {
    var fonts: [UIFont] { get set }
    var colors: [UIColor] { get set }
    var backgroundColor: UIColor { get set }
    var stepperLabelFont: UIFont { get set }
    var stepperLabelFontColor: UIColor { get set }
}

final class ProductsListViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var backgroundColorView: UIView?
    private var mainView: UIView?
    private var contentStackView: UIStackView?
    private var iconView: UIImageView?
    private var titleLabel: UILabel?
    private var categoryLabel: UILabel?
    private var priceLabel: UILabel?
    private var stepprUI: UIStepper?
    private var stepprLabel: UILabel?
    
    private var viewModel: ProductViewModel?
    private var config: ProductListCellConfigurable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconView?.image = nil
        titleLabel?.text = nil
        categoryLabel?.text = nil
        priceLabel?.text = nil
        stepprLabel?.text = nil
        stepprUI?.value = 0
    }
    
    // MARK: - Action handlers
    
    @objc func stepperValueChanged(_ stepper: UIStepper) {
        let stepperValue = Int(stepper.value)
        updateCounter(value: stepperValue)
        viewModel?.updateBasketValue(newValue: stepperValue)
    }
    
    // MARK: Setup view
    
    public func setup(with config: ProductListCellConfigurable, viewModel: ProductViewModel) {
        self.config = config
        self.viewModel = viewModel
        
        prepareView(with: config)
        setupView(with: viewModel, and: config)
    }
    
    private func setupView(with viewModel: ProductViewModel, and config: ProductListCellConfigurable) {
        mainView?.backgroundColor = config.backgroundColor.alpha(from: viewModel.identity)
        iconView?.image = UIImage(imageLiteralResourceName: viewModel.categoryIconName)
        
        titleLabel?.text = viewModel.name
        categoryLabel?.text = viewModel.categoryName
        priceLabel?.text = viewModel.priceString
        stepprUI?.value = Double(viewModel.basketCounter)
        updateCounter(value: viewModel.basketCounter)
    }
    
    private func updateCounter(value: Int) {
        stepprLabel?.text = viewModel?.stepperLabelTitle(for: value)
    }
    
    private func prepareView(with config: ProductListCellConfigurable) {
        guard mainView == nil else {
            return
        }
        
        selectionStyle = .none
        prepareShadow()
        prepareBackground()
        prepareContent()
        prepareTexts(with: config)
        prepareStepper(with: config)
    }
    
    // MARK: - Helpers
    
    private func prepareContent() {
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
        
        let imageContainer = UIView()
        stackView.addArrangedSubview(imageContainer)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        imageContainer.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let iconView = UIImageView()
        imageContainer.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor, constant: 0).isActive = true
        iconView.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        self.iconView = iconView
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
    
    private func prepareStepper(with config: ProductListCellConfigurable) {
        let stackView = UIStackView()
        contentStackView?.addArrangedSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8
        
        let stepper = UIStepper(frame: CGRect.zero)
        stepper.wraps = false
        stepper.tintColor = .white
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: .valueChanged)
        
        let titleLabel = label(font: config.stepperLabelFont, color: config.stepperLabelFontColor)
        
        stackView.addArrangedSubview(stepper)
        stackView.addArrangedSubview(titleLabel)
        
        self.stepprUI = stepper
        self.stepprLabel = titleLabel
    }
    
    private func prepareTexts(with config: ProductListCellConfigurable) {
        let stackView = UIStackView()
        contentStackView?.addArrangedSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 8
        
        let titleLabel = label(font: config.fonts[0], color: config.colors[0])
        let categoryLabel = label(font: config.fonts[1], color: config.colors[1])
        let priceLabel = label(font: config.fonts[2], color: config.colors[2])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(priceLabel)
        
        self.titleLabel = titleLabel
        self.categoryLabel = categoryLabel
        self.priceLabel = priceLabel
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
