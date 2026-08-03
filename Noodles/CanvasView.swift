//
//  CanvasView.swift
//  Noodles
//
//  Created by Phil Stern on 8/2/26.
//

import UIKit

struct CanvasConst {
    static let maxSpots = 400  // max points before capturing image of canvas and clearing points
}

class CanvasView: UIView {
    private var spots = [Spot]() { didSet { setNeedsDisplay() } }  // spots since last converted to image
    private var canvasImageView = UIImageView()
    
    override var frame: CGRect {
        didSet {
            canvasImageView.image = nil  // clear canvas if device orientation changes
            canvasImageView.frame = frame
        }
    }
    
    // didMoveToWindow called automatically when CanvasView is added/removed from superview;
    // window property is nil if CanvasView was removed
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            // CanvasView removed - remove canvasImageView
            canvasImageView.removeFromSuperview()
        } else {
            // CanvasView added - add canvasImageView
            superview?.insertSubview(canvasImageView, belowSubview: self)  // insert canvasImageView below this CanvasView
        }
    }
    
    func addSpot(_ spot: Spot) {
        spots.append(spot)
    }
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        drawSpots()
    }
    
    private func drawSpots() {
        guard !spots.isEmpty else { return }
        
        for spot in spots {
            let bezierSpot = UIBezierPath(arcCenter: spot.position, radius: Constant.spotSize, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            spot.color.setFill()
            bezierSpot.fill()
        }

        // if canvas has too many spots, replace it with an image, and continue with new spots
        if spots.count > CanvasConst.maxSpots {
            spots.removeAll()
            captureCanvas()
        }
    }
    
    // convert canvas view to an image, and merge it with the canvasImageView's image
    private func captureCanvas() {
        guard let canvasImage = self.snapshot else { return }
        if let existingImage = canvasImageView.image {
            canvasImageView.image = existingImage.mergeWith(topImage: canvasImage)
        } else {
            canvasImageView.image = canvasImage
        }
    }
}
