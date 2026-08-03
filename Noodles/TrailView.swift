//
//  TrailView.swift
//  Noodles
//
//  Created by Phil Stern on 8/2/26.
//

import UIKit

struct TrailConst {
    static let alphaComponent = 1.0//0.04
    static let spotSize = 5.0
    static let maxPoints = 400  // max points before capturing image of trail and clearing points
}

struct Spot: Codable {
    var position: CGPoint
    @CodableColor var color: UIColor
    
    init(ant: Ant) {
        position = ant.position
        color = ant.color
    }
}

class TrailView: UIView {
    var spots = [Spot]() { didSet { setNeedsDisplay() } }  // spots of trail, since last converted to image
    
    private var trailImageView = UIImageView()
    
    override var frame: CGRect {
        didSet {
            trailImageView.image = nil  // restart trail if orientation changes
            trailImageView.frame = frame
        }
    }
    
    // didMoveToWindow called automatically when TrailView is added/removed from superview;
    // window property is nil if TrailView was removed
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            // TrailView removed - remove trailImageView
            trailImageView.removeFromSuperview()
        } else {
            // TrailView added - add trailImageView
            superview?.insertSubview(trailImageView, belowSubview: self)  // insert trailImageView below this TrailView
        }
    }
    
    func addSpot(_ spot: Spot) {
        spots.append(spot)
    }
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        drawTrail()
    }
    
    private func drawTrail() {
        guard !spots.isEmpty else { return }
        
        var trail = UIBezierPath()
        trail = trailFrom(spots)
        
        // if trail has too many spots, replace it with an image, and continue with new spots
        if spots.count > TrailConst.maxPoints {
            spots.removeAll()
            captureTrail(trail)
        }
    }
    
    private func trailFrom(_ spots: [Spot]) -> UIBezierPath {
        let trail = UIBezierPath()
        for spot in spots {
            let spotPath = UIBezierPath(arcCenter: spot.position, radius: TrailConst.spotSize, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            spot.color.withAlphaComponent(TrailConst.alphaComponent).setFill()
            spotPath.fill()
            trail.append(spotPath)
        }
        return trail
    }
    
    // convert current view to an image, and merge it with the trailImageView's image
    private func captureTrail(_ trail: UIBezierPath) {
        guard let trailImage = self.snapshot else { return }
        if let existingImage = trailImageView.image {
            trailImageView.image = existingImage.mergeWith(topImage: trailImage)
        } else {
            trailImageView.image = trailImage
        }
    }
}
