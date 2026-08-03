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
    
    func limitedToRect(_ rect: CGRect) -> CGPoint {
        let limitedX = min(rect.maxX, max(rect.minX, x))
        let limitedY = min(rect.maxY, max(rect.minY, y))
        return CGPoint(x: limitedX, y: limitedY)
    }
    
    func limitedToView(_ view: UIView, withHorizontalInset horizontalInset: CGFloat, andVerticalInset verticalInset: CGFloat) -> CGPoint {
        let limitedX = min(view.bounds.maxX - horizontalInset, max(view.bounds.minX + horizontalInset, x))
        let limitedY = min(view.bounds.maxY - verticalInset, max(view.bounds.minY + verticalInset, y))
        return CGPoint(x: limitedX, y: limitedY)
    }
    
    func limitedToRect(_ rect: CGRect, withHorizontalInset horizontalInset: CGFloat, andVerticalInset verticalInset: CGFloat) -> CGPoint {
        let limitedX = min(rect.maxX - horizontalInset, max(rect.minX + horizontalInset, x))
        let limitedY = min(rect.maxY - verticalInset, max(rect.minY + verticalInset, y))
        return CGPoint(x: limitedX, y: limitedY)
    }
}

extension UIBezierPath {
    func image(size: CGSize, color: UIColor, lineWidth: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            color.setStroke()
            self.lineWidth = lineWidth
            stroke()
        }
    }
    
    func image(size: CGSize, color: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            color.setFill()
            fill()
        }
    }
}

extension UIView {
    // convert view to UIImage (same size)
    var snapshot: UIImage? {
        // from: https://stackoverflow.com/a/41288197/2526464
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

// from: https://stackoverflow.com/a/75513549/2526464
extension Array where Element: NSAttributedString {
    func joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else { return NSAttributedString() }
        
        return dropFirst()
            .reduce(into: NSMutableAttributedString(attributedString: firstElement)) { collector, element in
                collector.append(separator)
                collector.append(element)
            }
    }
    
    func joined(separator: String = "") -> NSAttributedString {
        joined(separator: NSAttributedString(string: separator))
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

// propertyWrapper and extension to allow a struct with a UIColor var to be Codable
// from: https://stackoverflow.com/a/50934846/2526464
// Usage:
//   struct MyStruct: Codable {
//      @CodableColor var color: UIColor
//      ...
//   }

@propertyWrapper
struct CodableColor {
    var wrappedValue: UIColor
}

extension CodableColor: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        wrappedValue = color
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
}
