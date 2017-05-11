//
//  ViewController.swift
//  Todoo
//
//  Created by David Mattia on 2/20/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import UIKit
import Firebase
import Material


class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorField: TextField!
    @IBOutlet weak var minorField: TextField!
    var user: FIRUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
        self.prepareForUser(user: FIRAuth.auth()!.currentUser!)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let user = FIRAuth.auth()!.currentUser!
        let netId = user.email!.components(separatedBy: "@")[0]
        FIRDatabase.database().reference()
            .child("users")
            .child(netId)
            .updateChildValues([
                "major": self.majorField.text!,
                "minor": self.minorField.text!
                ])
    }
}

// View
extension ViewController {
    func prepareView() {
        self.prepareNavigationItem()
    }
    
    fileprivate func prepareForUser(user: FIRUser!) {
        let netId = user.email!.components(separatedBy: "@")[0]
        
        self.nameLabel.text = "Welcome, \(user.displayName!)!"
        
        FIRDatabase.database().reference()
            .child("users")
            .child(netId)
            .child("major")
            .observeSingleEvent(of: .value, with: {
                (snapshot) in
                self.majorField.text = snapshot.value as? String
            })
        
        FIRDatabase.database().reference()
            .child("users")
            .child(netId)
            .child("minor")
            .observeSingleEvent(of: .value, with: {
                (snapshot) in
                self.minorField.text = snapshot.value as? String
            })
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "Profile"
        navigationItem.titleLabel.font = UIFont(name: "Roboto", size: 24)
        navigationItem.detail = "Edit your information"
        navigationItem.titleLabel.textColor = Color.white
        navigationItem.detailLabel.textColor = Color.blueGrey.lighten4
    }
}

