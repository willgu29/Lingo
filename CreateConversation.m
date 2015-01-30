//
//  CreateConversation.m
//  Lingo
//
//  Created by William Gu on 1/29/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "CreateConversation.h"
#import <LayerKit/LayerKit.h>
#import "AppDelegate.h"

@implementation CreateConversation




//CLIENT TWO CALL
-(void)createDefaultConversationWith:(NSString *)deviceTokenOther
{
    NSString *deviceTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSError *error = nil;
    _conversation = [delegate.layerClient newConversationWithParticipants:[NSSet setWithArray:@[deviceTokenString, deviceTokenOther, @"Simulator", @ "Dashboard" ]] options:nil error:&error];
}



-(void)layerDefaultConversation
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

    if (!self.conversation) {
        NSError *error = nil;
        _conversation = [delegate.layerClient newConversationWithParticipants:[NSSet setWithArray:@[ @"Simulator", @ "Dashboard" ]] options:nil error:&error];
        if (!self.conversation) {
            NSLog(@"New Conversation creation failed: %@", error);
        }
    }

}

-(void)testMessage{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        // If no conversations exist, create a new conversation object with two participants
        if (!self.conversation) {
            NSError *error = nil;
            self.conversation = [delegate.layerClient newConversationWithParticipants:[NSSet setWithArray:@[ @"Simulator", @ "Dashboard" ]] options:nil error:&error];
            if (!self.conversation) {
                NSLog(@"New Conversation creation failed: %@", error);
            }
        }
        
        // Creates a message part with text/plain MIME Type
        LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:@"TEST"];
        
        // Creates and returns a new message object with the given conversation and array of message parts
        LYRMessage *message = [delegate.layerClient newMessageWithParts:@[messagePart] options:@{LYRMessageOptionsPushNotificationAlertKey: @"TEST"} error:nil];
        
        // Sends the specified message
        NSError *error;
        BOOL success = [self.conversation sendMessage:message error:&error];
        if (success) {
            NSLog(@"Message queued to be sent: TEST");
        } else {
            NSLog(@"Message send failed: %@", error);
        }
}

-(void)sendMessage:(NSString *)textString
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    // Creates a message part with text/plain MIME Type
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:textString];
    
    // Creates and returns a new message object with the given conversation and array of message parts
    LYRMessage *message = [delegate.layerClient newMessageWithParts:@[messagePart] options:@{LYRMessageOptionsPushNotificationAlertKey: textString} error:nil];
    
    // Sends the specified message
    NSError *error;
    BOOL success = [self.conversation sendMessage:message error:&error];
    if (success) {
        NSLog(@"Message queued to be sent: %@", textString);
    } else {
        NSLog(@"Message send failed: %@", error);
    }
}



@end
