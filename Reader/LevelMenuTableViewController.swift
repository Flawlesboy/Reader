//
//  LevelMenuTableViewController.swift
//  Reader
//
//  Created by мак on 10.07.17.
//  Copyright © 2017 мак. All rights reserved.
//

import UIKit
import SWRevealViewController
import Parse



class LevelMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var level = ""
        
        switch indexPath.row {
        case 0: return
        case 1: level = "elementary"
        case 2: level = "pre-intermediate"
        case 3: level = "intermediate"
        case 4: level = "upper-intermediate"
        case 5: level = "advanced"
        default: break
        }
        let nc = storyboard?.instantiateViewController(withIdentifier: "LevelBooks") as! UINavigationController
        let vc = nc.topViewController as! LevelBooks
        vc.level = level
        revealViewController().pushFrontViewController(nc, animated: true)
    }

}
