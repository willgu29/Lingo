//
//  PushToServer.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit


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
    var diningHall: Int = 0; //Defaulted at De Neve 
    var countdownHours: Int?
    var countdownMinutes: Int?
    
    
    
    func pushDataToServer() {
        NSLog("Dining Hall: %d, In hours: %d, in min: %d", diningHall, countdownHours!, countdownMinutes!)
        
    }
    
    func pushToParse() {
        
    }
    
    
    
}
