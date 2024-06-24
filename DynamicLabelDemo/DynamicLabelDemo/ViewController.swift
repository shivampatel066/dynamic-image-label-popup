//
//  ViewController.swift
//  DynamicLabelDemo
//
//  Created by Shivam Patel on 24/06/24.
//

import UIKit
import dynamicImageHeightLabelPopup

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func navigateToDemoPressed(_ sender: Any) {
        let topImage = UIImage(named: "rewardTopBanner")
        let midImage = UIImage(named: "rewardMidBanner")
        let bottomImage = UIImage(named: "rewardBottomBanner")
        DynamicLabelViewController.present(from: self, quoteText: "This is a dynamically adjusted height label!", topImage: topImage, midImage: midImage, bottomImage: bottomImage)
    }
    
}

