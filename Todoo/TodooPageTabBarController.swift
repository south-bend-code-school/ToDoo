//
//  TodooPageTabBarController.swift
//  Todoo
//
//  Created by David Mattia on 3/1/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import Foundation
import Material

class TodooPageTabBarController: PageTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTabBar.lineColor = Color.green.base
    }
}
