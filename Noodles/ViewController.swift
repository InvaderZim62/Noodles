//
//  ViewController.swift
//  Noodles
//
//  Created by Phil Stern on 8/2/26.
//
//  To do...
//  - give user a choice of color pallets (settings page)
//  - allow user to vary the heading deviation in ColorSource.moveRandomly()
//

import UIKit

struct Constant {
    static let numberOfColorSources: Int = 20
    static let stepSize: CGFloat = 3  // distance between spots
    static let headingDeviation: CGFloat = 0.2  // radians (~5 deg) 1-sigma
    static let simulationInterval: TimeInterval = 0.06
}

class ViewController: UIViewController {
    var colorSources = [ColorSource]()
    var pastBounds = CGRect()
    var simulationTimer = Timer()
    
    // settings
    var spotSize = 5.0 {
        didSet {
            canvasView.spotSize = spotSize
        }
    }
    var theme = 0
    
    @IBOutlet weak var canvasView: CanvasView!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create color sources
        for i in 0..<Constant.numberOfColorSources {
            let fraction = Double(i)/Double(Constant.numberOfColorSources)  // 0 to 1
//            let color = UIColor(hue: fraction, saturation: 1, brightness: 1, alpha: 1)
            let color = UIColor(red: fraction, green: fraction, blue: fraction, alpha: 1)
            let colorSource = ColorSource(color: color)
            colorSources.append(colorSource)
        }
        // additional colors
//        colorSources.append(ColorSource(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        colorSources.append(ColorSource(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)

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
