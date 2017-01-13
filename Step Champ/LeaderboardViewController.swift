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
        self.tabBarItem.setTitleColor(color: setColor(colorCode: "78A942"), forState: .focused)
        let refreshControl = UIRefreshControl()
        navigationController?.tabBarItem.setTitleColor(color: setColor(colorCode: "78A942"), forState: .focused)
        leaderboardTable.addSubview(refreshControl)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Usercell") as? Usercell!
        
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // number of required sections
    }
}
