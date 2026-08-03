//
//  Anthill.swift
//  Ants
//
//  Created by Phil Stern on 7/31/26.
//

import Foundation

struct Anthill: Codable {
    var ants = [Ant]()
    var holePosition = CGPoint(x: 0, y: 0)
}
