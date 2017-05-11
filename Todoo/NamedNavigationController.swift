//
//  NamedNavigationController.swift
//  Todoo
//
//  Created by David Mattia on 2/20/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import UIKit
import Material

class NamedNavigationController: NavigationController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(withTitle title: String, rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.preparePageTabBarItem(withTitle: title)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
}

extension NamedNavigationController {
    fileprivate func preparePageTabBarItem(withTitle title: String) {
        pageTabBarItem.title = title
        pageTabBarItem.titleColor = hexStringToUIColor(hex: "61E480")
        
        self.navigationBar.backgroundColor = hexStringToUIColor(hex: "#4FBC69")
        self.navigationItem.titleLabel.textColor = Color.white
        self.navigationItem.detailLabel.textColor = Color.blueGrey.lighten4
    }
}
