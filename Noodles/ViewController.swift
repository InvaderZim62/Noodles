//
//  ViewController.swift
//  Noodles
//
//  Created by Phil Stern on 8/2/26.
//

import UIKit

struct Constant {
    static let numberOfColorSources: Int = 20
    static let spotSize: CGFloat = 5
    static let stepSize: CGFloat = 3  // distance between spots
    static let simulationInterval: TimeInterval = 0.06
}

class ViewController: UIViewController {
    var colorSources = [ColorSource]()
    var pastBounds = CGRect()
    var simulationTimer = Timer()
    
    @IBOutlet weak var canvasView: CanvasView!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // create color sources
        for i in 0..<Constant.numberOfColorSources {
            let hue = Double(i)/Double(Constant.numberOfColorSources)
            let color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            let colorSource = ColorSource(color: color)
            colorSources.append(colorSource)
        }
        startSimulation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if view.bounds != pastBounds {
            // randomly place color sources on screen
            for index in colorSources.indices {
                colorSources[index].position = randomPositionInSafeArea()
                colorSources[index].heading = Double.random(in: 0..<2 * .pi)
            }
            pastBounds = view.bounds
        }
    }
    
    private func startSimulation() {
        simulationTimer = Timer.scheduledTimer(timeInterval: Constant.simulationInterval,
                                               target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil,
                                               repeats: true)
    }
    
    // move color sources and add spots to canvas
    @objc private func updateSimulation() {
        for index in colorSources.indices {
            colorSources[index].moveRandomly()
            // limit position to screen (allow past edges)
            colorSources[index].position = colorSources[index].position
                .limitedToRect(view.frame, withHorizontalInset: -Constant.spotSize, andVerticalInset: -Constant.spotSize)
            canvasView.addSpot(Spot(colorSource: colorSources[index]))
        }
    }
    
    // return random position in view coordinates limited to safe area
    // note: only call after bounds are set
    private func randomPositionInSafeArea() -> CGPoint {
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame  // iPhone 16e in portrait: origin = (0, 47), size = (390, 763)
        let safeAreaPosition = CGPoint(x: Double.random(in: 0...safeAreaFrame.width - Constant.spotSize),
                                       y: Double.random(in: 0...safeAreaFrame.height - Constant.spotSize))
        return safeAreaFrame.origin + safeAreaPosition  // convert to view coordinates
    }
}
