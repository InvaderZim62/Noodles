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
    var theme = Theme.grayAndRed
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

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Colors" {
            if let cvc = segue.destination as? ColorsViewController {
                cvc.theme = theme
                // provide callback for settings change
                cvc.updateTheme = { [weak self] in
                    self?.theme = cvc.theme
                    self?.updateSettings?()
                }
            }
        }
    }
}
