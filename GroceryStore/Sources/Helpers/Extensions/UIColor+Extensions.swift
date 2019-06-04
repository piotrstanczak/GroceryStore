//
//  UIColor+Extensions.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    public func alpha(from salt: String) -> UIColor {
        let minAlpha = 0.2
        let maxAlpha = 0.9
        let fraction: Double = Double(hash64(from: salt)) / Double(Int.max)
        let result = (maxAlpha + (minAlpha - maxAlpha) * fraction)
        
        return self.withAlphaComponent(CGFloat(result))        
    }
    
    private func hash64(from salt: String) -> UInt64 {
        var result = UInt64(5381)
        let buffers = [UInt8](salt.utf8)
        for buffer in buffers {
            result = 127 * (result & 0x00ffffffffffffff) + UInt64(buffer)
        }
        return result
    }
}
