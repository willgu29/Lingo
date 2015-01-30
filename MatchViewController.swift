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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //Callback
    func callbackFromCloudCodeReceived()
    {
        //NEED TO WAIT FOR CALLBACK
        if (delegate.dataObject.clientType == 1)
        {
            NSLog("Client type 1");
            //Setup Timer
            pullFromParse.delegate = self;
            self.myTimer = NSTimer.scheduledTimerWithTimeInterval(7, target: self.pullFromParse, selector:"clientOneFunction", userInfo: nil, repeats: true)
            self.timeOutTimer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: "cancelTimer", userInfo: nil, repeats: false)
        }
        else if (delegate.dataObject.clientType == 2)
        {
            NSLog("Client type 2");
            //Segue to Messaging
            var messageVC = MessageViewController(nibName: "MessageViewController", bundle: nil);
            self.navigationController?.pushViewController(messageVC, animated: true);
            
            
        }
        else
        {
            //FATAL ERROR
        }
    }
    
    func cancelTimer() {
        NSLog("Cancel timers");
        self.myTimer?.invalidate();
        self.timeOutTimer?.invalidate();
        pullFromParse.deleteMatchFromParse();
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func testButton() {
//
//        var pushParse = PushToParseCloudCode();
//        pushParse.pushToParseCloudCode();
//    }
    
    @IBAction func messageButton() {
        //Layer SDK or Parse SDK or Personal Implementation?
        var messageVC = MessageViewController(nibName:"MessageViewController", bundle:nil);
//        var messagingVC = MessagingViewController(nibName:"MessagingViewController", bundle:nil);
        self.navigationController?.pushViewController(messageVC, animated: true);
    }
    
    //Delegate Methods (FOR CLIENTTYPE 1 USE)
    func matchFound() {
        NSLog("Match found!");
        var messageVC = MessageViewController(nibName: "MessageViewController", bundle: nil);
        
        self.cancelTimer();
        //other username, other dining hall, other device token. DON"T MAKE CHAT ROOM, QUERY. LET CLIENT 2 MAKE CHATROOM SINCE THEY WILL GET RESULT QUICKER.
        
        self.navigationController?.pushViewController(messageVC, animated: true);
    }
    
    func matchNotFound() {
        NSLog("No match found.. trying again");
    }
}
