//
//  WhereWhenViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class WhereWhenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var diningHallPicker: UIPickerView!
    var dataSourcePicker: NSArray = ["De Neve", "B Plate", "Feast", "Covel", "Rende", "Cafe 1919", "B Cafe"]
    var pushToServerObject: PushToServer = PushToServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        datePicker?.datePickerMode = UIDatePickerMode.CountDownTimer;
        self.navigationController?.navigationBarHidden = true;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var delegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate;
//        delegate.dataObject.clientType = 0;
    }
    
    func setupValuesOfPickers() {
        datePicker.timeZone = NSTimeZone.localTimeZone()
        datePicker?.minimumDate = NSDate() //current date and time
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yayButton() {
        var delegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        
//        self.saveTimeData() No longer using timer for data
        pushToServerObject.pushDataToServer()
        
        //if eating right now
        pushNotificationToAdmins()
        //else
        //just schedule it and do notifcations later
        
        
        var matchVC = MatchViewController(nibName:"MatchViewController", bundle:nil);
        self.pushToServerObject.pushToCloud.delegate = matchVC;
        self.navigationController?.pushViewController(matchVC, animated: true);
    }
    
    func pushNotificationToAdmins() {
        var username = NSUserDefaults.standardUserDefaults().objectForKey("name") as NSString
        var pushQuery = PFInstallation.query();
        pushQuery.whereKey("isAdmin", equalTo: true);
        var push = PFPush();
        push.setQuery(pushQuery)
        var stringMessage = NSString(format: "%@ wants to eat right now!", username);
        push.setMessage(stringMessage);
        push.sendPushInBackgroundWithBlock { (var success: Bool!, var error: NSError!) -> Void in
            //blah
        }
    }
    
    func saveTimeData() {
        var duration: NSTimeInterval = datePicker.countDownDuration;
        var durationInt: Int = Int(duration);
        var hours: Int = durationInt/3600
        var minutes: Int = ((durationInt - (hours*3600))/60)
        pushToServerObject.countdownInterval = duration;
        pushToServerObject.countdownHours = hours;
        pushToServerObject.countdownMinutes = minutes;
    }
    
    
    //Dining Hall Picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Save dining hall
        NSLog("Picker row: %d", row);
        pushToServerObject.diningHall = row;
        
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let dataString = dataSourcePicker.objectAtIndex(row) as String;
        return NSAttributedString(string: dataString, attributes: [NSForegroundColorAttributeName:UIColor.blackColor()])
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourcePicker.count;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    //*********************
    
    //Date Picker
    
    
}
