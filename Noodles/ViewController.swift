//
//  ViewController.swift
//  Noodles
//
//  Created by Phil Stern on 8/2/26.
//
//  To make the SettingsViewController clear: (from: https://stackoverflow.com/a/33106533)
//  - Storyboard Segue
//    - Kind: Present Modally
//    - Presentation: Over Current Context
//  - Settings View Controller (in Storyboard)
//    - Background: Clear Color
//    - Drawing: uncheck Opaque
//
//  To do...
//  - give user a choice of color pallets (settings page)
//  - give user speed control
//    - currently: 50 points/sec (range 10 -> 200?)
//    - for smoothness: stepSize = spotSize/2
//    - to maintain speed: simulationInterval = stepSize / speed (must restart simulation when changed)
//

import UIKit

struct Constant {
    static let numberOfColorSources: Int = 20
    static let stepSize: CGFloat = 3  // distance between spots
    static let headingDeviation: CGFloat = 0.2  // radians (bigger makes tighter turns)
    static let simulationInterval: TimeInterval = 0.06  // = 50 points/sec for stepSize = 3 points
}

class ViewController: UIViewController {
    
    var colorSources = Array(repeating: ColorSource(), count: Constant.numberOfColorSources)
    var pastBounds = CGRect()
    var simulationTimer = Timer()
    
    // settings
    var spotSize: Double! {  // radius in points
        didSet {
            canvasView.spotSize = spotSize
        }
    }
    var theme: Theme! {
        didSet {
            if theme != oldValue { canvasView.clearAll() }
            setColorsBasedOnTheme()
        }
    }

    @IBOutlet weak var canvasView: CanvasView!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize settings
        spotSize = 5
        theme = .grayAndRed
        
        // add tap gesture to bring up setting view controller
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)

        startSimulation()
    }
    
    private func setColorsBasedOnTheme() {
        view.backgroundColor = theme.background
        for index in colorSources.indices {
            colorSources[index].color = theme.color(index, of: Constant.numberOfColorSources)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if view.bounds != pastBounds {
            // orientation changed - randomly position color sources
            // note: CanvasView clears screen when orientation changes
            for index in colorSources.indices {
                colorSources[index].position = randomPositionInSafeArea()
                colorSources[index].heading = Double.random(in: 0..<2 * .pi)
            }
            pastBounds = view.bounds
        }
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "Show Settings", sender: self)
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
            // limit position to canvasView (slightly past edges)
            colorSources[index].position = colorSources[index].position
                .limitedToRect(canvasView.bounds, withHorizontalInset: -spotSize, andVerticalInset: -spotSize)
            canvasView.addSpot(Spot(colorSource: colorSources[index]))
        }
    }
    
    // return random position in view coordinates limited to safe area
    // note: only call after bounds are set
    private func randomPositionInSafeArea() -> CGPoint {
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame  // iPhone 16e in portrait: origin = (0, 47), size = (390, 763)
        let safeAreaPosition = CGPoint(x: Double.random(in: 0...safeAreaFrame.width - spotSize),
                                       y: Double.random(in: 0...safeAreaFrame.height - spotSize))
        return safeAreaFrame.origin + safeAreaPosition  // convert to view coordinates
    }

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Settings" {
            if let svc = segue.destination as? SettingsViewController {
                svc.spotSize = spotSize
                svc.theme = theme
                // provide callback for settings change
                svc.updateSettings = { [weak self] in
                    self?.spotSize = svc.spotSize
                    self?.theme = svc.theme
                }
            }
        }
    }
}
