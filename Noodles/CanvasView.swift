//
//  CanvasView.swift
//  Noodles
//
//  Created by Phil Stern on 8/2/26.
//
//  In order to maintain performance with potentially thousands of bezier paths (spots) being drawn,
//  CanvasView uses an image view (canvasImageView) to capture the screen after a certain number of
//  spots are added, and clears out the spots.  CanvasImageView is placed behind CanvasView in the
//  storyboard.
//

import UIKit

struct CanvasConst {
    static let maxSpots = 1000  // max points before capturing image of canvas and clearing points
}

class CanvasView: UIView {
    var spotSize = 5.0

    private var spots = [Spot]() { didSet { setNeedsDisplay() } }  // spots since last converted to image
    
    @IBOutlet var canvasImageView: UIImageView!
        
    override var bounds: CGRect {
        didSet {
            if bounds != oldValue {
                spots.removeAll()  // clear all if device orientation changes
                canvasImageView.image = nil
            }
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
            let bezierSpot = UIBezierPath(arcCenter: spot.position, radius: spotSize, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            spot.color.setFill()
            bezierSpot.fill()
        }

        // if canvas has too many spots, replace it with an image, and continue with new spots
        if spots.count > CanvasConst.maxSpots {
            spots.removeAll()
            captureCanvas()
        }
    }
    
    // convert canvas view to an image, and merge it with existing image
    private func captureCanvas() {
        guard let canvasImage = self.snapshot else { return }
        print(".", terminator: "")
        if let existingImage = canvasImageView.image {
            canvasImageView.image = existingImage.mergeWith(topImage: canvasImage)
        } else {
            canvasImageView.image = canvasImage  // initial image
        }
    }
}
