//
//  ErrorPopupViewController.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/17/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import UIKit
import Material

class ErrorPopupViewController: UIViewController {
    @IBOutlet weak var popupView: CardView!
    
    var popupMessage: String = ""
    var popupLabel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = popupMessage
        titleLabel.textColor = MaterialColor.blue.darken1
        titleLabel.font = RobotoFont.mediumWithSize(20)
        popupView.titleLabel = titleLabel
        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = popupLabel
        detailLabel.numberOfLines = 0
        popupView.contentView = detailLabel
        
        // okay button.
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = MaterialColor.blue.lighten1
        btn1.setTitle("OKAY", for: .normal)
        btn1.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
        btn1.addTarget(self, action: #selector(okayButtonPressed), for: .touchUpInside)
        // Add buttons to left side.
        popupView.leftButtons = [btn1]
    }
    
    @IBAction func okayButtonPressed(sender: FlatButton){
        
        self.dismiss(animated: true, completion: nil)
    }
}
