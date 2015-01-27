//
//  MessagingViewController.swift
//  Lingo
//
//  Created by William Gu on 1/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var textField: UITextField?
    var conversation: LYRConversation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButton(){
        //Send message
        sendMessage(textField?.text)
        
    }
    
    @IBAction func doneButton(){
        var feedbackVC = FeedbackViewController(nibName:"FeedbackViewController", bundle:nil);
        self.navigationController?.pushViewController(feedbackVC, animated: true);

    }

    func sendMessage(messageText: String!)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        //if no convo exists, create it w/ a single participant
        if (self.conversation == nil)
        {
            var error: NSError? = nil;
            let set = NSSet(array: ["TestUser"]);
            
            self.conversation = appDelegate.layerClient.newConversationWithParticipants(set, options: nil, error: &error);
            if (self.conversation == nil)
            {
                NSLog("New conversation created failed: %@", error!);
            }
        }
        var messagePart = LYRMessagePart(text: messageText);
        //Create and return new message object for convo
        var message = appDelegate.layerClient.newMessageWithParts([messagePart], options: [LYRMessageOptionsPushNotificationAlertKey: messageText], error: nil);
        //send specified message
        var error: NSError?
        var success: Bool? = self.conversation?.sendMessage(message, error: &error)
        if (success == true)
        {
            NSLog("Message queued to be sent: %@",messageText);
        }
        else
        {
            NSLog("Message send failed: %@", error!);
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
