//
//  AntView.swift
//  Ants
//
//  Created by Phil Stern on 7/31/26.
//

import UIKit

class AntView: UIView {
    
    var heading: CGFloat = 0.0 {  // 0 radians to right, positive clockwise
        didSet {
            self.transform = CGAffineTransform(rotationAngle: heading)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // abdomen o-o head
    override func draw(_ rect: CGRect) {
        UIColor.black.setFill()
        UIColor.black.setStroke()
        let radius = 0.2 * bounds.width

        let headCenter = CGPoint(x: 0.8 * bounds.width, y: bounds.midY)
        let head = UIBezierPath(arcCenter: headCenter, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        head.fill()
        
        let abdomenCenter = CGPoint(x: 0.2 * bounds.width, y: bounds.midY)
        let abdomen = UIBezierPath(arcCenter: abdomenCenter, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        abdomen.fill()
        
        let thorax = UIBezierPath()
        thorax.move(to: headCenter)
        thorax.addLine(to: abdomenCenter)
        thorax.lineWidth = 0.15 * bounds.width
        thorax.stroke()
    }
}
