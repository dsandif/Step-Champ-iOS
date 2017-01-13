//
//  Utilities.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/11/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import UIKit

func setColor(colorCode: String, alpha: Float = 1.0) -> UIColor {
    let scanner = Scanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt32(&color)
    
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
    let b = CGFloat(Float(Int(color) & mask)/255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[i + 1]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
//    subscript (r: Range<Int>) -> String {
//        let start = self.startIndex.advancedBy(r.lowerBound)
//        let end = start.advancedBy(r.upperBound - r.lowerBound)
//        return self[Range(start ..< end)]
//    }
}
