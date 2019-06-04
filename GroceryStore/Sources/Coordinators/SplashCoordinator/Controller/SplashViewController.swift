//
//  SplashViewController.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, ViewModelInjectable, ViewConfigurable {
    
    // MARK: - Properties
    
    var viewModel: SplashViewModel?
    var config: SplashViewConfig?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let config = config,
            let viewModel = viewModel else { return }
        
        setupView(with: config)
        setupView(with: viewModel)
    }
    
    // MARK: - View setup
    
    private func setupView(with config: SplashViewConfig) {
        view.backgroundColor = config.backgroundColor
        
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 30.0
        
        let imageView = UIImageView()
        stackView.addArrangedSubview(imageView)
        imageView.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        imageView.image = UIImage(imageLiteralResourceName: config.iconName)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.textAlignment = .center
        label.text = config.title
        stackView.addArrangedSubview(label)
    }
    
    private func setupView(with viewModel: SplashViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.showTime) {
            self.viewModel?.completed?()
        }
    }
}
