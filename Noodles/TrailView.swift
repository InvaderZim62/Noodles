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

class TrailView: UIView {
    var color = UIColor.white
    var allPoints = [CGPoint]()
    
    private var points = [CGPoint]() { didSet { setNeedsDisplay() } }  // points of trail, since last converted to image
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
    
    func addPoint(_ point: CGPoint) {
        points.append(point)
        allPoints.append(point)
    }
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        drawTrail()
    }
    
    private func drawTrail() {
        guard !points.isEmpty else { return }
        
        var trail = UIBezierPath()
        trail = trailFrom(points)
        color.withAlphaComponent(TrailConst.alphaComponent).setFill()
        trail.fill()
        
        // if trail has too many points, replace it with an image, and continue with new points
        if points.count > TrailConst.maxPoints {
            points.removeAll()
            captureTrail(trail)
        }
    }
    
    private func trailFrom(_ points: [CGPoint]) -> UIBezierPath {
        let trail = UIBezierPath()
        for point in points {
            let spot = UIBezierPath(arcCenter: point, radius: TrailConst.spotSize, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            trail.append(spot)
        }
        return trail
    }
    
    // convert current trail (Bezier path) to an image, and merge it with the trailImageView's image
    private func captureTrail(_ trail: UIBezierPath) {
        let trailImage = trail.image(size: bounds.size, color: color.withAlphaComponent(TrailConst.alphaComponent))
        if let existingImage = trailImageView.image {
            trailImageView.image = existingImage.mergeWith(topImage: trailImage)
        } else {
            trailImageView.image = trailImage
        }
    }
}
