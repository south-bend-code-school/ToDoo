//
//  NamedSnackbarController.swift
//  Todoo
//
//  Created by David Mattia on 2/20/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import Material

class NamedSnackbarController: SnackbarController {
    init(withTitle title: String, rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.preparePageTabBarItem(withTitle: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepare() {
        super.prepare()
        self.prepareNavigationItem()
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "DooFeed"
        navigationItem.titleLabel.font = UIFont(name: "Roboto", size: 24)
        navigationItem.detail = "Find Events, Personalized to You"
        navigationItem.titleLabel.textColor = Color.white
        navigationItem.detailLabel.textColor = Color.blueGrey.lighten4
    }
}

extension NamedSnackbarController {
    fileprivate func preparePageTabBarItem(withTitle title: String) {
        pageTabBarItem.title = title
        pageTabBarItem.titleColor = Color.blueGrey.base
    }
}
