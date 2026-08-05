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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, theme) in Theme.allCases.enumerated() {
            let button = UIButton()
            button.center = CGPoint(x: 20, y: 100 + 40 * index)
            button.setTitle(theme.name, for: .normal)
            button.titleLabel?.font = UIFont(name: "Chalkboard SE Regular", size: 20)
            button.sizeToFit()
            button.setTitleColor(.systemBlue, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(selectTheme), for: .touchUpInside)
            view.addSubview(button)
        }
    }
    
    @objc private func selectTheme(_ sender: UIButton) {
        theme = Theme.allCases[sender.tag]
        updateTheme?()
        presentingViewController?.dismiss(animated: true)
    }
}
