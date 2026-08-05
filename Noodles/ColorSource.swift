//
//  ColorSource.swift
//  Ants
//
//  Created by Phil Stern on 7/31/26.
//

import UIKit

struct ColorSource {
    var position = CGPoint(x: 0, y: 0)
    var heading = 0.0  // 0 radians to right, positive clockwise
    var color = UIColor.white
    
    mutating func moveRandomly() {
        heading = gaussianRandom(mean: heading, standardDeviation: Constant.headingDeviation)
        let deltaPosition = CGPoint(x: Constant.stepSize * cos(heading), y: Constant.stepSize * sin(heading))
        position += deltaPosition
    }
    
    private func gaussianRandom(mean: Double, standardDeviation: Double) -> Double {
        let u1 = Double.random(in: 0..<1)
        let u2 = Double.random(in: 0..<1)
        let z1 = sqrt(-2.0 * log(u1))
        let z2 = 2.0 * .pi * u2
        return mean + standardDeviation * z1 * cos(z2)
    }
}
