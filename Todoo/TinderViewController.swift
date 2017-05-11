//
//  TinderViewController.swift
//  Todoo
//
//  Created by David Mattia on 2/20/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import UIKit
import Material
import Firebase
import Iconic

class TinderViewController: UIViewController {
    
    fileprivate var card: Card!
    
    fileprivate var toolbar: Toolbar!
    fileprivate var moreButton: IconButton!
    
    fileprivate var contentView: UILabel!
    
    fileprivate var bottomBar: Bar!
    fileprivate var dateFormatter: DateFormatter!
    fileprivate var dateLabel: UILabel!
    
    fileprivate var favoriteLabel: UILabel!
    fileprivate var favoriteButton: IconButton!
    
    fileprivate var dislikeButton: IconButton!

    
    var events = [Event]()
    var seenEvents = [Event]()
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
 
        if let event = self.event {
            self.update(forEvent: event)
        }
        
        let user = FIRAuth.auth()!.currentUser!
        print(user.displayName ?? "Not a named user")
        
        FIRDatabase.database().reference().child("events").observe(.childAdded, with: {
            (snapshot) in
            print(snapshot.value)
            let event = Event(snapshot: snapshot)
            self.events.append(event)
            self.updateEvent(event: event)
            
            self.favoriteButton.isEnabled = true
            self.dislikeButton.isEnabled = true
        })
    }
    
    func updateEvent(event: Event) {
        if self.event == nil {
            self.event = event
            update(forEvent: event)
        }
    }
    
    func getNewEvent() -> Event? {
        let all = Set<Event>(self.events)
        let seen = Set<Event>(self.seenEvents)
        let unseenEvents = all.subtracting(seen)
        if unseenEvents.count == 0 {
            return nil
        }
        
        return unseenEvents.first
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// View
extension TinderViewController {
    
    func prepareView() {
        view.backgroundColor = hexStringToUIColor(hex: "#61E480")
                
        prepareDateFormatter()
        prepareDateLabel()
        
        prepareDislikeButton()
        prepareFavoriteLabel()
        prepareFavoriteButton()
        
        prepareMoreButton()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        
        prepareImageCard()
    }
    
    fileprivate func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    fileprivate func prepareDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.text = dateFormatter.string(from: Date.distantFuture)
    }
    
    fileprivate func prepareFavoriteLabel() {
        favoriteLabel = UILabel()
        favoriteLabel.font = RobotoFont.regular(with: 12)
        favoriteLabel.textColor = Color.blueGrey.base
        favoriteLabel.text = "Add to calendar"
    }
    
    fileprivate func prepareDislikeButton() {
        let iconSize = CGSize(width: 20, height: 20)
        dislikeButton = IconButton(image: FontAwesomeIcon.minus.image(ofSize: iconSize, color: Color.red.base), tintColor: Color.red.base)
        
        dislikeButton.addTarget(self, action: #selector(dislikeClicked(sender:)), for: .touchUpInside)
    }
    
    fileprivate func prepareFavoriteButton() {
        //favoriteButton = IconButton(image: Icon.add, tintColor: Color.red.base)
        let iconSize = CGSize(width: 20, height: 20)

        favoriteButton = IconButton(image: FontAwesomeIcon.plus.image(ofSize: iconSize, color: Color.green.base), tintColor: Color.green.base)

        favoriteButton.addTarget(self, action: #selector(favoriteClicked(sender:)), for: .touchUpInside)
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareToolbar() {
        toolbar = Toolbar(rightViews: [])
        
        
        toolbar.title = "Material"
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Build Beautiful Software"
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.blueGrey.base
    }
    
    fileprivate func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "Material is an animation and graphics framework that is used to create beautiful applications."
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    fileprivate func prepareBottomBar() {
        bottomBar = Bar()
        
        bottomBar.leftViews = [dislikeButton]
        bottomBar.rightViews = [favoriteButton]
    }
    
    fileprivate func prepareImageCard() {
        card = Card()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square3
        card.toolbarEdgeInsets.bottom = 0
        card.toolbarEdgeInsets.right = 8
        
        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .wideRectangle3
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        
        view.layout(card).horizontally(left: 20, right: 20).center()
        Layout.size(parent: card, child: card.contentView!, size: CGSize(width: card.contentView!.frame.width, height: card.contentView!.frame.height * 5))
    }
}

// Updates
extension TinderViewController {
    func favoriteClicked(sender: IconButton!) {
        print("Favorited")
        self.event?.addToCalendar()
        self.createSnackbar(withText: "Added to Calendar!")
        
        self.event = self.getNewEvent()
        self.update(forEvent: self.event)
    }
    
    func dislikeClicked(sender: IconButton!) {
        print("Disliked")
        self.event = self.getNewEvent()
        self.update(forEvent: self.event)
    }
    
    func update(forEvent event: Event?) {
        if let e = event {
            toolbar.title = e.title
            toolbar.detail = e.location
            contentView.text = e.description
            
            self.seenEvents.append(e)
        } else {
            let defaultEvent = Event(title: "No Events Found", time: "none", description: "You're all caught up!", location: "")
            self.update(forEvent: defaultEvent)
            self.favoriteButton.isEnabled = false
            self.dislikeButton.isEnabled = false
        }
    }
}

// Snackbar
extension TinderViewController {
    func createSnackbar(withText text: String) {
        prepareSnackbar(text: text)
        animateSnackbar()
    }
    
    fileprivate func prepareSnackbar(text: String) {
        guard let snackbar = snackbarController?.snackbar else {
            return
        }
        
        snackbar.text = text
    }
    
    @objc
    fileprivate func animateSnackbar() {
        guard let sc = snackbarController else {
            return
        }
        
        _ = sc.animate(snackbar: .visible, delay: 0)
        _ = sc.animate(snackbar: .hidden, delay: 4)
    }
}
