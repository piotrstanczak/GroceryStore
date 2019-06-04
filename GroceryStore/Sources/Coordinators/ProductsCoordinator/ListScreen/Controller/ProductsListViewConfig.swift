//
//  ProductsListConfig.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

struct ProductsListViewConfig {
    let backgroundColor: UIColor = .white
    let cellIdentifier: String = "cellIdentifier"
    let title: String = "Grocery store"
    let searchTitle: String = "Search for a product"
    let cellConfig: ProductListCellConfigurable = ProductsListViewCellConfig()
}

