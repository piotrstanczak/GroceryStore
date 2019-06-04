//
//  StorableItem.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

protocol StorableType {
    var id: String { get }
    var counter: Int { get }
}

struct StorableItem: StorableType {
    let id: String
    let counter: Int
}
