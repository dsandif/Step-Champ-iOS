//
//  LeaderboardViewController.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/11/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import UIKit
import Material

class LeaderboardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var leaderboardTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.setTitleColor(setColor("78A942"), forState: .Focused)
        let refreshControl = UIRefreshControl()
        navigationController?.tabBarItem.setTitleColor(setColor("78A942"), forState: .Focused)
        leaderboardTable.addSubview(refreshControl)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Usercell") as? Usercell!
        
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // number of required sections
    }
}