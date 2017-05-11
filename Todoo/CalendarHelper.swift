//
//  CalendarHelper.swift
//  Todoo
//
//  Created by David Mattia on 2/20/17.
//  Copyright © 2017 south-bend-code-school. All rights reserved.
//

import Foundation
import EventKit

class CalendarHelper: NSObject {
    let eventStore = EKEventStore()
    
    func checkCalendarAuthorizationStatus(then completionHandler: @escaping () -> ()) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
            case EKAuthorizationStatus.notDetermined:
                // This happens on first-run
                self.requestAccessToCalendar(then: completionHandler)
            case EKAuthorizationStatus.authorized:
                // Things are in line with being able to show the calendars in the table view
                completionHandler()
            case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
                // We need to help them give us permission
                print("Failed to get permissions")
        }
    }
    
    internal func requestAccessToCalendar(then completionHandler: @escaping () -> ()) {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    completionHandler()
                })
            } else {
                print("Failed to grand access")
            }
        })
    }
}
