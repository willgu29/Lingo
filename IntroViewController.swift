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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goButton() {
        
        
        if (textField.text.isEmpty)
        {
            //Alert: Please enter a name!
        }
        else
        {
            //Save name
            self.saveName()
            self.presentNextViewController()
        }
        
    }

    @IBAction func takeASelf() {
        
    }
    
    func saveName()
    {
        NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: "name");
        self.addDataToParse();
    }
    
    
    func presentNextViewController()
    {
        var whereWhenVC = WhereWhenViewController(nibName:"WhereWhenViewController", bundle:nil);
        var navigationController = UINavigationController(rootViewController: whereWhenVC);
        self.presentViewController(navigationController, animated: true, completion: nil);
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Save name
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
 
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        NSLog("Touches Began");
        textField.resignFirstResponder();
    }
    
    func addDataToParse()
    {
        
        var currentLocale = NSLocale.currentLocale()
        var currentDate = NSDate().descriptionWithLocale(currentLocale)
        
        var userInfo = PFObject(className: "Users")
        var deviceToken: NSString! = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as NSString;
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
