//
//  Spot.swift
//  Noodles
//
//  Created by Phil Stern on 8/3/26.
//

import UIKit

struct Spot: Codable {
    var position: CGPoint
    @CodableColor var color: UIColor
    
    init(colorSource: ColorSource) {
        position = colorSource.position
        color = colorSource.color
    }
}
