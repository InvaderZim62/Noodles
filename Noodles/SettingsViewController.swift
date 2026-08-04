//
//  SettingsViewController.swift
//  Noodles
//
//  Created by Phil Stern on 8/3/26.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var spotSize = 5.0 {
        didSet {
            spotSizeLabel?.text = "\(Int(spotSize))"
        }
    }
    var theme = 0

    var updateSettings: (() -> Void)?  // callback

    @IBOutlet weak var spotSizeSlider: UISlider!
    @IBOutlet weak var spotSizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spotSizeSlider.value = Float(spotSize)
        spotSizeLabel?.text = "\(Int(spotSize))"
    }
    
    @IBAction func spotSizeSelected(_ sender: UISlider) {
        spotSize = Double(sender.value)
        updateSettings?()
    }

    @IBAction func doneSelected(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
}
