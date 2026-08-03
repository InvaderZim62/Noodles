//
//  Spot.swift
//  Noodles
//
//  Created by Phil Stern on 8/3/26.
//

import UIKit

struct Spot {
    var position: CGPoint
    var color: UIColor
    
    init(colorSource: ColorSource) {
        position = colorSource.position
        color = colorSource.color
    }
}
