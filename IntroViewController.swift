//
//  IntroViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var textField: UITextField!
    @IBOutlet var lingoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lingoButton.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goButton() {
        
        if (textField.text.isEmpty)
        {
            //TODO: Alert Please enter a name!
        } else {
            self.saveName()
            self.presentNextViewController()
        }
    }

    @IBAction func takeASelf() {
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if ( !textField.text.isEmpty)
        {
            lingoButton.alpha = 0.0;
            lingoButton.hidden = false;
            UIView.animateWithDuration(1.5, animations: {
                self.lingoButton.alpha = 1.0
            })
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
 
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        NSLog("Touches Began");
        textField.resignFirstResponder();
    }
    
   
    func saveName() {
        NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: "name");
        var currentLocale = NSLocale.currentLocale()
        var currentDate = NSDate().descriptionWithLocale(currentLocale)
        
        var userInfo = PFObject(className: "Users")
        var deviceToken: NSString = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as NSString;
        var userName: NSString = NSUserDefaults.standardUserDefaults().objectForKey("name") as NSString;
        userInfo.setObject(deviceToken, forKey: "deviceToken")
        userInfo.setObject(userName, forKey: "name")
        userInfo.setObject(-1, forKey: "status");
        //        userInfo.setObject(currentDate, forKey: "timeDate");
        userInfo.setObject(-1, forKey: "diningHall");
        userInfo.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                NSLog("Object created with id: \(userInfo.objectId)")
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    
    func presentNextViewController() {
        var whereWhenVC = WhereWhenViewController(nibName:"WhereWhenViewController", bundle:nil);
        var navigationController = UINavigationController(rootViewController: whereWhenVC);
        self.presentViewController(navigationController, animated: true, completion: nil);
    }
    


}
