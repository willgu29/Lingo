//
//  SendMessages.swift
//  Lingo
//
//  Created by William Gu on 1/26/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class SendMessages: NSObject {
   
    var conversation: LYRConversation!

    
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
    
    
}
