//
//  Theme.swift
//  Noodles
//
//  Created by Phil Stern on 8/5/26.
//

import UIKit

enum Theme: String, CaseIterable {
    case grayscale = "Grayscale"
    case grayAndRed = "Gray & Red"
    case rainbow = "Rainbow"
    case pollock1 = "Pollock Unravelling"
    case pollock2 = "Pollock Blue Poles"
    case pollock3 = "Pollock Untitled"
    
    var background: UIColor {
        switch self {
        case .pollock3:
            return #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.6183914812, alpha: 1)
        default:
            return .black
        }
    }

    func color(_ index: Int, of numberOfColors: Int) -> UIColor {
        guard index < numberOfColors else { return .clear }
        let fraction = Double(index)/Double(numberOfColors)  // 0 to 0.99
        switch self {
        case .grayscale:
            return UIColor(red: fraction, green: fraction, blue: fraction, alpha: 1)
        case .grayAndRed:
            if index == numberOfColors - 1 {
                return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            } else {
                return UIColor(red: fraction, green: fraction, blue: fraction, alpha: 1)
            }
        case .rainbow:
            let fraction = Double(index)/Double(numberOfColors)
            return UIColor(hue: fraction, saturation: 1, brightness: 1, alpha: 1)
        case .pollock1:
            return [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)][index]  // from "Unravelling the Genius of Abstract Expressionism"
        case .pollock2:
            return [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0, green: 0.4889662862, blue: 0.4778470397, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)][index]  // from "Blue Poles"
        case .pollock3:
            return [#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.3408872003, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.3408872003, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.3408872003, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.6183914812, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.6183914812, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.6183914812, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.6183914812, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)][index]  // untitled
        }
    }
}
