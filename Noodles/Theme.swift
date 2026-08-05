//
//  Theme.swift
//  Noodles
//
//  Created by Phil Stern on 8/5/26.
//

import UIKit

enum Theme: String, CaseIterable {
    case grayscale = "Grayscale"
    case grayAndRed = "Gray & Red"
    case rainbow = "Rainbow"
    
    var name: String {
        switch self {
        case .grayscale:
            return "Grayscale"
        case .grayAndRed:
            return "Gray & Red"
        case .rainbow:
            return "Rainbow"
        }
    }
    
    func color(_ index: Int, of numberOfColors: Int) -> UIColor {
        let fraction = Double(index)/Double(numberOfColors)  // 0 to 1
        switch self {
        case .grayscale:
            return UIColor(red: fraction, green: fraction, blue: fraction, alpha: 1)
        case .grayAndRed:
            if index == numberOfColors - 1 {
                return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            } else {
                return UIColor(red: fraction, green: fraction, blue: fraction, alpha: 1)
            }
        case .rainbow:
            let fraction = Double(index)/Double(numberOfColors)
            return UIColor(hue: fraction, saturation: 1, brightness: 1, alpha: 1)
        }
    }
}
