//
//  BasketSummaryViewCellConfig.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

struct BasketSummaryViewCellConfig: ProductListCellConfigurable {    
    var fonts: [UIFont] = [UIFont.boldSystemFont(ofSize: 18.0), UIFont.systemFont(ofSize: 16), UIFont.italicSystemFont(ofSize: 14)]
    var colors: [UIColor] = [.black, .white, UIColor(rgb: 0x53caf8)]
    var backgroundColor = UIColor(rgb: 0x009933)
    var stepperLabelFont = UIFont.systemFont(ofSize: 14)
    var stepperLabelFontColor = UIColor.white
}
