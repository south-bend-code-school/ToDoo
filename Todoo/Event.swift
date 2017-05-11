//
//  Event.swift
//  Todoo
//
//  Created by David Mattia on 2/20/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import Foundation
import Firebase
import EventKit

class Event: Hashable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description && lhs.time == rhs.time
    }

    internal var title : String?
    internal var time : String?
    internal var description : String?
    internal var location : String?
    
    var hashValue: Int {
        if let t = title,
            let d = description {
            return t.hashValue ^ d.hashValue
        }
        return title!.hashValue
    }
    
    init(title: String, time: String, description: String, location: String) {
        self.time = time
        self.title = title
        self.description = description
        self.location = location
    }
    
    init(snapshot: FIRDataSnapshot) {
        guard let value = snapshot.value as? NSDictionary else {
            return
        }
        
        self.title = value["title"] as? String
        self.description = value["description"] as? String
        self.time = value["time"] as? String
        self.location = value["location"] as? String
    }
    
    internal func data() -> [String: String?] {
        return [
            "title": self.title,
            "description": self.description,
            "time": self.time,
            "location": self.location,
        ]
    }
    
    func addToCalendar() {
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        CalendarHelper().checkCalendarAuthorizationStatus {
            eventStore.requestAccess(to: .event) { (granted, error) in
                
                if (granted) && (error == nil) {
                    print("granted \(granted)")
                    print("error \(error)")
                    
                    let event:EKEvent = EKEvent(eventStore: eventStore)
                    
                    event.title = self.title!
                    event.startDate = Date()
                    event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: event.startDate)!
                    event.notes = self.description!
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    print("Saved Event")
                }
                else{
                    
                    print("failed to save event with error : \(error) or access not granted")
                }
            }
        }
        
    }
    
    func push() {
        print("PUSHING")
        FIRDatabase.database().reference().child("events")
            .childByAutoId().setValue(self.data())
    }
}
