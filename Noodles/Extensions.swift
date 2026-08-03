//
//  Extensions.swift
//  Ants
//
//  Created by Phil Stern on 7/31/26.
//

import UIKit

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }
    
    func limitedToRect(_ rect: CGRect, withHorizontalInset horizontalInset: CGFloat, andVerticalInset verticalInset: CGFloat) -> CGPoint {
        let limitedX = min(rect.maxX - horizontalInset, max(rect.minX + horizontalInset, x))
        let limitedY = min(rect.maxY - verticalInset, max(rect.minY + verticalInset, y))
        return CGPoint(x: limitedX, y: limitedY)
    }
}

extension UIView {
    // convert view to UIImage of same size
    // from: https://stackoverflow.com/a/41288197/2526464
    var snapshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
    // merge two UIImages
    // from: https://stackoverflow.com/a/59007888/2526464
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: CGPoint.zero, size: bottomImage.size)
        bottomImage.draw(in: rect)
        topImage.draw(in: rect, blendMode: .normal, alpha: 1)
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}
