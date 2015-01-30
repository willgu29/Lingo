//
//  PushToServer.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

enum UserStatus: Int {
    case notDining = -1
    case justPushed = 0
    case scheduled = 1
    case inMessaging = 2
}

enum DiningHalls: Int {
    
    case DeNeve = 0
    case BPlate = 1
    case Feast = 2
    case Covel = 3
    case Rende = 4
    case Cafe1919 = 5
    case BCafe = 6
    
    
}

class PushToServer: NSObject {
   
    //These values will be set in WhereWhenViewController via pickers
    var pushToCloud = PushToParseCloudCode();
    var diningHall: Int = 0; //Defaulted at De Neve
    var countdownInterval: NSTimeInterval?
    var countdownHours: Int?
    var countdownMinutes: Int?
    
    
    
    func pushDataToServer() {
        NSLog("Dining Hall: %d, In hours: %d, in min: %d, in duration: %d", diningHall, countdownHours!, countdownMinutes!, countdownInterval!)
//        self.pushToParseUsers()
        
        pushToCloud.diningHall = Int32(diningHall);
        pushToCloud.pushToParseCloudCode();
    }
    
    func pushToParseMatch() {
        
    }
    
    
    func pushToParseUsers() {
        var query = PFQuery(className: "Users");
        var deviceToken: NSString = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as NSString
        query.whereKey("deviceToken", equalTo: deviceToken);
        var objectFetched = query.getFirstObject()
        objectFetched.setObject(0, forKey: "status")
        
        var laterDate: NSDate = NSDate(timeInterval: self.countdownInterval!, sinceDate: NSDate())
        
        //ALL NSDATES ARE IN GMT TIME ZONE. ASSUME GMT TIME ZONE.
//        var currentLocale = NSLocale.currentLocale()
//        var laterDateCurrentLocale = laterDate.descriptionWithLocale(currrentLocale)
        
        NSLog("Date: %@, Now Date: %@", laterDate, NSDate())
        
        objectFetched.setObject(laterDate, forKey: "timeDate");
//        objectFetched.setValue(self.diningHall, forKey: "diningHall");
        objectFetched.setObject(self.diningHall, forKey: "diningHall");
        objectFetched.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                NSLog("Object created with id: \(objectFetched.objectId)")
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    
    
}
