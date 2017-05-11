//
//  AppDelegate.swift
//  Todoo
//
//  Created by David Mattia on 2/20/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import UIKit
import Firebase
import Iconic
import IQKeyboardManagerSwift
import Material
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        FontAwesomeIcon.register()
        IQKeyboardManager.sharedManager().enable = true
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        self.signOut()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func prepareMainApplicationVC() -> PageTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        let tinderViewController = storyboard.instantiateViewController(withIdentifier: "TinderViewController")
        let exploreVC = storyboard.instantiateViewController(withIdentifier: "Explore")
        
        let feedViewController = NamedSnackbarController(withTitle: "ToDoo Feed", rootViewController: tinderViewController)
        
        let viewControllers = [
            NamedNavigationController(withTitle: "DooFeed", rootViewController: feedViewController),
            NamedNavigationController(withTitle: "Explore", rootViewController: exploreVC),
            NamedNavigationController(withTitle: "Profile", rootViewController: profileViewController),
            ]
        
        let tabBar = TodooPageTabBarController(viewControllers: viewControllers, selectedIndex: 0)
        return tabBar
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential) { (user: FIRUser?, error) in
            if let error = error {
                print(error)
                return
            }
            print("Signed in!")
            if user!.email!.hasSuffix("@nd.edu") {
                let netId = user!.email!.components(separatedBy: "@")[0]
                // check if netid exists in system already
                let ref = FIRDatabase.database().reference().child("users").child(netId)
                ref.observeSingleEvent(of: .value, with: {
                    (snapshot: FIRDataSnapshot) in
                    
                    if let values = snapshot.value as? [String: Any] {
                        print("Has account already")
                    } else {
                        ref.setValue([
                            "email": user!.email!,
                            "name": user!.displayName!,
                            "photo": user!.photoURL?.absoluteString
                        ])
                    }
                    let homeVC = self.prepareMainApplicationVC()
                    self.window?.rootViewController?.present(homeVC, animated: true, completion: nil)
                })
            } else {
                print("Must use a nd email address")
                self.signOut()
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            print("SIGNED OUT!!!")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        print("Signed In")
    }
}

