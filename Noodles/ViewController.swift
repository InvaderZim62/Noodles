//
//  ViewController.swift
//  Noodles
//
//  Created by Phil Stern on 8/2/26.
//

import UIKit

struct Constant {
    static let antSize: CGFloat = 16
    static let antStepSize: CGFloat = 3
}

class ViewController: UIViewController {
    var anthill = Anthill()
    var trailViews = [TrailView]()
    var antViews = [AntView]()
    var pastBounds = CGRect()
    var simulationTimer = Timer()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add ants to model (eventually, emanate from hole)
        for i in 0..<10 {
            let color = UIColor(hue: Double(i)/11, saturation: 1, brightness: 1, alpha: 1)
            let ant = Ant(color: color)
            anthill.ants.append(ant)
            
            let trailView = TrailView()
            trailView.color = color
            trailViews.append(trailView)
            view.addSubview(trailView)
        }
        startSimulation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds != pastBounds {
            anthill.holePosition = randomPositionInSafeArea()
            trailViews.forEach { $0.frame = view.frame }
            
            for index in anthill.ants.indices {
                anthill.ants[index].position = randomPositionInSafeArea()
                anthill.ants[index].heading = Double.random(in: 0..<2 * .pi)
            }
            updateViewFromModel()
            pastBounds = view.bounds
        }
    }
    
    private func updateViewFromModel() {
        antViews.forEach { $0.removeFromSuperview() }

        for ant in anthill.ants {
            let antView = AntView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Constant.antSize, height: Constant.antSize / 2)))
            antView.center = ant.position
            antView.heading = ant.heading
            antViews.append(antView)
            view.addSubview(antView)
        }
    }
    
    private func startSimulation() {
        simulationTimer = Timer.scheduledTimer(timeInterval: 0.06,
                                               target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil,
                                               repeats: true)
    }
    
    @objc private func updateSimulation() {
        for index in anthill.ants.indices {
            anthill.ants[index].moveRandomly()
            //            anthill.ants[index].position = anthill.ants[index].position.limitedToRect(view.safeAreaLayoutGuide.layoutFrame)
            anthill.ants[index].position = anthill.ants[index].position.limitedToRect(view.frame)
            trailViews[index].addPoint(anthill.ants[index].position)
        }
        updateViewFromModel()
    }
    
    // random view coordinates limited to safe area
    // only call after bounds are set
    private func randomPositionInSafeArea() -> CGPoint {
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame  // iPhone 16e in portrait: origin = (0, 47), size = (390, 763)
        let safeAreaPosition = CGPoint(x: Double.random(in: 0...safeAreaFrame.width - Constant.antSize),
                                       y: Double.random(in: 0...safeAreaFrame.height - Constant.antSize))
        return safeAreaFrame.origin + safeAreaPosition  // convert to view coordinates
    }
}
