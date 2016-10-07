//
//  SearchViewController.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/23/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import UIKit
import Material
import SwiftyJSON

class SearchViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    @IBOutlet weak var toggleSwitch: UISegmentedControl!
    var results = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.titleLabel.textColor = setColor("ffffff")
        navigationController?.tabBarItem.setTitleColor(setColor("78A942"), forState: .Focused)
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
}

extension SearchViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count > 0 ? results.count: 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        if results.count > 0{
            var result = results[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell") as! SearchResultCell
            cell.realnameLabel.text = result["firstname"].stringValue + " " + result["lastname"].stringValue
            cell.usernameLabel.text = result["username"].stringValue
            
            let iconLetter1 = result["firstname"].stringValue.capitalizedString
            let iconLetter2 = result["lastname"].stringValue.capitalizedString
            
            cell.userIcon.text = iconLetter1[0]+iconLetter2[0]
            return cell

        }
        else if(results.count == 0 && searchBar.text?.length >= 3){
            let cell = tableView.dequeueReusableCellWithIdentifier("GenericResultCell") as! GenericResultCell
            
            switch toggleSwitch.selectedSegmentIndex {
            case 0:
                cell.textNote.text = "No Users matched the search term."
            case 1:
                cell.textNote.text = "No Step Teams matched the search term."
            default:
                cell.textNote.text = "No Results matched the search term."
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("GenericResultCell") as! GenericResultCell
            cell.textNote.text = "Use the search bar to find friends or Step Teams!"
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // number of required sections
    }
}

extension SearchViewController: UISearchBarDelegate{

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.length >= 3 {
            Endpoints.apiManager.searchUsers(searchText.trim()){ response in
                self.results = response.arrayValue
                print(self.results)
                self.searchResultsTable.reloadData()
            }
        }else{
            results.removeAll()
            searchResultsTable.reloadData()
        }
    }
}