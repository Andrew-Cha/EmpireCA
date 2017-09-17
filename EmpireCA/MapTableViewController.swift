//
//  MapTableViewController.swift
//  EmpireCA
//
//  Created by Andrius on 9/16/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit

var imageName = UIImage(named: "")
class MapTableViewController: UITableViewController {
    
    @IBOutlet var mapTableView: UITableView!
    
    
    override func viewDidLoad() {
        mapTableView.delegate = self
        mapTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("cell at #\(indexPath.row) is selected!")
    }
}
