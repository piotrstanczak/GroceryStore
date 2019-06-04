//
//  ViewModelInjectable.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

/// ViewModel injectable procol
protocol ViewModelInjectable: class {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType { get set }
}
