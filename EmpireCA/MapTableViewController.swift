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
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell at #\(indexPath.row) is selected!")
    }
}
