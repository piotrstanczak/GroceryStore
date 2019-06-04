//
//  CurrencyListViewCellConfig.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

struct CurrencyListViewCellConfig: CurrencyListCellConfigurable {
    var fonts: [UIFont] = [UIFont.boldSystemFont(ofSize: 18.0), UIFont.italicSystemFont(ofSize: 14)]
    var colors: [UIColor] = [.white, UIColor(rgb: 0x53caf8)]
    var backgroundColor = UIColor(rgb: 0x3333333)
}
