//
//  MatchViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController, PullFromParseDelegate, PushToParseDelegate {

    var pullFromParse = PullFromParseCloudCode()
    var myTimer: NSTimer?
    var timeOutTimer: NSTimer?
    var delegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    @IBOutlet var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        spinner?.startAnimating();
        spinner?.hidden = false;
    }

    @IBAction func cancelButton()
    {
        self.cancelTimer();
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func callbackFromCloudCodeReceived()
    {
        if (delegate.dataObject.clientType == 1)
        {
            NSLog("Client type 1");
            pullFromParse.delegate = self;
            self.myTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self.pullFromParse, selector:"clientOneFunction", userInfo: nil, repeats: true)
            self.timeOutTimer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: "cancelTimer", userInfo: nil, repeats: false)
        }
        else if (delegate.dataObject.clientType == 2)
        {
            NSLog("Client type 2");
            var messageVC = MessageViewController(nibName: "MessageViewController", bundle: nil);
            self.navigationController?.pushViewController(messageVC, animated: true);
        }
    }
    
    func cancelTimer() {
        spinner?.stopAnimating();
        NSLog("Cancel timers");
        self.myTimer?.invalidate();
        self.timeOutTimer?.invalidate();
        pullFromParse.deleteMatchFromParse();
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Delegate Methods (FOR CLIENTTYPE 1 USE)
    func matchFound() {
        NSLog("Match found!");
        var messageVC = MessageViewController(nibName: "MessageViewController", bundle: nil);
        self.cancelTimer();
        self.navigationController?.pushViewController(messageVC, animated: true);
    }
    
    func matchNotFound() {
        NSLog("No match found.. trying again");
    }
}
