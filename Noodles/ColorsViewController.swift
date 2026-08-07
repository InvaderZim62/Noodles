//
//  ColorsViewController.swift
//  Noodles
//
//  Created by Phil Stern on 8/5/26.
//

import UIKit

struct ColorConst {
    static let themeSectionAspectRatio = 4.0  // width / height
    static let colorPatchAspectRatio = 1.0
    static let spaceBetweenThemes = 20.0
}

class ColorsViewController: UIViewController {

    var theme = Theme.grayAndRed
    var updateTheme: (() -> Void)?  // callback
    
    private var nameButtons = [UIButton]()
    private var colorViews = [UIView]()
    private var pastBounds = CGRect.zero
    
    @IBOutlet weak var colorsLayoutArea: UIView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds != pastBounds {
            clearScreen()
            layoutThemesAndColors()
            pastBounds = view.bounds
        }
    }
    
    // clear all name buttons and color views (leave title label and Done button)
    private func clearScreen() {
        nameButtons.forEach { $0.removeFromSuperview() }
        nameButtons.removeAll()
        colorViews.forEach { $0.removeFromSuperview() }
        colorViews.removeAll()
    }

    // create nested grids with themes in the outer grid and colors in the inner grid
    private func layoutThemesAndColors() {
        // layout themes
        var themeGrid = Grid(layout: .aspectRatio(ColorConst.themeSectionAspectRatio), frame: colorsLayoutArea.frame)
        themeGrid.cellCount = Theme.allCases.count
        for row in 0..<themeGrid.dimensions.rowCount {
            for col in 0..<themeGrid.dimensions.columnCount {
                let themeIndex = row * themeGrid.dimensions.columnCount + col
                if themeIndex >= Theme.allCases.count { break }
                let theme = Theme.allCases[themeIndex]
                if let themeFrame = themeGrid[row, col] {
                    addNameForThemeIndex(themeIndex, origin: themeFrame.origin)
                    // layout colors
                    let inset = ColorConst.spaceBetweenThemes
                    let colorFrame = themeFrame.inset(by: UIEdgeInsets(top: 40, left: inset, bottom: inset, right: inset))  // leave room above for theme name
                    var colorGrid = Grid(layout: .aspectRatio(ColorConst.colorPatchAspectRatio), frame: colorFrame)
                    colorGrid.cellCount = Constant.numberOfColorSources
                    for row in 0..<colorGrid.dimensions.rowCount {
                        for col in 0..<colorGrid.dimensions.columnCount {
                            let colorIndex = row * colorGrid.dimensions.columnCount + col
                            if colorIndex >= Constant.numberOfColorSources { break }
                            if let colorFrame = colorGrid[row, col] {
                                let color = theme.color(colorIndex, of: Constant.numberOfColorSources)
                                addPatchForColor(color, frame: colorFrame)
                            }
                        }
                    }
                }
            }
        }
    }

    private func addNameForThemeIndex(_ index: Int, origin: CGPoint) {
        let theme = Theme.allCases[index]
        let nameButton = UIButton()
        nameButton.setTitle(theme.rawValue, for: .normal)
        nameButton.titleLabel?.font = UIFont(name: "Chalkboard SE Regular", size: 20)
        nameButton.sizeToFit()
        nameButton.frame.origin = origin
        nameButton.setTitleColor(.systemBlue, for: .normal)
        nameButton.tag = index
        nameButton.addTarget(self, action: #selector(selectTheme), for: .touchUpInside)
        nameButtons.append(nameButton)
        view.addSubview(nameButton)
    }
    
    private func addPatchForColor(_ color: UIColor, frame: CGRect) {
        let colorView = UIView(frame: frame)
        colorView.backgroundColor = color
        colorViews.append(colorView)
        view.addSubview(colorView)
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
