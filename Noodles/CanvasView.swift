//
//  CanvasView.swift
//  Noodles
//
//  Created by Phil Stern on 8/2/26.
//
//  In order to maintain performance with potentially thousands of bezier paths (spots) being drawn,
//  CanvasView uses an image view (canvasImageView) to capture the screen after a certain number of
//  spots are added, and clears out the spots.  CanvasImageView is created programmatically and placed
//  behind CanvasView when CanvasView is added by its superview (see func didMoveToWindow).
//
//  Note: I'm overriding bounds to determine when orientation changes, so I can reset canvasImageView's
//  frame.  When orientation changes, CanvasView's bounds change (frame becomes some intermediate value),
//  then super.viewDidLayoutSubviews is called, then CanvasView's frame is correct.  I tried overriding
//  CanvasView's frame to update canvasImageView's frame, but didSet only gets called at startup, and not
//  each time frame changes (it worked when CanvasView was added programmatically, vs in storyboard).
//

import UIKit

struct CanvasConst {
    static let maxSpots = 400  // max points before capturing image of canvas and clearing points
}

class CanvasView: UIView {
    private var spots = [Spot]() { didSet { setNeedsDisplay() } }  // spots since last converted to image
    private var canvasImageView = UIImageView()
    
    override var bounds: CGRect {
        didSet {
            spots.removeAll()  // clear all if device orientation changes
            canvasImageView.image = nil
            canvasImageView.frame = bounds  // assumes CanvasView origin is at (0, 0)
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
