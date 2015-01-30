//
//  MatchViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController, PullFromParseDelegate {

    var pullFromParse = PullFromParseCloudCode()
    var myTimer: NSTimer?
    var timeOutTimer: NSTimer?
    var clientType: Int? //Either one or two
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (clientType == 1)
        {
            //Setup Timer
            self.myTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self.pullFromParse, selector:"clientOneFunction", userInfo: nil, repeats: true)
            self.timeOutTimer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: "cancelTimer", userInfo: nil, repeats: false)
        }
        else if (clientType == 2)
        {
            var delegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            //Segue to Messaging
            var messageVC = MessageViewController(nibName: "MessageViewController", bundle: nil);
            //Pass down proper variables
//            messageVC.diningHallOtherIntAsString = pullFromParse.diningHallOtherIntAsString
//            messageVC.deviceTokenOther = pullFromParse.deviceTokenOther
//            messageVC.usernameOther = pullFromParse.usernameOther
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
        var messageVC = MessageViewController(nibName: "MessageViewController", bundle: nil);
        
        
        //Since data is stored in AppDelegate, no need to pass down!
//        var delegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        //Pass down proper variables
//        messageVC.diningHallOtherIntAsString = delegate.dataObject.diningHallOtherAsStringInt
//        messageVC.deviceTokenOther = delegate
//        messageVC.usernameOther = pullFromParse.usernameOther
        //other username, other dining hall, other device token. DON"T MAKE CHAT ROOM, QUERY. LET CLIENT 2 MAKE CHATROOM SINCE THEY WILL GET RESULT QUICKER.
        
        self.navigationController?.pushViewController(messageVC, animated: true);
    }
    
    func matchNotFound() {
        
    }
}
