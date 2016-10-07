//
//  SeachResultCell.swft.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/23/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import UIKit
import Material

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var searchResult: CardView!
    @IBOutlet weak var userActionBtn: UIButton!
    
    @IBOutlet weak var userIcon: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var realnameLabel: UILabel!
}

class GenericResultCell: UITableViewCell {
    
    @IBOutlet weak var backgroundLogo: UIImageView!
    
    @IBOutlet weak var textNote: UILabel!

}