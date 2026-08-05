//
//  ColorsViewController.swift
//  Noodles
//
//  Created by Phil Stern on 8/5/26.
//

import UIKit

class ColorsViewController: UIViewController {

    var theme = Theme.grayAndRed
    var updateTheme: (() -> Void)?  // callback
    
    private var nameButtons = [UIButton]()
    private var colorViews = [UIView]()
    private var pastBounds = CGRect.zero
    
    func namePositionFor(index: Int) -> CGPoint {
        CGPoint(x: 20, y: 80 + 80 * index)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds != pastBounds {
            clearScreen()  // except for title and Done button
            super.viewDidLayoutSubviews()
            for index in Theme.allCases.indices {
                addThemeNameForIndex(index)
                addThemeColorsForIndex(index)
            }
            pastBounds = view.bounds
        }
    }
    
    private func clearScreen() {
        nameButtons.forEach { $0.removeFromSuperview() }
        nameButtons.removeAll()
        colorViews.forEach { $0.removeFromSuperview() }
        colorViews.removeAll()
    }
    
    private func addThemeNameForIndex(_ index: Int) {
        let theme = Theme.allCases[index]
        let nameButton = UIButton()
        nameButton.setTitle(theme.name, for: .normal)
        nameButton.titleLabel?.font = UIFont(name: "Chalkboard SE Regular", size: 20)
        nameButton.sizeToFit()
        nameButton.frame.origin = namePositionFor(index: index)
        nameButton.setTitleColor(.systemBlue, for: .normal)
        nameButton.tag = index
        nameButton.addTarget(self, action: #selector(selectTheme), for: .touchUpInside)
        nameButtons.append(nameButton)
        view.addSubview(nameButton)
    }
    
    private func addThemeColorsForIndex(_ index: Int) {
        let theme = Theme.allCases[index]
        let namePosition = namePositionFor(index: index)
        let size = min((view.bounds.width - 40) / CGFloat(Constant.numberOfColorSources), 40)
        for i in 0..<Constant.numberOfColorSources {
            let colorView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size)))
            colorView.frame.origin = namePosition + CGPoint(x: size * CGFloat(i), y: 40)
            colorView.backgroundColor = theme.color(i, of: Constant.numberOfColorSources)
            colorViews.append(colorView)
            view.addSubview(colorView)
        }
    }
    
    @objc private func selectTheme(_ sender: UIButton) {
        theme = Theme.allCases[sender.tag]
        updateTheme?()
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func doneSelected(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
}
