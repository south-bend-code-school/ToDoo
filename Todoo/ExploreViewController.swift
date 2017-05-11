//
//  ExploreViewController.swift
//  Todoo
//
//  Created by David Mattia on 3/1/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import UIKit
import Material

class ExploreViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Explore"
        navigationItem.titleLabel.font = UIFont(name: "Roboto", size: 24)
        navigationItem.detail = "See Trending Events"
        navigationItem.titleLabel.textColor = Color.white
        navigationItem.detailLabel.textColor = Color.blueGrey.lighten4
    }
}
